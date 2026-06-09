-- Comment likes, reply threads, and saved-post bookmarks.

-- ─────────────────────────────────────────────────────────
-- A) Reply threads — self-referencing parent on post_comments
-- ─────────────────────────────────────────────────────────
ALTER TABLE post_comments
  ADD COLUMN IF NOT EXISTS parent_id uuid
    REFERENCES post_comments(id) ON DELETE CASCADE,
  ADD COLUMN IF NOT EXISTS likes_count int NOT NULL DEFAULT 0;

CREATE INDEX IF NOT EXISTS post_comments_parent_idx
  ON post_comments(parent_id);

-- ─────────────────────────────────────────────────────────
-- B) Comment likes
-- ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS comment_likes (
  comment_id uuid NOT NULL REFERENCES post_comments(id) ON DELETE CASCADE,
  profile_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (comment_id, profile_id)
);

CREATE INDEX IF NOT EXISTS comment_likes_profile_idx
  ON comment_likes(profile_id);

ALTER TABLE comment_likes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "read comment_likes" ON comment_likes;
CREATE POLICY "read comment_likes"
  ON comment_likes FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "insert own comment_like" ON comment_likes;
CREATE POLICY "insert own comment_like"
  ON comment_likes FOR INSERT TO authenticated
  WITH CHECK (profile_id = (
    SELECT id FROM profiles WHERE user_id = auth.uid() LIMIT 1
  ));

DROP POLICY IF EXISTS "delete own comment_like" ON comment_likes;
CREATE POLICY "delete own comment_like"
  ON comment_likes FOR DELETE TO authenticated
  USING (profile_id = (
    SELECT id FROM profiles WHERE user_id = auth.uid() LIMIT 1
  ));

-- Keep post_comments.likes_count in sync + notify the comment author.
CREATE OR REPLACE FUNCTION on_comment_like_insert()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_author uuid;
  v_name   text;
  v_body   text;
BEGIN
  UPDATE post_comments SET likes_count = likes_count + 1
    WHERE id = NEW.comment_id
    RETURNING author_id, content INTO v_author, v_body;

  IF v_author IS NOT NULL AND v_author <> NEW.profile_id THEN
    SELECT name INTO v_name FROM profiles WHERE id = NEW.profile_id;
    INSERT INTO app_notifications (profile_id, type, title, body, payload)
    VALUES (
      v_author,
      'comment_like',
      COALESCE(NULLIF(v_name, ''), 'Someone') || ' liked your comment',
      left(COALESCE(v_body, ''), 120),
      jsonb_build_object('comment_id', NEW.comment_id)
    );
  END IF;
  RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION on_comment_like_delete()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  UPDATE post_comments SET likes_count = GREATEST(0, likes_count - 1)
    WHERE id = OLD.comment_id;
  RETURN OLD;
END; $$;

DROP TRIGGER IF EXISTS trg_comment_like_insert ON comment_likes;
CREATE TRIGGER trg_comment_like_insert
  AFTER INSERT ON comment_likes
  FOR EACH ROW EXECUTE FUNCTION on_comment_like_insert();

DROP TRIGGER IF EXISTS trg_comment_like_delete ON comment_likes;
CREATE TRIGGER trg_comment_like_delete
  AFTER DELETE ON comment_likes
  FOR EACH ROW EXECUTE FUNCTION on_comment_like_delete();

-- ─────────────────────────────────────────────────────────
-- C) Reply-aware comment-insert notifications
--    (replaces the function from migration 011: notify the post
--     author, and additionally the parent comment's author on a reply)
-- ─────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION on_post_comment_insert()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_post_author   uuid;
  v_parent_author uuid;
  v_name          text;
BEGIN
  UPDATE posts SET comments_count = comments_count + 1
    WHERE id = NEW.post_id
    RETURNING author_id INTO v_post_author;

  SELECT name INTO v_name FROM profiles WHERE id = NEW.author_id;

  -- Notify the post author (skip if they wrote the comment themselves).
  IF v_post_author IS NOT NULL AND v_post_author <> NEW.author_id THEN
    INSERT INTO app_notifications (profile_id, type, title, body, payload)
    VALUES (
      v_post_author,
      'post_comment',
      COALESCE(NULLIF(v_name, ''), 'Someone') || ' commented on your post',
      left(NEW.content, 120),
      jsonb_build_object('post_id', NEW.post_id, 'comment_id', NEW.id)
    );
  END IF;

  -- Notify the parent comment's author on a reply (avoid duplicates).
  IF NEW.parent_id IS NOT NULL THEN
    SELECT author_id INTO v_parent_author
      FROM post_comments WHERE id = NEW.parent_id;
    IF v_parent_author IS NOT NULL
       AND v_parent_author <> NEW.author_id
       AND v_parent_author <> v_post_author THEN
      INSERT INTO app_notifications (profile_id, type, title, body, payload)
      VALUES (
        v_parent_author,
        'comment_reply',
        COALESCE(NULLIF(v_name, ''), 'Someone') || ' replied to your comment',
        left(NEW.content, 120),
        jsonb_build_object('post_id', NEW.post_id, 'comment_id', NEW.id)
      );
    END IF;
  END IF;

  RETURN NEW;
END; $$;

-- ─────────────────────────────────────────────────────────
-- D) Saved-post bookmarks
-- ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS post_bookmarks (
  post_id    uuid NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  profile_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (post_id, profile_id)
);

CREATE INDEX IF NOT EXISTS post_bookmarks_profile_idx
  ON post_bookmarks(profile_id, created_at DESC);

ALTER TABLE post_bookmarks ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "read own bookmarks" ON post_bookmarks;
CREATE POLICY "read own bookmarks"
  ON post_bookmarks FOR SELECT TO authenticated
  USING (profile_id = (
    SELECT id FROM profiles WHERE user_id = auth.uid() LIMIT 1
  ));

DROP POLICY IF EXISTS "insert own bookmark" ON post_bookmarks;
CREATE POLICY "insert own bookmark"
  ON post_bookmarks FOR INSERT TO authenticated
  WITH CHECK (profile_id = (
    SELECT id FROM profiles WHERE user_id = auth.uid() LIMIT 1
  ));

DROP POLICY IF EXISTS "delete own bookmark" ON post_bookmarks;
CREATE POLICY "delete own bookmark"
  ON post_bookmarks FOR DELETE TO authenticated
  USING (profile_id = (
    SELECT id FROM profiles WHERE user_id = auth.uid() LIMIT 1
  ));
