-- Add headline and AI readiness score to profiles
ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS headline text,
  ADD COLUMN IF NOT EXISTS ai_readiness_score int;

-- Posts table
CREATE TABLE IF NOT EXISTS posts (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id     uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  type          text NOT NULL CHECK (type IN ('research','essay','achievement','collaboration','insight')),
  title         text NOT NULL,
  content       text NOT NULL,
  tags          text[] NOT NULL DEFAULT '{}',
  likes_count   int NOT NULL DEFAULT 0,
  comments_count int NOT NULL DEFAULT 0,
  created_at    timestamptz NOT NULL DEFAULT now()
);

-- Post likes (composite PK prevents double-liking)
CREATE TABLE IF NOT EXISTS post_likes (
  post_id    uuid NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  profile_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (post_id, profile_id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS posts_author_id_idx    ON posts(author_id);
CREATE INDEX IF NOT EXISTS posts_created_at_idx   ON posts(created_at DESC);
CREATE INDEX IF NOT EXISTS post_likes_profile_idx ON post_likes(profile_id);

-- RLS: posts
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone authenticated can read posts"
  ON posts FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Author can insert posts"
  ON posts FOR INSERT
  TO authenticated
  WITH CHECK (author_id = (
    SELECT id FROM profiles WHERE user_id = auth.uid() LIMIT 1
  ));

CREATE POLICY "Author can delete own posts"
  ON posts FOR DELETE
  TO authenticated
  USING (author_id = (
    SELECT id FROM profiles WHERE user_id = auth.uid() LIMIT 1
  ));

-- RLS: post_likes
ALTER TABLE post_likes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone authenticated can read post_likes"
  ON post_likes FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "User can like"
  ON post_likes FOR INSERT
  TO authenticated
  WITH CHECK (profile_id = (
    SELECT id FROM profiles WHERE user_id = auth.uid() LIMIT 1
  ));

CREATE POLICY "User can unlike"
  ON post_likes FOR DELETE
  TO authenticated
  USING (profile_id = (
    SELECT id FROM profiles WHERE user_id = auth.uid() LIMIT 1
  ));

-- Atomic like counter RPCs (SECURITY DEFINER bypasses RLS for the counter update)
CREATE OR REPLACE FUNCTION increment_post_likes(p_post_id uuid)
RETURNS void
LANGUAGE sql
SECURITY DEFINER
AS $$
  UPDATE posts SET likes_count = likes_count + 1 WHERE id = p_post_id;
$$;

CREATE OR REPLACE FUNCTION decrement_post_likes(p_post_id uuid)
RETURNS void
LANGUAGE sql
SECURITY DEFINER
AS $$
  UPDATE posts
  SET likes_count = GREATEST(0, likes_count - 1)
  WHERE id = p_post_id;
$$;

-- Connections table (people-to-people bilateral matches)
CREATE TABLE IF NOT EXISTS connections (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  requester_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  receiver_id  uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  status       text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','accepted','declined')),
  created_at   timestamptz NOT NULL DEFAULT now(),
  UNIQUE (requester_id, receiver_id)
);

CREATE INDEX IF NOT EXISTS connections_receiver_idx ON connections(receiver_id);

ALTER TABLE connections ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read their own connections"
  ON connections FOR SELECT
  TO authenticated
  USING (
    requester_id = (SELECT id FROM profiles WHERE user_id = auth.uid() LIMIT 1)
    OR
    receiver_id  = (SELECT id FROM profiles WHERE user_id = auth.uid() LIMIT 1)
  );

CREATE POLICY "Users can send connection requests"
  ON connections FOR INSERT
  TO authenticated
  WITH CHECK (requester_id = (
    SELECT id FROM profiles WHERE user_id = auth.uid() LIMIT 1
  ));

CREATE POLICY "Receiver can update status"
  ON connections FOR UPDATE
  TO authenticated
  USING (receiver_id = (
    SELECT id FROM profiles WHERE user_id = auth.uid() LIMIT 1
  ));
