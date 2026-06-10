-- =============================================================================
-- 016_harden_person_match_grant.sql
-- Postgres grants EXECUTE on new functions to PUBLIC by default, so the
-- `grant ... to authenticated` in migration 014 left get_or_create_person_match
-- callable by the anon role too. The function self-guards on auth.uid() (an
-- anon caller just hits the 'No profile for current user' exception), but we
-- revoke public/anon EXECUTE anyway to satisfy the security linter and follow
-- least-privilege. The explicit grant to `authenticated` from 014 remains.
-- =============================================================================

revoke execute on function public.get_or_create_person_match(uuid) from public, anon;
