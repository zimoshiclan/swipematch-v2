-- =============================================================================
-- 014_person_match_chat.sql
-- Make the connection -> chat flow work for person-to-person matches.
--
-- Person-matches are created by record_person_swipe (migration 009) with the
-- signature: candidate_id = swiper, job_id = company_id = the other person's
-- profile id. The original matches/messages RLS (migration 002) only let the
-- candidate side and the *company-based* employer side read a match, so the
-- person on the job_id side could neither open the match nor exchange messages.
-- This migration:
--   1. Adds an RPC to resolve (or create) the match between two connected
--      people, callable from either side.
--   2. Adds RLS so the job_id-side participant can read the match and
--      read/insert its messages.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- RPC: get_or_create_person_match
-- Returns the match id between the caller and p_other_profile_id, in whichever
-- direction it exists, creating it if necessary. SECURITY DEFINER so the lookup
-- is not blocked by the asymmetric RLS while still being scoped to the caller.
-- -----------------------------------------------------------------------------
create or replace function public.get_or_create_person_match(
  p_other_profile_id uuid
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_my_profile_id uuid;
  v_match_id      uuid;
begin
  select id into v_my_profile_id
  from public.profiles
  where user_id = auth.uid();

  if v_my_profile_id is null then
    raise exception 'No profile for current user';
  end if;

  -- Only allow opening a chat with someone you are actually connected to.
  if not exists (
    select 1 from public.connections
    where status = 'accepted'
      and (
        (requester_id = v_my_profile_id and receiver_id = p_other_profile_id) or
        (requester_id = p_other_profile_id and receiver_id = v_my_profile_id)
      )
  ) then
    raise exception 'Not connected to that person';
  end if;

  -- Find an existing person-match in either direction.
  select id into v_match_id
  from public.matches
  where company_id = job_id  -- person-match signature
    and (
      (candidate_id = v_my_profile_id and job_id = p_other_profile_id) or
      (candidate_id = p_other_profile_id and job_id = v_my_profile_id)
    )
  limit 1;

  if v_match_id is not null then
    return v_match_id;
  end if;

  insert into public.matches (candidate_id, job_id, company_id, match_score, status)
  values (v_my_profile_id, p_other_profile_id, p_other_profile_id, 100, 'new_match')
  returning id into v_match_id;

  return v_match_id;
end;
$$;

grant execute on function public.get_or_create_person_match(uuid) to authenticated;

-- -----------------------------------------------------------------------------
-- RLS: let the job_id-side participant of a person-match read the match.
-- (The candidate side is already covered by matches_select_candidate.)
-- The `company_id = job_id` guard restricts this to person-matches so it can
-- never widen visibility of real job/company matches.
-- -----------------------------------------------------------------------------
create policy "matches_select_person_target" on public.matches
  for select using (
    company_id = job_id
    and job_id = (select id from public.profiles where user_id = auth.uid())
  );

-- -----------------------------------------------------------------------------
-- RLS: messages for the job_id-side participant of a person-match.
-- -----------------------------------------------------------------------------
create policy "messages_select_person_target" on public.messages
  for select using (
    match_id in (
      select id from public.matches
      where company_id = job_id
        and job_id = (select id from public.profiles where user_id = auth.uid())
    )
  );

create policy "messages_insert_person_target" on public.messages
  for insert with check (
    auth.uid() = sender_id
    and match_id in (
      select id from public.matches
      where company_id = job_id
        and job_id = (select id from public.profiles where user_id = auth.uid())
    )
  );
