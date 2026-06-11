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
    const { profileId, question, conversationHistory = [] } = await req.json();
    if (!profileId || !question) {
      return json({ error: "Missing profileId or question" }, 400);
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    const { data: profile } = await supabase
      .from("profiles")
      .select(
        "name, skills, work_style, job_search_timeline, experience_years, persona, connection_intents, working_toward, currently_learning, city, country, culture_tags"
      )
      .eq("id", profileId)
      .single();

    if (!profile) {
      return json({ error: "Profile not found" }, 404);
    }

    const anthropic = new Anthropic({
      apiKey: Deno.env.get("ANTHROPIC_API_KEY")!,
    });

    const systemPrompt = `You are an expert networking and growth coach inside SwipeMatch, an app where people connect with each other to grow — students, founders, creators, professionals, and more.

The person you're coaching:
- Name: ${profile.name}
- Persona: ${profile.persona ?? "not set"}
- Looking for: ${(profile.connection_intents ?? []).join(", ") || "open to connections"}
- Skills: ${(profile.skills ?? []).join(", ")}
- Working toward: ${profile.working_toward ?? "not set"}
- Currently learning: ${profile.currently_learning ?? "not set"}
- Location: ${[profile.city, profile.country].filter(Boolean).join(", ") || "not set"}
- Work style preference: ${profile.work_style ?? "not set"}
- Experience: ${profile.experience_years ?? "not specified"} years
- Values: ${(profile.culture_tags ?? []).join(", ")}

Be concise (3-5 sentences max), actionable, and encouraging. Focus on practical advice for making meaningful connections and growing toward their goals.`;

    // Build message history from conversation
    const messages: Array<{ role: "user" | "assistant"; content: string }> = [
      ...conversationHistory,
      { role: "user", content: question },
    ];

    const response = await anthropic.messages.create({
      model: "claude-sonnet-4-20250514",
      max_tokens: 300,
      system: systemPrompt,
      messages,
    });

    const reply =
      response.content[0].type === "text" ? response.content[0].text : "";

    return json({ reply, inputTokens: response.usage.input_tokens });
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
