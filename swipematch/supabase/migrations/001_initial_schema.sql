-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- Profiles
create table public.profiles (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade not null unique,
  role text not null check (role in ('candidate', 'employer')),
  name text not null default '',
  avatar_url text,
  bio text,
  skills text[] default '{}',
  salary_min int,
  salary_max int,
  currency text default 'USD',
  work_style text check (work_style in ('remote', 'hybrid', 'on_site')),
  culture_tags text[] default '{}',
  experience_years int,
  streak_count int not null default 0,
  last_active_date date,
  passive_mode bool not null default false,
  profile_completion int not null default 0,
  job_search_timeline text check (job_search_timeline in ('1_month', '3_months', '6_months', 'exploring')),
  created_at timestamptz not null default now()
);

-- Companies
create table public.companies (
  id uuid primary key default uuid_generate_v4(),
  employer_id uuid references public.profiles(id) on delete cascade not null,
  name text not null,
  logo_url text,
  size text,
  culture_tags text[] default '{}',
  tech_stack text[] default '{}',
  description text,
  website text,
  created_at timestamptz not null default now()
);

-- Jobs
create table public.jobs (
  id uuid primary key default uuid_generate_v4(),
  company_id uuid references public.companies(id) on delete cascade not null,
  title text not null,
  description text not null default '',
  required_skills text[] default '{}',
  salary_min int not null default 0,
  salary_max int not null default 0,
  work_style text check (work_style in ('remote', 'hybrid', 'on_site')),
  experience_years int not null default 0,
  is_active bool not null default true,
  expires_at timestamptz,
  created_at timestamptz not null default now()
);

-- Swipes
create table public.swipes (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade not null,
  target_id uuid not null,
  target_type text not null check (target_type in ('job', 'candidate')),
  direction text not null check (direction in ('right', 'left', 'super')),
  created_at timestamptz not null default now(),
  unique(user_id, target_id)
);

-- Matches
create table public.matches (
  id uuid primary key default uuid_generate_v4(),
  candidate_id uuid references public.profiles(id) on delete cascade not null,
  job_id uuid references public.jobs(id) on delete cascade not null,
  company_id uuid references public.companies(id) on delete cascade not null,
  match_score int not null default 0 check (match_score between 0 and 100),
  match_reason jsonb not null default '{}',
  status text not null default 'new_match' check (status in ('new_match', 'contacted', 'interview_scheduled', 'offer_sent', 'hired')),
  created_at timestamptz not null default now(),
  unique(candidate_id, job_id)
);

-- Messages
create table public.messages (
  id uuid primary key default uuid_generate_v4(),
  match_id uuid references public.matches(id) on delete cascade not null,
  sender_id uuid references auth.users(id) on delete cascade not null,
  content text not null,
  ai_assisted bool not null default false,
  created_at timestamptz not null default now()
);

-- Indexes
create index idx_profiles_user_id on public.profiles(user_id);
create index idx_profiles_role on public.profiles(role);
create index idx_companies_employer_id on public.companies(employer_id);
create index idx_jobs_company_id on public.jobs(company_id);
create index idx_jobs_is_active on public.jobs(is_active);
create index idx_swipes_user_id on public.swipes(user_id);
create index idx_swipes_target_id on public.swipes(target_id);
create index idx_swipes_user_target on public.swipes(user_id, target_id);
create index idx_matches_candidate_id on public.matches(candidate_id);
create index idx_matches_company_id on public.matches(company_id);
create index idx_matches_status on public.matches(status);
create index idx_messages_match_id on public.messages(match_id);
create index idx_messages_created_at on public.messages(match_id, created_at);
