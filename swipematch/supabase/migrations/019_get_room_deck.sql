-- =============================================================================
-- 019_get_room_deck.sql
-- Region/intent/serendipity-aware room deck. Returns un-swiped, non-passive
-- profiles ordered by: same city -> same country -> shared connection_intents
-- overlap -> profile_completion, then appends up to 2 random "wildcard" rows
-- (serendipity) drawn from outside that ranked set. Swiper is derived from
-- auth.uid(); identity is never trusted from the client.
--
-- Returns a row per profile: (profile jsonb, is_wildcard boolean). The jsonb is
-- the full profiles row (snake_case keys) so the Dart ProfileModel.fromJson can
-- parse it directly; is_wildcard drives the "Serendipity" badge on the card.
-- =============================================================================

create or replace function public.get_room_deck(p_limit int default 15)
returns table(profile jsonb, is_wildcard boolean)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid        uuid := auth.uid();
  v_me         uuid;
  v_city       text;
  v_country    text;
  v_intents    text[];
  v_main_limit int;
begin
  if v_uid is null then
    raise exception 'Not authenticated';
  end if;

  select id, city, country, coalesce(connection_intents, '{}')
    into v_me, v_city, v_country, v_intents
  from public.profiles
  where user_id = v_uid;

  if v_me is null then
    raise exception 'No profile for current user';
  end if;

  v_main_limit := greatest(p_limit - 2, 1);

  return query
  with swiped as (
    select target_id
    from public.swipes
    where user_id = v_uid and target_type = 'person'
  ),
  eligible as (
    select p.*
    from public.profiles p
    where p.id <> v_me
      and p.id not in (select target_id from swiped)
      and coalesce(p.passive_mode, false) = false
  ),
  ranked as (
    select e.*,
      (e.city is not null and e.city = v_city)::int       as _same_city,
      (e.country is not null and e.country = v_country)::int as _same_country,
      cardinality(array(
        select unnest(coalesce(e.connection_intents, '{}'))
        intersect
        select unnest(v_intents)
      )) as _intent_overlap
    from eligible e
    order by _same_city desc, _same_country desc, _intent_overlap desc,
             e.profile_completion desc nulls last
    limit v_main_limit
  )
  select (to_jsonb(r) - '_same_city' - '_same_country' - '_intent_overlap') as profile,
         false as is_wildcard
  from ranked r
  union all
  select to_jsonb(w) as profile, true as is_wildcard
  from (
    select p.*
    from public.profiles p
    where p.id <> v_me
      and p.id not in (select target_id from swiped)
      and p.id not in (select (to_jsonb(r2) ->> 'id')::uuid from ranked r2)
      and coalesce(p.passive_mode, false) = false
    order by random()
    limit 2
  ) w;
end;
$$;

revoke execute on function public.get_room_deck(int) from public, anon;
grant  execute on function public.get_room_deck(int) to authenticated;
