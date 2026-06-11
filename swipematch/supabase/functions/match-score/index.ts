import Anthropic from "npm:@anthropic-ai/sdk";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { candidateId, jobId } = await req.json();
    if (!candidateId || !jobId) {
      return json({ error: "Missing candidateId or jobId" }, 400);
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    const [{ data: candidate }, { data: job }] = await Promise.all([
      supabase
        .from("profiles")
        .select("name, skills, work_style, experience_years")
        .eq("id", candidateId)
        .single(),
      supabase
        .from("jobs")
        .select(
          "title, required_skills, work_style, experience_years, company_id, companies(name)"
        )
        .eq("id", jobId)
        .single(),
    ]);

    if (!candidate || !job) {
      return json({ error: "Profile or job not found" }, 404);
    }

    const anthropic = new Anthropic({
      apiKey: Deno.env.get("ANTHROPIC_API_KEY")!,
    });

    const companyName = (job.companies as { name: string } | null)?.name ?? "Company";

    const prompt = `You are an expert job matching AI. Score this match using exact point values.

CANDIDATE:
- Skills: ${(candidate.skills ?? []).join(", ")}
- Work style: ${candidate.work_style ?? "any"}
- Experience: ${candidate.experience_years ?? 0} years

JOB at ${companyName}:
- Title: ${job.title}
- Required skills: ${(job.required_skills ?? []).join(", ")}
- Work style: ${job.work_style}
- Required experience: ${job.experience_years} years

Scoring (exact maxima):
- skills: max 50 pts — count overlapping skills divided by required skills, multiply by 50
- work_style: max 30 pts — 30 if exact match, 15 if hybrid↔remote, 0 if on_site mismatch
- experience: max 20 pts — 20 if within 1yr, 13 within 2yr, 7 within 3yr, 0 beyond

Return ONLY valid JSON, no markdown fences:
{
  "overall_score": <integer 0-100>,
  "dimensions": {
    "skills": { "score": <0-50>, "reason": "<1 sentence>" },
    "work_style": { "score": <0-30>, "reason": "<1 sentence>" },
    "experience": { "score": <0-20>, "reason": "<1 sentence>" }
  },
  "coaching_tip": "<1-2 sentences of actionable advice for the candidate>",
  "match_summary": "<2 sentences explaining this match>"
}`;

    let scoreData: {
      overall_score: number;
      dimensions: {
        skills: { score: number; reason: string };
        work_style: { score: number; reason: string };
        experience: { score: number; reason: string };
      };
      coaching_tip: string;
      match_summary: string;
    };

    try {
      const message = await anthropic.messages.create({
        model: "claude-sonnet-4-20250514",
        max_tokens: 512,
        messages: [{ role: "user", content: prompt }],
      });
      const text =
        message.content[0].type === "text" ? message.content[0].text : "{}";
      scoreData = JSON.parse(text);
    } catch (_err) {
      // Briefing §04 fallback: deterministic keyword overlap so a Claude
      // outage never blocks a swipe from resolving.
      scoreData = computeFallback(candidate, job);
    }

    const matchReason = {
      overall_score: scoreData.overall_score,
      skills: scoreData.dimensions.skills,
      work_style: scoreData.dimensions.work_style,
      experience: scoreData.dimensions.experience,
      coaching_tip: scoreData.coaching_tip,
      match_summary: scoreData.match_summary,
    };

    const MATCH_THRESHOLD = 50;

    if (scoreData.overall_score >= MATCH_THRESHOLD) {
      const { data: existing } = await supabase
        .from("matches")
        .select("id")
        .eq("candidate_id", candidateId)
        .eq("job_id", jobId)
        .maybeSingle();

      if (!existing) {
        const { data: newMatch } = await supabase
          .from("matches")
          .insert({
            candidate_id: candidateId,
            job_id: jobId,
            company_id: job.company_id,
            match_score: scoreData.overall_score,
            match_reason: matchReason,
            status: "new_match",
          })
          .select("id")
          .single();

        return json({
          matchId: newMatch?.id ?? null,
          score: scoreData.overall_score,
          matchReason,
          isNewMatch: true,
        });
      } else {
        await supabase
          .from("matches")
          .update({ match_score: scoreData.overall_score, match_reason: matchReason })
          .eq("id", existing.id);

        return json({
          matchId: existing.id,
          score: scoreData.overall_score,
          matchReason,
          isNewMatch: false,
        });
      }
    }

    return json({
      matchId: null,
      score: scoreData.overall_score,
      matchReason,
      isNewMatch: false,
    });
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

interface CandidateLike {
  skills?: string[];
  work_style?: string;
  experience_years?: number;
}

interface JobLike {
  required_skills?: string[];
  work_style?: string;
  experience_years?: number;
}

// Deterministic fallback scorer. Mirrors the briefing's keyword-overlap spec
// and never throws.
function computeFallback(candidate: CandidateLike, job: JobLike) {
  const candSkills = (candidate.skills ?? []).map((s) => s.toLowerCase());
  const reqSkills = (job.required_skills ?? []).map((s) => s.toLowerCase());
  const overlap = reqSkills.filter((s) => candSkills.includes(s));
  const skillsScore =
    reqSkills.length === 0
      ? 0
      : Math.min(50, Math.round((overlap.length / reqSkills.length) * 50));

  // Work style: exact = 30, remote↔hybrid = 15, on_site mismatch = 0.
  let workScore = 0;
  const cw = candidate.work_style;
  const jw = job.work_style;
  if (cw && jw) {
    if (cw === jw) {
      workScore = 30;
    } else if (
      (cw === "remote" && jw === "hybrid") ||
      (cw === "hybrid" && jw === "remote")
    ) {
      workScore = 15;
    }
  }

  // Experience: within 1y full 20, within 2y 13, within 3y 7, else 0.
  let expScore = 0;
  const ce = candidate.experience_years ?? 0;
  const je = job.experience_years ?? 0;
  const diff = Math.abs(ce - je);
  if (diff <= 1) expScore = 20;
  else if (diff <= 2) expScore = 13;
  else if (diff <= 3) expScore = 7;

  const total = skillsScore + workScore + expScore;

  return {
    overall_score: total,
    dimensions: {
      skills: {
        score: skillsScore,
        reason: `${overlap.length}/${reqSkills.length} required skills matched`,
      },
      work_style: {
        score: workScore,
        reason: workScore === 30
          ? "Work style is an exact match"
          : workScore === 15
            ? "Work style is flexible-compatible"
            : "Work style mismatch",
      },
      experience: {
        score: expScore,
        reason: `Experience difference: ${diff} year(s)`,
      },
    },
    coaching_tip:
      "Add the missing required skills to your profile to lift this score.",
    match_summary:
      "Score generated by the offline fallback scorer (Claude unavailable).",
  };
}
