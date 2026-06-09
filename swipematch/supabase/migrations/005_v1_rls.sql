-- =============================================================================
-- 005_v1_rls.sql
-- RLS policies for V1 tables added in 004.
-- =============================================================================

alter table public.salary_reports enable row level security;
alter table public.interview_intel enable row level security;
alter table public.skills_scores enable row level security;

-- -----------------------------------------------------------------------------
-- SALARY REPORTS
-- All authenticated users can read aggregate-friendly anonymized data.
-- Authenticated users insert their own report. Reporter can update only
-- their own row; "verified" flag can only be set by service role.
-- -----------------------------------------------------------------------------
create policy "salary_reports_select_authenticated" on public.salary_reports
  for select using (auth.role() = 'authenticated');

create policy "salary_reports_insert_own" on public.salary_reports
  for insert with check (
    reporter_id is null or
    reporter_id = (select id from public.profiles where user_id = auth.uid())
  );

create policy "salary_reports_update_own" on public.salary_reports
  for update using (
    reporter_id = (select id from public.profiles where user_id = auth.uid())
    and verified = false
  )
  with check (
    -- prevent self-verification AND prevent downgrading admin-verified rows
    verified = false
  );

-- -----------------------------------------------------------------------------
-- INTERVIEW INTEL
-- -----------------------------------------------------------------------------
create policy "interview_intel_select_authenticated" on public.interview_intel
  for select using (auth.role() = 'authenticated');

create policy "interview_intel_insert_own" on public.interview_intel
  for insert with check (
    reporter_id is null or
    reporter_id = (select id from public.profiles where user_id = auth.uid())
  );

create policy "interview_intel_delete_own" on public.interview_intel
  for delete using (
    reporter_id = (select id from public.profiles where user_id = auth.uid())
  );

-- -----------------------------------------------------------------------------
-- SKILLS SCORES
-- Candidate reads their own scores; employers can read any candidate's scores
-- (used for the "verified skills" badge on employer feed). Only the candidate
-- can write their own row.
-- -----------------------------------------------------------------------------
create policy "skills_scores_select_own" on public.skills_scores
  for select using (
    candidate_id = (select id from public.profiles where user_id = auth.uid())
  );

create policy "skills_scores_select_employers" on public.skills_scores
  for select using (
    exists (
      select 1 from public.profiles
      where user_id = auth.uid() and role = 'employer'
    )
  );

create policy "skills_scores_insert_own" on public.skills_scores
  for insert with check (
    candidate_id = (select id from public.profiles where user_id = auth.uid())
  );

create policy "skills_scores_update_own" on public.skills_scores
  for update using (
    candidate_id = (select id from public.profiles where user_id = auth.uid())
    and verified = false
  )
  with check (verified = false);

-- -----------------------------------------------------------------------------
-- STORAGE: pitches bucket (public-read, owner-write)
-- File path convention: pitches/<profile_id>/<filename>
-- -----------------------------------------------------------------------------
create policy "pitches_public_read" on storage.objects
  for select using (bucket_id = 'pitches');

create policy "pitches_owner_insert" on storage.objects
  for insert with check (
    bucket_id = 'pitches'
    and (storage.foldername(name))[1] = (
      select id::text from public.profiles where user_id = auth.uid()
    )
  );

create policy "pitches_owner_update" on storage.objects
  for update using (
    bucket_id = 'pitches'
    and (storage.foldername(name))[1] = (
      select id::text from public.profiles where user_id = auth.uid()
    )
  );

create policy "pitches_owner_delete" on storage.objects
  for delete using (
    bucket_id = 'pitches'
    and (storage.foldername(name))[1] = (
      select id::text from public.profiles where user_id = auth.uid()
    )
  );
