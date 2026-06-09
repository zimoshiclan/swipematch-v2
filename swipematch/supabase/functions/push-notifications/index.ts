import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface PushPayload {
  userId: string;
  title: string;
  body: string;
  data?: Record<string, string>;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const payload: PushPayload = await req.json();
    const { userId, title, body, data = {} } = payload;

    if (!userId || !title || !body) {
      return json({ error: "Missing userId, title, or body" }, 400);
    }

    const fcmKey = Deno.env.get("FCM_SERVER_KEY");
    if (!fcmKey) {
      return json({ error: "FCM_SERVER_KEY not configured" }, 503);
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    // Fetch FCM token for user
    const { data: profile } = await supabase
      .from("profiles")
      .select("id")
      .eq("user_id", userId)
      .maybeSingle();

    if (!profile) {
      return json({ error: "Profile not found" }, 404);
    }

    // Fetch FCM token from notifications table or profile
    // For now we broadcast to topic based on user_id
    const topic = `user_${userId.replace(/-/g, "_")}`;

    const fcmPayload = {
      to: `/topics/${topic}`,
      notification: { title, body },
      data,
      android: {
        priority: "high",
        notification: {
          channel_id: "swipematch_default",
          sound: "default",
        },
      },
      apns: {
        payload: {
          aps: { sound: "default", badge: 1 },
        },
      },
    };

    const fcmRes = await fetch("https://fcm.googleapis.com/fcm/send", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `key=${fcmKey}`,
      },
      body: JSON.stringify(fcmPayload),
    });

    if (!fcmRes.ok) {
      const errText = await fcmRes.text();
      return json({ error: `FCM error: ${errText}` }, 500);
    }

    const fcmResult = await fcmRes.json();
    return json({ ok: true, fcmResult });
  } catch (err) {
    return json({ error: String(err) }, 500);
  }
});

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
