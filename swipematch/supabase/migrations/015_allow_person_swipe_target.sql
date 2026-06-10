-- =============================================================================
-- 015_allow_person_swipe_target.sql
-- The Room records person-to-person swipes via record_person_swipe (migration
-- 009), which inserts swipes.target_type = 'person'. The original CHECK from
-- migration 001 only permitted ('job', 'candidate'), so every room swipe would
-- fail the constraint. Widen it to include 'person'.
-- =============================================================================

alter table public.swipes drop constraint if exists swipes_target_type_check;

alter table public.swipes
  add constraint swipes_target_type_check
  check (target_type in ('job', 'candidate', 'person'));
