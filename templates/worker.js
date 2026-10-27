// Cloudflare Worker skeleton (from Sport Conditions). A small program that
// Cloudflare runs for free, for the things a web page can't do by itself:
//   1. Fetch from services that don't let web pages read their data (no CORS).
//   2. Use a secret API key, stored in Cloudflare as a secret (env.MY_API_KEY),
//      so it's never in the app's code for anyone to copy.
//   3. Sync data between devices, in Cloudflare's free KV storage (env.SYNC).
// Only handle specific, checked requests: never act as an open proxy.

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST",
};

export default {
  async fetch(request, env, ctx) {
    try {
      const url = new URL(request.url);
      if (url.pathname === "/example") return await example(request, url, env, ctx);
      if (url.pathname === "/sync") return await sync(request, url, env);
      return reply("Not found", 404);
    } catch (error) {
      // Always answer with CORS, even when something breaks, so the app can
      // see the error instead of a blocked request.
      return reply(`Worker error: ${error.message}`, 500);
    }
  },
};

function reply(text, status) {
  return new Response(text, { status, headers: CORS });
}

// Answers from Cloudflare's cache if we fetched the same thing recently;
// otherwise runs `load`, and caches a good answer for `seconds`.
async function cached(request, ctx, seconds, load) {
  const cache = caches.default;
  const hit = await cache.match(request);
  if (hit) return hit;
  const upstream = await load();
  const response = new Response(upstream.body, {
    status: upstream.status,
    headers: { ...CORS, "Content-Type": "application/json", "Cache-Control": `public, max-age=${seconds}` },
  });
  if (upstream.ok) ctx.waitUntil(cache.put(request, response.clone()));
  return response;
}

// ---------- Example: a source that needs a key or blocks browsers ----------

async function example(request, url, env, ctx) {
  // Check every input strictly before using it.
  const id = url.searchParams.get("id") || "";
  if (!/^[A-Za-z0-9]{1,10}$/.test(id)) return reply("Bad id", 400);
  return cached(request, ctx, 300, () =>
    fetch(`https://api.example.com/things/${id}`, {
      headers: { "Authorization": `Bearer ${env.MY_API_KEY}`, "User-Agent": "my-app" },
    }));
}

// ---------- Sync between devices (KV namespace bound as SYNC) ----------

async function sync(request, url, env) {
  if (!env.SYNC) return reply("No SYNC storage connected to this Worker", 503);
  // Long random codes made by the app, e.g. "kite-4f9c2a7e1b3d5f60".
  const code = url.searchParams.get("code") || "";
  if (!/^[a-z]+-[0-9a-f]{16}$/.test(code)) return reply("Bad sync code", 400);
  const key = `sync:${code}`;

  if (request.method === "GET") {
    const saved = await env.SYNC.get(key);
    return new Response(saved || "null", { headers: { ...CORS, "Content-Type": "application/json", "Cache-Control": "no-store" } });
  }
  if (request.method === "POST") {
    // The app sends text/plain, so browsers skip the extra "preflight" check.
    const body = await request.text();
    if (body.length > 200000) return reply("Too much data", 413);
    JSON.parse(body);  // throws (→ 500) if it isn't valid JSON
    await env.SYNC.put(key, body);
    return reply("Saved", 200);
  }
  return reply("Use GET or POST", 405);
}
