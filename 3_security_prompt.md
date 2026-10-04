# PROMPT 3 — SECURITY & ROLE-BASED ACCESS (Shylog Online Store)

Copy everything below into your AI. Use with Prompt 1 (build) and Prompt 2 (UI/UX).

---

## ROLE
You are a senior application security engineer. Implement and document **complete security** for the Shylog online clothing store (Flutter + Express.js + MongoDB + Stripe). Give working code + a short explanation for each control. Follow **OWASP Top 10** and **OWASP ASVS Level 2**.

## 1. AUTHENTICATION
- Passwords: **bcrypt** (cost ≥ 12) or argon2; min 8 chars, upper + lower + number; block common passwords
- **JWT access token** (15 min) + **refresh token** (7 days), refresh rotation + reuse detection, stored hashed in DB
- Web: refresh token in **httpOnly, Secure, SameSite=Strict cookie**; Mobile: `flutter_secure_storage` (Keychain / Keystore) — never SharedPreferences
- Email verification on register; secure forgot-password (single-use, 15-min, hashed token)
- Account lockout / progressive delay after 5 failed logins; generic error messages ("Invalid email or password")
- Optional 2FA (TOTP) for **admin & superadmin**
- Logout invalidates refresh token; "logout all devices"

## 2. ROLE-BASED ACCESS CONTROL (RBAC)

### Roles
| Role | Purpose |
|---|---|
| `customer` | Shop, own cart/orders/profile/reviews |
| `staff` | Manage products, stock, orders (no user/role management) |
| `admin` | Everything staff + users, coupons, reports, refunds |
| `superadmin` | Everything + create/delete admins, system settings, audit logs |

### Permission Matrix
| Action | Customer | Staff | Admin | Superadmin |
|---|:-:|:-:|:-:|:-:|
| Browse products | ✅ | ✅ | ✅ | ✅ |
| Own cart / orders / profile | ✅ | ✅ | ✅ | ✅ |
| Write review (only purchased items) | ✅ | ✅ | ✅ | ✅ |
| Create / edit products | ❌ | ✅ | ✅ | ✅ |
| Delete products | ❌ | ❌ | ✅ | ✅ |
| View all orders | ❌ | ✅ | ✅ | ✅ |
| Update order status | ❌ | ✅ | ✅ | ✅ |
| Refund / cancel paid order | ❌ | ❌ | ✅ | ✅ |
| Manage coupons | ❌ | ❌ | ✅ | ✅ |
| Block / unblock users | ❌ | ❌ | ✅ | ✅ |
| Change user roles | ❌ | ❌ | ❌ | ✅ |
| View audit logs / settings | ❌ | ❌ | ❌ | ✅ |

### Implementation
- `authenticate` middleware (verify JWT) → `authorize(...roles)` middleware → **permission-based** checks (`can('product:delete')`) for fine control
- **Object-level authorization (prevent IDOR):** always query with `{ _id, user: req.user.id }` for customer resources
- **Never trust the client role** — read role from DB/JWT signed by server; role can't be set during register
- Flutter: role-guarded routes with GetX `GetMiddleware` (`auth_middleware.dart`, `role_middleware.dart` in `routes/middlewares/`) + hide UI — **but backend is the real enforcement**
- Admin routes under `/api/v1/admin/*` with extra middleware + IP/rate limiting

## 3. API & SERVER HARDENING (Express)
- `helmet` (CSP, HSTS, X-Frame-Options, noSniff), `hpp`, `compression`
- **CORS:** allow-list only your Vercel domain(s), `credentials: true`, no `*`
- **Rate limiting** (`express-rate-limit` + Redis if possible): global 100/15min, auth 5/15min, payment 10/15min
- **Input validation** on every route (Joi / Zod): type, length, format, whitelist fields (block mass-assignment: never `new Model(req.body)`)
- **NoSQL injection:** `express-mongo-sanitize`; reject objects in query fields (`$ne`, `$gt`)
- **XSS:** sanitize text (`xss` / `sanitize-html`) for reviews, names, addresses; output-encode
- **CSRF:** SameSite cookies + CSRF token for cookie-based web flows
- Body size limit (`10kb` JSON), file upload limits (type whitelist jpg/png/webp, max 2–5 MB, verify magic bytes, random filenames, upload to Cloudinary, never execute)
- Central error handler: no stack traces / internal messages in production
- HTTPS only, HTTP → HTTPS redirect, `trust proxy` configured correctly
- Disable `x-powered-by`; keep dependencies updated (`npm audit`, Dependabot)

## 4. DATABASE SECURITY (MongoDB Atlas)
- Dedicated DB user with least privilege; strong random password
- IP allow-list (backend server only), TLS enforced, no public 0.0.0.0/0 in production
- Never store: plain passwords, raw card data, CVV
- Indexes: unique email, unique order number; schema validation via Mongoose
- Encrypt sensitive fields at rest if needed (phone, address); regular backups + restore test
- Soft-delete users, minimize personal data (GDPR-style: export/delete account)

## 5. PAYMENT SECURITY
- Use **Stripe Checkout / PaymentIntents** — card data never touches your server (PCI-DSS SAQ-A)
- **Calculate price on the server** from DB, never trust price/total from client
- Verify **Stripe webhook signature**; idempotency keys; update order only via webhook
- Validate coupon server-side (expiry, usage limit, min order); stock re-check + atomic decrement at order time (avoid overselling / race conditions)
- COD: order limit and phone verification to reduce fraud

## 6. SECRETS & CONFIG
- All secrets in `.env` (JWT secrets ≥ 64 random chars, DB URI, Stripe keys, Cloudinary) — **never commit**; `.gitignore` + `.env.example`
- Separate dev / prod keys; rotate on leak; use platform secret managers (Render/Vercel env vars)
- Enable GitHub secret scanning; run `git-secrets` / `gitleaks` pre-commit

## 7. FLUTTER CLIENT SECURITY
- `flutter_secure_storage` for tokens; no secrets/API keys in app code (only public keys)
- Certificate pinning (optional) with `dio`; HTTPS only
- Obfuscate release builds (`--obfuscate --split-debug-info`), disable debug logs in release
- Validate all input on client too (UX only — server is the authority)
- Auto-logout on token expiry/401; clear sensitive state on logout
- Prevent screenshot on sensitive screens (optional), root/jailbreak warning (optional)

## 8. LOGGING, MONITORING & AUDIT
- `winston` / `pino` structured logs; **never log passwords, tokens, card data**
- **Audit log** collection: who / what / when / IP for role changes, order status changes, refunds, product deletes, admin logins
- Alerts for repeated failed logins, unusual order volume, 5xx spikes (Sentry / Better Stack)

## 9. DEPLOYMENT & DEVOPS
- CI: lint + tests + `npm audit` + secret scan on every push (GitHub Actions)
- Protect `main` branch, PR reviews, signed commits (optional)
- Security headers on Vercel (`vercel.json`), HSTS preload
- Backups, staging environment, rollback plan

## 10. OWASP TOP 10 CHECKLIST (produce as table: Risk → Where in Shylog → Mitigation → Status)
A01 Broken Access Control · A02 Cryptographic Failures · A03 Injection · A04 Insecure Design · A05 Security Misconfiguration · A06 Vulnerable Components · A07 Auth Failures · A08 Data Integrity Failures · A09 Logging Failures · A10 SSRF

## DELIVERABLES
1. Middleware code: `auth.js`, `role.js` / `permissions.js`, `rateLimiter.js`, `validate.js`, `sanitize.js`, `errorHandler.js`
2. Auth flow code (register, login, refresh rotation, logout, reset password)
3. Role & permission config file + example protected routes
4. Secure Stripe payment + webhook code
5. Flutter: `core/storage/secure_storage.dart`, dio token-refresh interceptor in `core/network/`, `AuthMiddleware` + `RoleMiddleware` (GetX)
6. `.env.example`, `.gitignore`, GitHub Actions security workflow
7. Test cases: IDOR, privilege escalation, injection, brute force, price tampering, XSS
8. Final OWASP checklist table + short pentest checklist

Start with **items 1–3**, then wait for "next".
