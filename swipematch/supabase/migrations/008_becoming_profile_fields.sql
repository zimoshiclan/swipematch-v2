ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS working_toward    text,
  ADD COLUMN IF NOT EXISTS currently_learning text,
  ADD COLUMN IF NOT EXISTS work_values        text[] DEFAULT '{}';
