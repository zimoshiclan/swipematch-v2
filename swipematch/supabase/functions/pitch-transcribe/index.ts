// =============================================================================
// pitch-transcribe
// Accepts { profileId, videoUrl }, transcribes the audio, writes the result
// back to profiles.video_pitch_transcript and merges extracted skills into
// profiles.skills.
//
// Implementation note:
//   This function ships with an adapter interface so the STT provider can be
//   swapped without touching callers. Default adapter is "stub" which returns
//   a placeholder transcript and skips skill extraction — replace with a real
//   adapter (OpenAI Whisper, Deepgram, Google STT, etc.) by setting the
//   TRANSCRIBE_PROVIDER env var and adding the matching adapter below.
// =============================================================================

import { createClient } from "npm:@supabase/supabase-js@2";
import Anthropic from "npm:@anthropic-ai/sdk";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface TranscribeResult {
  transcript: string;
}

async function transcribe(videoUrl: string): Promise<TranscribeResult> {
  const provider = Deno.env.get("TRANSCRIBE_PROVIDER") ?? "stub";
  switch (provider) {
    case "openai":
      return openAiWhisper(videoUrl);
    case "stub":
    default:
      return {
        transcript:
          "Transcript pending — configure TRANSCRIBE_PROVIDER on the project.",
      };
  }
}

// OpenAI Whisper adapter. Requires OPENAI_API_KEY.
async function openAiWhisper(videoUrl: string): Promise<TranscribeResult> {
  const apiKey = Deno.env.get("OPENAI_API_KEY");
  if (!apiKey) throw new Error("OPENAI_API_KEY not configured");

  // Download the video bytes.
  const videoRes = await fetch(videoUrl);
  if (!videoRes.ok) throw new Error(`Fetch failed: ${videoRes.status}`);
  const videoBlob = await videoRes.blob();

  const formData = new FormData();
  formData.append("file", videoBlob, "pitch.mp4");
  formData.append("model", "whisper-1");

  const res = await fetch("https://api.openai.com/v1/audio/transcriptions", {
    method: "POST",
    headers: { Authorization: `Bearer ${apiKey}` },
    body: formData,
  });
  if (!res.ok) throw new Error(`Whisper error: ${res.status}`);
  const data = await res.json();
  return { transcript: (data.text ?? "").trim() };
}

// Ask Claude to pull a clean skills list from the transcript so the profile
// search/match pipeline can use it. Returns an empty list on failure.
async function extractSkills(transcript: string): Promise<string[]> {
  if (transcript.length < 20) return [];
  const apiKey = Deno.env.get("ANTHROPIC_API_KEY");
  if (!apiKey) return [];

  try {
    const anthropic = new Anthropic({ apiKey });
    const message = await anthropic.messages.create({
      model: "claude-sonnet-4-20250514",
      max_tokens: 256,
      messages: [
        {
          role: "user",
          content: `Extract a list of professional skills mentioned in this 60-second pitch transcript. Return ONLY a JSON array of short skill names (e.g. ["React", "Project Management"]). No prose, no markdown.

Transcript:
${transcript}`,
        },
      ],
    });
    const text =
      message.content[0].type === "text" ? message.content[0].text : "[]";
    const parsed = JSON.parse(text);
    if (!Array.isArray(parsed)) return [];
    return parsed
      .map((s) => String(s).trim())
      .filter((s) => s.length > 0 && s.length < 40);
  } catch {
    return [];
  }
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { profileId, videoUrl } = await req.json();
    if (!profileId || !videoUrl) {
      return json({ error: "profileId and videoUrl required" }, 400);
    }

    // SSRF guard: only accept URLs that live on the project's own Supabase
    // Storage host. Without this, a caller could point us at any URL on the
    // public internet (cost amplification, internal-network probing, etc.).
    const projectUrl = Deno.env.get("SUPABASE_URL")!;
    let parsed: URL;
    try {
      parsed = new URL(videoUrl);
    } catch {
      return json({ error: "videoUrl is not a valid URL" }, 400);
    }
    const projectHost = new URL(projectUrl).hostname;
    if (parsed.hostname !== projectHost) {
      return json({ error: "videoUrl must be a Supabase Storage URL" }, 400);
    }
    if (!parsed.pathname.includes("/storage/v1/object/public/pitches/")) {
      return json({ error: "videoUrl must point at the pitches bucket" }, 400);
    }
    // Defense-in-depth: enforce that the URL lives under the claimed
    // profile's folder. Storage RLS on the upload side already enforces this,
    // but we re-check so a caller can't fan out transcripts across profiles.
    if (!parsed.pathname.includes(`/pitches/${profileId}/`)) {
      return json({ error: "videoUrl does not match profileId" }, 400);
    }

    const supabase = createClient(
      projectUrl,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    const { transcript } = await transcribe(videoUrl);
    const extractedSkills = await extractSkills(transcript);

    // Merge extracted skills with whatever the candidate already has.
    let newSkills: string[] | null = null;
    if (extractedSkills.length > 0) {
      const { data: profile } = await supabase
        .from("profiles")
        .select("skills")
        .eq("id", profileId)
        .maybeSingle();
      const existing = (profile?.skills ?? []) as string[];
      const merged = new Set<string>([...existing, ...extractedSkills]);
      newSkills = Array.from(merged);
    }

    const update: Record<string, unknown> = {
      video_pitch_transcript: transcript,
    };
    if (newSkills !== null) update.skills = newSkills;

    await supabase.from("profiles").update(update).eq("id", profileId);

    return json({ transcript, extractedSkills });
  } catch (err) {
    return json({ error: String(err) }, 500);
  }
});

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
