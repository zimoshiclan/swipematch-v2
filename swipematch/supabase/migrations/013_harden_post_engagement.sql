-- Security hardening for the post-engagement objects added in 010–012.

-- 1. Public buckets serve objects via their public URL without a SELECT
--    policy. The broad SELECT policy only enables file *listing*, which we
--    don't need for post media — drop it to prevent enumeration.
DROP POLICY IF EXISTS "post-media public read" ON storage.objects;

-- 2. Trigger functions are invoked by the trigger machinery (as the table
--    owner) regardless of EXECUTE grants, so revoke direct RPC access.
REVOKE EXECUTE ON FUNCTION public.on_post_comment_insert()  FROM public, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.on_post_comment_delete()  FROM public, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.on_post_like_insert()     FROM public, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.on_comment_like_insert()  FROM public, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.on_comment_like_delete()  FROM public, anon, authenticated;
