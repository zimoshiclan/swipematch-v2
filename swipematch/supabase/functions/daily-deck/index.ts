import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

const HOT_JOB_COUNT = 2; // Mark top N jobs as "hot" in each deck
const DECK_SIZE = 15;

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { profileId } = await req.json();
    if (!profileId) {
      return json({ error: "Missing profileId" }, 400);
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    // Fetch already-swiped job IDs
    const { data: swipes } = await supabase
      .from("swipes")
      .select("target_id")
      .eq("user_id", profileId)
      .eq("target_type", "job");

    const swipedIds = (swipes ?? []).map((s: { target_id: string }) => s.target_id);

    // Fetch active jobs
    const { data: jobs, error } = await supabase
      .from("jobs")
      .select("*, companies(name, logo_url, culture_tags, tech_stack)")
      .eq("is_active", true)
      .order("created_at", { ascending: false })
      .limit(50);

    if (error) return json({ error: error.message }, 500);

    // Filter unswiped
    const unswiped = (jobs ?? [])
      .filter((j: { id: string }) => !swipedIds.includes(j.id))
      .slice(0, DECK_SIZE);

    // Apply "hot" flag to first HOT_JOB_COUNT cards
    const deck = unswiped.map((job: Record<string, unknown>, i: number) => {
      const company = job.companies as Record<string, unknown> | null;
      return {
        ...job,
        company_name: company?.name,
        company_logo_url: company?.logo_url,
        companies: undefined,
        is_hot: i < HOT_JOB_COUNT,
        // Simulate applicant count for social proof
        applicant_count: Math.floor(Math.random() * 40) + 5,
      };
    });

    return json({ deck, count: deck.length });
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
