-- RPC: record a person-to-person swipe and detect mutual connections.
CREATE OR REPLACE FUNCTION public.record_person_swipe(
  p_swiper_user_id    uuid,
  p_swiper_profile_id uuid,
  p_target_profile_id uuid,
  p_direction         text
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_mutual_exists boolean := false;
  v_connection_id  uuid;
  v_match_id       uuid;
BEGIN
  INSERT INTO public.swipes (user_id, target_id, target_type, direction)
  VALUES (p_swiper_user_id, p_target_profile_id, 'person', p_direction)
  ON CONFLICT DO NOTHING;

  IF p_direction NOT IN ('right', 'super') THEN
    RETURN jsonb_build_object('connected', false);
  END IF;

  SELECT EXISTS (
    SELECT 1 FROM public.swipes s
    JOIN public.profiles pr ON pr.user_id = s.user_id
    WHERE pr.id = p_target_profile_id
      AND s.target_id = p_swiper_profile_id
      AND s.target_type = 'person'
      AND s.direction IN ('right', 'super')
  ) INTO v_mutual_exists;

  IF NOT v_mutual_exists THEN
    RETURN jsonb_build_object('connected', false);
  END IF;

  INSERT INTO public.connections (requester_id, receiver_id, status)
  VALUES (p_swiper_profile_id, p_target_profile_id, 'accepted')
  ON CONFLICT (requester_id, receiver_id) DO UPDATE SET status = 'accepted'
  RETURNING id INTO v_connection_id;

  INSERT INTO public.matches (candidate_id, job_id, company_id, match_score, status)
  VALUES (p_swiper_profile_id, p_target_profile_id, p_target_profile_id, 100, 'new_match')
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_match_id;

  IF v_match_id IS NULL THEN
    SELECT id INTO v_match_id FROM public.matches
    WHERE candidate_id = p_swiper_profile_id AND job_id = p_target_profile_id
    LIMIT 1;
  END IF;

  RETURN jsonb_build_object('connected', true, 'connection_id', v_connection_id, 'match_id', v_match_id);
END;
$$;

GRANT EXECUTE ON FUNCTION public.record_person_swipe(uuid,uuid,uuid,text) TO authenticated;
