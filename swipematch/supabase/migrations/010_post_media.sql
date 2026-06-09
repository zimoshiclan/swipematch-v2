-- Post media (images + videos) and post-type alignment with the app.

-- 1. Media columns on posts
ALTER TABLE posts
  ADD COLUMN IF NOT EXISTS media_url  text,
  ADD COLUMN IF NOT EXISTS media_type text
    CHECK (media_type IS NULL OR media_type IN ('image', 'video'));

-- 2. Widen the type CHECK to match AppConstants.postTypes
--    (original migration 006 only allowed a subset).
ALTER TABLE posts DROP CONSTRAINT IF EXISTS posts_type_check;
ALTER TABLE posts
  ADD CONSTRAINT posts_type_check CHECK (type IN (
    'honest', 'win', 'ask', 'research',
    'achievement', 'collaboration', 'insight', 'essay'
  ));

-- 3. Public storage bucket for post media
INSERT INTO storage.buckets (id, name, public)
VALUES ('post-media', 'post-media', true)
ON CONFLICT (id) DO NOTHING;

-- 4. Storage RLS — read is public, writes are scoped to the uploader's folder.
--    Object path convention: <profile_id>/<filename>
DROP POLICY IF EXISTS "post-media public read"   ON storage.objects;
DROP POLICY IF EXISTS "post-media owner insert"   ON storage.objects;
DROP POLICY IF EXISTS "post-media owner delete"   ON storage.objects;

CREATE POLICY "post-media public read"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'post-media');

CREATE POLICY "post-media owner insert"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'post-media'
    AND (storage.foldername(name))[1] = (
      SELECT id::text FROM profiles WHERE user_id = auth.uid() LIMIT 1
    )
  );

CREATE POLICY "post-media owner delete"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'post-media'
    AND (storage.foldername(name))[1] = (
      SELECT id::text FROM profiles WHERE user_id = auth.uid() LIMIT 1
    )
  );
