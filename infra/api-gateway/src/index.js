/**
 * Gaijin Life Navi — Cloudflare Workers API Gateway
 *
 * Responsibilities:
 * 1. JWT verification (Firebase RS256 public keys)
 * 2. Routing: /api/v1/ai/* → AI Service, /api/v1/* → App Service
 * 3. Rate limiting (placeholder)
 * 4. CORS handling
 *
 * Environment variables (set via wrangler secret):
 *   APP_SERVICE_URL  — e.g. https://app-service.fly.dev
 *   AI_SERVICE_URL   — e.g. https://ai-service.fly.dev
 *   FIREBASE_PROJECT_ID — Firebase project ID
 */

// ── CORS ──────────────────────────────────────────────────────────────

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PATCH, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  'Access-Control-Max-Age': '86400',
};

function corsResponse(response) {
  const newHeaders = new Headers(response.headers);
  for (const [key, value] of Object.entries(CORS_HEADERS)) {
    newHeaders.set(key, value);
  }
  return new Response(response.body, {
    status: response.status,
    statusText: response.statusText,
    headers: newHeaders,
  });
}

function handleOptions() {
  return new Response(null, { status: 204, headers: CORS_HEADERS });
}

// ── Error helpers ─────────────────────────────────────────────────────

function errorResponse(status, code, message, details = {}) {
  return corsResponse(
    new Response(
      JSON.stringify({ error: { code, message, details } }),
      {
        status,
        headers: { 'Content-Type': 'application/json' },
      }
    )
  );
}

// ── Public endpoints (no auth required) ───────────────────────────────

const PUBLIC_PATHS = [
  '/api/v1/health',
  '/api/v1/auth/register',
  '/api/v1/banking/banks',
  '/api/v1/subscriptions/plans',
  '/api/v1/subscriptions/webhook',
];

function isPublicPath(pathname) {
  return PUBLIC_PATHS.some(
    (p) => pathname === p || pathname.startsWith(p + '/')
  );
}

// ── Firebase JWT verification ─────────────────────────────────────────

// Cache for Firebase public keys (JWKs)
let cachedKeys = null;
let cachedKeysExpiry = 0;

async function getFirebasePublicKeys() {
  const now = Date.now();
  if (cachedKeys && now < cachedKeysExpiry) {
    return cachedKeys;
  }

  const response = await fetch(
    'https://www.googleapis.com/robot/v1/metadata/jwk/securetoken@system.gserviceaccount.com'
  );

  if (!response.ok) {
    throw new Error('Failed to fetch Firebase public keys');
  }

  // Cache based on Cache-Control header
  const cacheControl = response.headers.get('Cache-Control') || '';
  const maxAgeMatch = cacheControl.match(/max-age=(\d+)/);
  const maxAge = maxAgeMatch ? parseInt(maxAgeMatch[1], 10) : 3600;
  cachedKeysExpiry = now + maxAge * 1000;

  const data = await response.json();
  cachedKeys = data.keys;
  return cachedKeys;
}

function base64UrlDecode(str) {
  str = str.replace(/-/g, '+').replace(/_/g, '/');
  while (str.length % 4) str += '=';
  const binary = atob(str);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i++) {
    bytes[i] = binary.charCodeAt(i);
  }
  return bytes;
}

async function verifyFirebaseToken(token, projectId) {
  // Decode header to get kid
  const parts = token.split('.');
  if (parts.length !== 3) {
    throw new Error('Invalid JWT format');
  }

  const header = JSON.parse(new TextDecoder().decode(base64UrlDecode(parts[0])));

  if (header.alg !== 'RS256') {
    throw new Error('Unsupported algorithm');
  }

  // Get matching public key
  const keys = await getFirebasePublicKeys();
  const key = keys.find((k) => k.kid === header.kid);
  if (!key) {
    throw new Error('No matching key found');
  }

  // Import the public key
  const cryptoKey = await crypto.subtle.importKey(
    'jwk',
    key,
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false,
    ['verify']
  );

  // Verify signature
  const signatureInput = new TextEncoder().encode(parts[0] + '.' + parts[1]);
  const signature = base64UrlDecode(parts[2]);

  const valid = await crypto.subtle.verify(
    'RSASSA-PKCS1-v1_5',
    cryptoKey,
    signature,
    signatureInput
  );

  if (!valid) {
    throw new Error('Invalid signature');
  }

  // Decode and validate claims
  const payload = JSON.parse(new TextDecoder().decode(base64UrlDecode(parts[1])));
  const now = Math.floor(Date.now() / 1000);

  if (payload.exp && payload.exp < now) {
    throw new Error('Token expired');
  }
  if (payload.iat && payload.iat > now + 300) {
    throw new Error('Token issued in the future');
  }
  if (payload.aud !== projectId) {
    throw new Error('Invalid audience');
  }
  if (
    payload.iss !==
    `https://securetoken.google.com/${projectId}`
  ) {
    throw new Error('Invalid issuer');
  }

  return payload;
}

// ── Rate limiting (placeholder) ───────────────────────────────────────

// TODO: Implement rate limiting using Cloudflare Rate Limiting API or
// Durable Objects for sliding window counters.
// See BUSINESS_RULES.md §10 for rate limit values.
// For now, this is a no-op.
async function checkRateLimit(_request, _userId) {
  return { allowed: true };
}

// ── Routing ───────────────────────────────────────────────────────────

function getUpstreamUrl(pathname, env) {
  const appServiceUrl =
    env.APP_SERVICE_URL || 'http://localhost:8000';
  const aiServiceUrl =
    env.AI_SERVICE_URL || 'http://localhost:8001';

  // /api/v1/ai/* → AI Service
  if (pathname.startsWith('/api/v1/ai/')) {
    return aiServiceUrl;
  }

  // /api/v1/* → App Service
  if (pathname.startsWith('/api/v1/')) {
    return appServiceUrl;
  }

  return null;
}

// ── Main handler ──────────────────────────────────────────────────────

export default {
  async fetch(request, env, _ctx) {
    const url = new URL(request.url);
    const { pathname } = url;

    // Handle CORS preflight
    if (request.method === 'OPTIONS') {
      return handleOptions();
    }

    // Find upstream
    const upstreamBase = getUpstreamUrl(pathname, env);
    if (!upstreamBase) {
      return errorResponse(404, 'NOT_FOUND', 'Endpoint not found');
    }

    // Auth check (skip for public endpoints)
    let userId = null;
    if (!isPublicPath(pathname)) {
      const authHeader = request.headers.get('Authorization');
      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return errorResponse(
          401,
          'UNAUTHORIZED',
          'Missing or invalid Authorization header'
        );
      }

      const token = authHeader.slice(7);
      const projectId =
        env.FIREBASE_PROJECT_ID || 'gaijin-life-navi';

      try {
        const decoded = await verifyFirebaseToken(token, projectId);
        userId = decoded.sub || decoded.user_id;
      } catch (err) {
        return errorResponse(
          401,
          'UNAUTHORIZED',
          'Invalid or expired authentication token'
        );
      }
    }

    // Rate limiting (placeholder)
    const rateResult = await checkRateLimit(request, userId);
    if (!rateResult.allowed) {
      return errorResponse(
        429,
        'RATE_LIMITED',
        'Too many requests. Please try again later.',
        { retry_after: rateResult.retryAfter || 60 }
      );
    }

    // Proxy request to upstream
    const upstreamUrl = new URL(pathname + url.search, upstreamBase);
    const upstreamHeaders = new Headers(request.headers);

    // Forward user ID to upstream service
    if (userId) {
      upstreamHeaders.set('X-User-ID', userId);
    }

    // Remove hop-by-hop headers
    upstreamHeaders.delete('Host');

    try {
      const upstreamResponse = await fetch(upstreamUrl.toString(), {
        method: request.method,
        headers: upstreamHeaders,
        body:
          request.method !== 'GET' && request.method !== 'HEAD'
            ? request.body
            : undefined,
      });

      return corsResponse(upstreamResponse);
    } catch (err) {
      return errorResponse(
        502,
        'INTERNAL_ERROR',
        'Upstream service unavailable'
      );
    }
  },
};
