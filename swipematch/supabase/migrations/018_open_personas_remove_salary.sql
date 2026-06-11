-- =============================================================================
-- 018_open_personas_remove_salary.sql
-- Product pivot: from job-matching to open professional/social networking.
--   * Remove salary/compensation entirely (alienates non-job users).
--   * Replace the candidate/employer binary with an open `persona` plus a
--     multi-select `connection_intents` ("what I'm looking for").
--   * Add city/country for region-based matching.
-- Existing columns reused (no change): working_toward, currently_learning,
-- ai_readiness_score, work_values, video_pitch_url, video_pitch_transcript,
-- headline.
-- =============================================================================

-- ── Remove salary ───────────────────────────────────────────────────────────
alter table public.profiles
  drop column if exists salary_min,
  drop column if exists salary_max,
  drop column if exists currency;

alter table public.jobs
  drop column if exists salary_min,
  drop column if exists salary_max;

drop table if exists public.salary_reports cascade;

-- ── Open personas + connection intent + region ──────────────────────────────
alter table public.profiles
  add column if not exists persona            text,
  add column if not exists connection_intents text[] default '{}',
  add column if not exists city               text,
  add column if not exists country            text;

-- Relax the role lock so the app is no longer candidate/employer only.
-- Keep the `role` column for back-compat; default new rows to 'member'.
alter table public.profiles drop constraint if exists profiles_role_check;
alter table public.profiles alter column role set default 'member';
