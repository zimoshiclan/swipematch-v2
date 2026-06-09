// =============================================================================
// ghost-sweep
// Cron-invoked (hourly recommended). Marks any match where 72h has elapsed
// since creation without an employer response as ghosted and decrements the
// company's ghost_score by 5 (floor 0).
//
// Schedule via pg_cron:
//   select cron.schedule(
//     'ghost-sweep-hourly',
//     '17 * * * *',
//     $$ select net.http_post(
//          url := 'https://<project-ref>.supabase.co/functions/v1/ghost-sweep',
//          headers := jsonb_build_object('Authorization', 'Bearer ' || current_setting('app.settings.service_role_key'))
//        ) $$
//   );
// =============================================================================

import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

const GHOST_WINDOW_HOURS = 72;
const GHOST_PENALTY = 5;

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  // Defense-in-depth: if the function is deployed with --no-verify-jwt (which
  // is how cron-only functions are usually deployed) we still want to reject
  // anonymous internet callers. Require either:
  //   - a service-role bearer token in Authorization, OR
  //   - a matching x-cron-secret header (configure `CRON_SECRET` env on the project).
  const auth = req.headers.get("authorization") ?? "";
  const cronSecret = req.headers.get("x-cron-secret") ?? "";
  const serviceRole = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
  const expectedCronSecret = Deno.env.get("CRON_SECRET") ?? "";

  const isServiceRole =
    serviceRole.length > 0 && auth === `Bearer ${serviceRole}`;
  const isCronAuthed =
    expectedCronSecret.length > 0 && cronSecret === expectedCronSecret;

  if (!isServiceRole && !isCronAuthed) {
    return json({ error: "Unauthorized" }, 401);
  }

  try {
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      serviceRole
    );

    const cutoff = new Date(
      Date.now() - GHOST_WINDOW_HOURS * 60 * 60 * 1000
    ).toISOString();

    const { data: candidates, error } = await supabase
      .from("matches")
      .select("id, company_id")
      .is("first_response_at", null)
      .is("ghosted_at", null)
      .lt("created_at", cutoff);

    if (error) throw error;
    if (!candidates || candidates.length === 0) {
      return json({ swept: 0 });
    }

    const now = new Date().toISOString();
    const ids = candidates.map((m) => m.id);
    const companyIds = Array.from(new Set(candidates.map((m) => m.company_id)));

    // 1. Stamp ghosted_at on all matches in one update.
    await supabase
      .from("matches")
      .update({ ghosted_at: now })
      .in("id", ids);

    // 2. Decrement ghost_score on each affected company by GHOST_PENALTY * num
    //    matches they ghosted in this sweep. Floor at 0.
    const penaltyByCompany = new Map<string, number>();
    for (const m of candidates) {
      penaltyByCompany.set(
        m.company_id,
        (penaltyByCompany.get(m.company_id) ?? 0) + GHOST_PENALTY
      );
    }

    const { data: companies } = await supabase
      .from("companies")
      .select("id, ghost_score")
      .in("id", companyIds);

    if (companies) {
      await Promise.all(
        companies.map((c) => {
          const penalty = penaltyByCompany.get(c.id) ?? 0;
          const newScore = Math.max(0, (c.ghost_score ?? 100) - penalty);
          return supabase
            .from("companies")
            .update({ ghost_score: newScore })
            .eq("id", c.id);
        })
      );
    }

    return json({ swept: ids.length, companies: companyIds.length });
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
