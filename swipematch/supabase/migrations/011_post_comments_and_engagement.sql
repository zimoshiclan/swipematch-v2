-- Post comments + engagement notifications (likes & comments pull-back loop).

-- ─────────────────────────────────────────────────────────
-- Comments table
-- ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS post_comments (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id    uuid NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  author_id  uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  content    text NOT NULL CHECK (char_length(content) BETWEEN 1 AND 2000),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS post_comments_post_idx
  ON post_comments(post_id, created_at);

ALTER TABLE post_comments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone authenticated can read comments" ON post_comments;
CREATE POLICY "Anyone authenticated can read comments"
  ON post_comments FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "Author can insert comments" ON post_comments;
CREATE POLICY "Author can insert comments"
  ON post_comments FOR INSERT TO authenticated
  WITH CHECK (author_id = (
    SELECT id FROM profiles WHERE user_id = auth.uid() LIMIT 1
  ));

DROP POLICY IF EXISTS "Author can delete own comments" ON post_comments;
CREATE POLICY "Author can delete own comments"
  ON post_comments FOR DELETE TO authenticated
  USING (author_id = (
    SELECT id FROM profiles WHERE user_id = auth.uid() LIMIT 1
  ));

-- ─────────────────────────────────────────────────────────
-- Comment count sync + notify the post author
-- ─────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION on_post_comment_insert()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_author uuid;
  v_name   text;
BEGIN
  UPDATE posts SET comments_count = comments_count + 1
    WHERE id = NEW.post_id
    RETURNING author_id INTO v_author;

  IF v_author IS NOT NULL AND v_author <> NEW.author_id THEN
    SELECT name INTO v_name FROM profiles WHERE id = NEW.author_id;
    INSERT INTO app_notifications (profile_id, type, title, body, payload)
    VALUES (
      v_author,
      'post_comment',
      COALESCE(NULLIF(v_name, ''), 'Someone') || ' commented on your post',
      left(NEW.content, 120),
      jsonb_build_object('post_id', NEW.post_id, 'comment_id', NEW.id)
    );
  END IF;
  RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION on_post_comment_delete()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  UPDATE posts SET comments_count = GREATEST(0, comments_count - 1)
    WHERE id = OLD.post_id;
  RETURN OLD;
END; $$;

DROP TRIGGER IF EXISTS trg_post_comment_insert ON post_comments;
CREATE TRIGGER trg_post_comment_insert
  AFTER INSERT ON post_comments
  FOR EACH ROW EXECUTE FUNCTION on_post_comment_insert();

DROP TRIGGER IF EXISTS trg_post_comment_delete ON post_comments;
CREATE TRIGGER trg_post_comment_delete
  AFTER DELETE ON post_comments
  FOR EACH ROW EXECUTE FUNCTION on_post_comment_delete();

-- ─────────────────────────────────────────────────────────
-- Notify the post author when someone likes their post
-- ─────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION on_post_like_insert()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_author uuid;
  v_title  text;
  v_name   text;
BEGIN
  SELECT author_id, title INTO v_author, v_title
    FROM posts WHERE id = NEW.post_id;

  IF v_author IS NOT NULL AND v_author <> NEW.profile_id THEN
    SELECT name INTO v_name FROM profiles WHERE id = NEW.profile_id;
    INSERT INTO app_notifications (profile_id, type, title, body, payload)
    VALUES (
      v_author,
      'post_like',
      COALESCE(NULLIF(v_name, ''), 'Someone') || ' liked your post',
      COALESCE(v_title, ''),
      jsonb_build_object('post_id', NEW.post_id)
    );
  END IF;
  RETURN NEW;
END; $$;

DROP TRIGGER IF EXISTS trg_post_like_insert ON post_likes;
CREATE TRIGGER trg_post_like_insert
  AFTER INSERT ON post_likes
  FOR EACH ROW EXECUTE FUNCTION on_post_like_insert();
