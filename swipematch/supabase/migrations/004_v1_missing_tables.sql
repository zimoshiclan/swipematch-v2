-- =============================================================================
-- 004_v1_missing_tables.sql
-- Adds V1 launch-critical schema: ghost tracker, salary truth, video pitch,
-- plus V2 supporting tables (interview_intel, skills_scores).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Companies: ghost tracker + truth score
-- -----------------------------------------------------------------------------
alter table public.companies
  add column if not exists ghost_score int not null default 100
    check (ghost_score between 0 and 100),
  add column if not exists truth_score jsonb;

-- -----------------------------------------------------------------------------
-- Matches: ghost timestamps
-- -----------------------------------------------------------------------------
alter table public.matches
  add column if not exists ghosted_at timestamptz,
  add column if not exists first_response_at timestamptz;

create index if not exists idx_matches_ghost_sweep
  on public.matches(created_at)
  where ghosted_at is null and first_response_at is null;

-- -----------------------------------------------------------------------------
-- Profiles: 60-second pitch
-- -----------------------------------------------------------------------------
alter table public.profiles
  add column if not exists video_pitch_url text,
  add column if not exists video_pitch_transcript text;

-- -----------------------------------------------------------------------------
-- Salary reports (crowdsourced)
-- -----------------------------------------------------------------------------
create table if not exists public.salary_reports (
  id uuid primary key default uuid_generate_v4(),
  reporter_id uuid references public.profiles(id) on delete set null,
  company_name text not null,
  role_title text not null,
  salary int not null check (salary > 0),
  currency text not null default 'USD',
  city text,
  country text,
  verified boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists idx_salary_reports_company_role
  on public.salary_reports(lower(company_name), lower(role_title));

create index if not exists idx_salary_reports_role
  on public.salary_reports(lower(role_title));

-- -----------------------------------------------------------------------------
-- Interview intel (crowdsourced questions per company / role)
-- -----------------------------------------------------------------------------
create table if not exists public.interview_intel (
  id uuid primary key default uuid_generate_v4(),
  reporter_id uuid references public.profiles(id) on delete set null,
  company_id uuid references public.companies(id) on delete set null,
  company_name text not null,
  role_title text,
  question text not null,
  stage text check (stage in ('phone', 'technical', 'culture', 'final')),
  created_at timestamptz not null default now()
);

create index if not exists idx_interview_intel_company
  on public.interview_intel(lower(company_name));

-- -----------------------------------------------------------------------------
-- Skills scores (verified skill battle results)
-- -----------------------------------------------------------------------------
create table if not exists public.skills_scores (
  id uuid primary key default uuid_generate_v4(),
  candidate_id uuid references public.profiles(id) on delete cascade not null,
  skill_name text not null,
  score int not null check (score between 0 and 100),
  verified boolean not null default false,
  taken_at timestamptz not null default now(),
  unique(candidate_id, skill_name)
);

create index if not exists idx_skills_scores_candidate
  on public.skills_scores(candidate_id);

-- -----------------------------------------------------------------------------
-- Storage bucket for pitches (idempotent)
--
-- Public bucket so employer feed thumbnails / players can stream without auth.
-- Server-side hardening is enforced here (MIME allowlist + size cap) so a
-- compromised client cannot upload arbitrary executables / images as ".mp4".
-- -----------------------------------------------------------------------------
insert into storage.buckets (
  id, name, public, file_size_limit, allowed_mime_types
)
values (
  'pitches',
  'pitches',
  true,
  52428800,                                  -- 50 MB cap
  array['video/mp4', 'video/quicktime', 'video/webm']
)
on conflict (id) do update
  set public             = excluded.public,
      file_size_limit    = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;
