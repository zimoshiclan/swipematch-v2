-- =============================================================================
-- 017_secure_person_swipe.sql
-- SECURITY FIX. The original record_person_swipe (migration 009) took the
-- swiper's user_id and profile_id as *parameters* while running SECURITY
-- DEFINER, so any caller could record a swipe AS another user. Because a mutual
-- swipe creates a connection, an attacker could forge the victim's swipe and
-- force a connection (and then a chat) with anyone.
--
-- This replaces it with a version that derives the swiper from auth.uid(),
-- ignoring any client-supplied identity, and restricts EXECUTE to signed-in
-- users. The new signature drops the two swiper-id parameters.
-- =============================================================================

drop function if exists public.record_person_swipe(uuid, uuid, uuid, text);

create or replace function public.record_person_swipe(
  p_target_profile_id uuid,
  p_direction         text
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_swiper_user_id    uuid := auth.uid();
  v_swiper_profile_id uuid;
  v_mutual_exists     boolean := false;
  v_connection_id     uuid;
  v_match_id          uuid;
begin
  if v_swiper_user_id is null then
    raise exception 'Not authenticated';
  end if;

  select id into v_swiper_profile_id
  from public.profiles
  where user_id = v_swiper_user_id;

  if v_swiper_profile_id is null then
    raise exception 'No profile for current user';
  end if;

  if p_direction not in ('right', 'left', 'super') then
    raise exception 'Invalid swipe direction';
  end if;

  insert into public.swipes (user_id, target_id, target_type, direction)
  values (v_swiper_user_id, p_target_profile_id, 'person', p_direction)
  on conflict (user_id, target_id) do nothing;

  if p_direction not in ('right', 'super') then
    return jsonb_build_object('connected', false);
  end if;

  select exists (
    select 1 from public.swipes s
    join public.profiles pr on pr.user_id = s.user_id
    where pr.id = p_target_profile_id
      and s.target_id = v_swiper_profile_id
      and s.target_type = 'person'
      and s.direction in ('right', 'super')
  ) into v_mutual_exists;

  if not v_mutual_exists then
    return jsonb_build_object('connected', false);
  end if;

  insert into public.connections (requester_id, receiver_id, status)
  values (v_swiper_profile_id, p_target_profile_id, 'accepted')
  on conflict (requester_id, receiver_id) do update set status = 'accepted'
  returning id into v_connection_id;

  insert into public.matches (candidate_id, job_id, company_id, match_score, status)
  values (v_swiper_profile_id, p_target_profile_id, p_target_profile_id, 100, 'new_match')
  on conflict do nothing
  returning id into v_match_id;

  if v_match_id is null then
    select id into v_match_id from public.matches
    where candidate_id = v_swiper_profile_id and job_id = p_target_profile_id
    limit 1;
  end if;

  return jsonb_build_object(
    'connected', true,
    'connection_id', v_connection_id,
    'match_id', v_match_id
  );
end;
$$;

revoke execute on function public.record_person_swipe(uuid, text) from public, anon;
grant execute on function public.record_person_swipe(uuid, text) to authenticated;
