-- Enable RLS on all tables
alter table public.profiles enable row level security;
alter table public.companies enable row level security;
alter table public.jobs enable row level security;
alter table public.swipes enable row level security;
alter table public.matches enable row level security;
alter table public.messages enable row level security;

-- =====================
-- PROFILES
-- =====================
create policy "profiles_select_own" on public.profiles
  for select using (auth.uid() = user_id);

create policy "profiles_insert_own" on public.profiles
  for insert with check (auth.uid() = user_id);

create policy "profiles_update_own" on public.profiles
  for update using (auth.uid() = user_id);

-- Employers can read candidate profiles for the swipe feed
create policy "profiles_select_candidates_for_employers" on public.profiles
  for select using (
    auth.role() = 'authenticated' and role = 'candidate'
  );

-- =====================
-- COMPANIES
-- =====================
create policy "companies_select_authenticated" on public.companies
  for select using (auth.role() = 'authenticated');

create policy "companies_insert_own" on public.companies
  for insert with check (
    employer_id = (select id from public.profiles where user_id = auth.uid())
  );

create policy "companies_update_own" on public.companies
  for update using (
    employer_id = (select id from public.profiles where user_id = auth.uid())
  );

create policy "companies_delete_own" on public.companies
  for delete using (
    employer_id = (select id from public.profiles where user_id = auth.uid())
  );

-- =====================
-- JOBS
-- =====================
create policy "jobs_select_active" on public.jobs
  for select using (auth.role() = 'authenticated' and is_active = true);

-- Employers can see their own inactive jobs too
create policy "jobs_select_own_inactive" on public.jobs
  for select using (
    company_id in (
      select id from public.companies
      where employer_id = (select id from public.profiles where user_id = auth.uid())
    )
  );

create policy "jobs_insert_own" on public.jobs
  for insert with check (
    company_id in (
      select id from public.companies
      where employer_id = (select id from public.profiles where user_id = auth.uid())
    )
  );

create policy "jobs_update_own" on public.jobs
  for update using (
    company_id in (
      select id from public.companies
      where employer_id = (select id from public.profiles where user_id = auth.uid())
    )
  );

-- =====================
-- SWIPES
-- =====================
create policy "swipes_select_own" on public.swipes
  for select using (auth.uid() = user_id);

create policy "swipes_insert_own" on public.swipes
  for insert with check (auth.uid() = user_id);

-- =====================
-- MATCHES
-- =====================
create policy "matches_select_candidate" on public.matches
  for select using (
    candidate_id = (select id from public.profiles where user_id = auth.uid())
  );

create policy "matches_select_employer" on public.matches
  for select using (
    company_id in (
      select id from public.companies
      where employer_id = (select id from public.profiles where user_id = auth.uid())
    )
  );

create policy "matches_insert_authenticated" on public.matches
  for insert with check (auth.role() = 'authenticated');

-- Employers can update match status (pipeline drag-and-drop)
create policy "matches_update_employer" on public.matches
  for update using (
    company_id in (
      select id from public.companies
      where employer_id = (select id from public.profiles where user_id = auth.uid())
    )
  );

-- =====================
-- MESSAGES
-- =====================
create policy "messages_select_participants" on public.messages
  for select using (
    match_id in (
      select id from public.matches
      where candidate_id = (select id from public.profiles where user_id = auth.uid())
      union
      select m.id from public.matches m
      join public.companies c on m.company_id = c.id
      where c.employer_id = (select id from public.profiles where user_id = auth.uid())
    )
  );

create policy "messages_insert_participants" on public.messages
  for insert with check (
    auth.uid() = sender_id
    and match_id in (
      select id from public.matches
      where candidate_id = (select id from public.profiles where user_id = auth.uid())
      union
      select m.id from public.matches m
      join public.companies c on m.company_id = c.id
      where c.employer_id = (select id from public.profiles where user_id = auth.uid())
    )
  );
