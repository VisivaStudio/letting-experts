import "jsr:@supabase/functions-js/edge-runtime.d.ts";

Deno.serve(async (req) => {
  try {
    const payload = await req.json();
    const lead = payload.record;
    const body = JSON.stringify({ type: "lead_created", lead }, null, 2);
    return new Response(body, { status: 200, headers: { "Content-Type": "application/json" } });
  } catch {
    return new Response("bad request", { status: 400 });
  }
});
