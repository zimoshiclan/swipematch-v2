-- =============================================================================
-- 007_app_notifications.sql
-- In-app notifications feed. Referenced by the engagement triggers in
-- migrations 011/012 (post comments, post likes, comment likes) and read by
-- the notifications screen. Schema mirrors NotificationModel + the
-- AppNotificationsRepository queries (profile_id / is_read / created_at).
-- Rows are written only by SECURITY DEFINER triggers, so no INSERT policy is
-- needed for end users; they may read and mark-read their own notifications.
-- =============================================================================

create table if not exists public.app_notifications (
  id         uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  type       text not null,
  title      text not null default '',
  body       text not null default '',
  payload    jsonb,
  is_read    boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists app_notifications_profile_idx
  on public.app_notifications(profile_id, created_at desc);

alter table public.app_notifications enable row level security;

drop policy if exists "read own notifications" on public.app_notifications;
create policy "read own notifications" on public.app_notifications
  for select to authenticated
  using (
    profile_id = (select id from public.profiles where user_id = auth.uid() limit 1)
  );

drop policy if exists "update own notifications" on public.app_notifications;
create policy "update own notifications" on public.app_notifications
  for update to authenticated
  using (
    profile_id = (select id from public.profiles where user_id = auth.uid() limit 1)
  );
