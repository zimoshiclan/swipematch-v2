-- =============================================================================
-- 020_intent_primary_room_deck.sql
-- Make CONNECTION INTENT the primary match axis (region becomes a tiebreak).
--
-- Supersedes the region-first ordering from migration 019. The deck is now
-- ranked by an _intent_fit score that rewards:
--   * direct overlap  — we both want the same kind of thing (weight x2)
--   * complementary   — mentorship <-> knowledge (I seek / you offer, both ways)
--   * persona modifier — my "investors" intent + your Investor persona, or my
--                        "mentorship" intent + a senior persona / experience
-- ...then same city -> same country -> profile_completion as tiebreaks.
--
-- Serendipity is unchanged: up to 2 random "wildcard" rows appended outside the
-- ranked set. Swiper identity is still derived from auth.uid(); never trusted
-- from the client. Returns (profile jsonb, is_wildcard boolean) exactly like 019
-- so the Dart ProfileModel.fromJson + Serendipity badge keep working unchanged.
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
      (e.city is not null and e.city = v_city)::int          as _same_city,
      (e.country is not null and e.country = v_country)::int  as _same_country,
      -- Intent fit: direct overlap (x2) + complementary pair + persona modifier.
      ( 2 * cardinality(array(
              select unnest(v_intents)
              intersect
              select unnest(coalesce(e.connection_intents, '{}'))
            ))
        -- complementary: mentorship <-> knowledge, both directions
        + (case when 'mentorship' = any(v_intents)
                 and 'knowledge'  = any(coalesce(e.connection_intents, '{}'))
                then 1 else 0 end)
        + (case when 'knowledge'  = any(v_intents)
                 and 'mentorship' = any(coalesce(e.connection_intents, '{}'))
                then 1 else 0 end)
        -- persona modifier: my "investors" intent + their Investor persona
        + (case when 'investors' = any(v_intents)
                 and e.persona = 'Investor'
                then 1 else 0 end)
        -- persona modifier: my "mentorship" intent + a senior persona/experience
        + (case when 'mentorship' = any(v_intents)
                 and (e.persona in ('Professional','Researcher','Investor')
                      or coalesce(e.experience_years, 0) >= 5)
                then 1 else 0 end)
      ) as _intent_fit
    from eligible e
    order by _intent_fit desc, _same_city desc, _same_country desc,
             e.profile_completion desc nulls last
    limit v_main_limit
  )
  select (to_jsonb(r) - '_same_city' - '_same_country' - '_intent_fit') as profile,
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
