# PROMPT 1 — PROJECT BUILD (Shylog Online Store)

Copy everything below into your AI (Claude / Cursor / Copilot).

---

## ROLE
You are a senior full-stack engineer. Build a complete, production-style **online clothing store** called **Shylog** that sells **boys' trendy shirts, pants, and other items** (t-shirts, shorts, hoodies, jackets, shoes, accessories). Give full working code, not pseudo-code.

## TECH STACK
- **Frontend:** Flutter (single codebase → Android, iOS, Web, Desktop), state management + routing + dependency injection with **GetX** (controllers, bindings, `GetPage` routes), HTTP with **dio**, local storage with **get_storage** + `flutter_secure_storage`
- **Backend:** Node.js + Express.js (REST API, versioned `/api/v1`)
- **Database:** MongoDB Atlas + Mongoose
- **Auth:** JWT (access + refresh token), bcrypt
- **Images:** Cloudinary (product images)
- **Payments:** Stripe (test mode) + Cash on Delivery option
- **Deploy:** GitHub (code), Vercel (Flutter web build), Render/Railway (API)

## CORE FEATURES
### Customer
1. Register / Login / Logout / Forgot password
2. Home: banner slider, categories (Shirts, Pants, T-Shirts, Shorts, Hoodies, Shoes, Accessories), New Arrivals, Best Sellers
3. Product listing with **search, filter (category, size, color, price range, brand), sort (price, newest, popularity)**, pagination / infinite scroll
4. Product detail: image gallery, size selector (by age/size: 4–6, 6–8, 8–10, 10–12, 12–14, 14–16 or S/M/L/XL), color selector, stock status, add to cart, add to wishlist, reviews & ratings
5. Cart (update qty, remove, price summary, coupon code)
6. Checkout: address book, delivery method, payment (Stripe / COD), order confirmation
7. Orders: history, status tracking (Pending → Confirmed → Packed → Shipped → Delivered / Cancelled), cancel / return request
8. Profile: edit details, addresses, change password
9. Wishlist

### Admin
1. Dashboard: total sales, orders today, low-stock alerts, top products (charts)
2. Product CRUD (multiple images, variants: size × color × stock × price)
3. Category & brand management
4. Order management (update status, view customer, print invoice)
5. User management (view, block/unblock, change role)
6. Coupon management
7. Review moderation

## USER ROLES
`customer`, `staff` (manage orders + products), `admin` (everything), `superadmin` (manage admins) — enforced on backend AND frontend.

## FOLDER STRUCTURE

### Backend
```
shylog-backend/
├── src/
│   ├── config/          # db.js, cloudinary.js, stripe.js, env.js
│   ├── models/          # User, Product, Category, Cart, Order, Review, Coupon, Wishlist, RefreshToken
│   ├── controllers/     # auth, user, product, category, cart, order, payment, review, coupon, admin
│   ├── routes/          # one file per controller + index.js
│   ├── middleware/      # auth.js, role.js, validate.js, errorHandler.js, rateLimiter.js, upload.js
│   ├── validators/      # Joi/Zod schemas
│   ├── services/        # email, payment, token, invoice
│   ├── utils/           # ApiError, asyncHandler, logger, pagination
│   ├── seed/            # seed.js (sample boys' clothing data + admin user)
│   ├── app.js
│   └── server.js
├── tests/
├── .env.example
├── package.json
└── README.md
```

### Frontend (Flutter) — Clean, Scalable, Maintainable, Testable (GetX modular architecture)
```
shylog_app/
├── lib/
│   ├── main.dart                     # app entry, init storage, bindings, GetMaterialApp
│   │
│   ├── core/
│   │   ├── constants/                # app_colors, app_strings, app_sizes, api_endpoints
│   │   ├── theme/                    # app_theme.dart (light + dark), text styles
│   │   ├── utils/                    # validators, formatters, responsive.dart, helpers
│   │   ├── network/                  # dio_client.dart, interceptors (token attach + refresh), api_exception
│   │   ├── storage/                  # secure_storage.dart, local_storage.dart (get_storage)
│   │   └── widgets/                  # shared: AppButton, AppTextField, ProductCard, LoadingView, ErrorView, EmptyView
│   │
│   ├── data/
│   │   ├── models/                   # user_model, product_model, category_model, cart_item_model, order_model, review_model, coupon_model
│   │   ├── repositories/             # auth_repository, product_repository, cart_repository, order_repository, ...
│   │   └── services/                 # auth_service, product_service, order_service, payment_service (API calls via dio)
│   │
│   ├── modules/
│   │   ├── authentication/
│   │   │   ├── controllers/          # auth_controller.dart
│   │   │   ├── views/                # login_view, register_view, forgot_password_view
│   │   │   ├── widgets/              # auth_form, social_button
│   │   │   └── bindings/             # auth_binding.dart
│   │   ├── home/                     # controllers / views / widgets / bindings (banners, categories, new arrivals)
│   │   ├── products/                 # listing, filters, product detail, size guide
│   │   ├── cart/
│   │   ├── checkout/
│   │   ├── orders/                   # history, tracking, return request
│   │   ├── wishlist/
│   │   ├── profile/                  # edit profile, addresses, change password
│   │   └── admin/
│   │       ├── dashboard/
│   │       ├── products/
│   │       ├── orders/
│   │       ├── users/
│   │       └── coupons/              # each with controllers / views / widgets / bindings
│   │
│   └── routes/
│       ├── app_routes.dart           # route name constants
│       ├── app_pages.dart            # GetPage list + bindings
│       └── middlewares/              # auth_middleware.dart, role_middleware.dart (GetMiddleware)
│
├── assets/ (images, icons, fonts)
├── test/                             # controller + repository unit tests, widget tests
└── pubspec.yaml
```

**Layer flow (follow strictly):**
`View (UI)  →  GetX Controller (state + business logic)  →  Repository  →  Service (dio / storage)  →  External (REST API, local storage, Stripe, Cloudinary)`

| Layer | Folder | Responsibility |
|---|---|---|
| Presentation | `modules/*/views`, `widgets` | Screens, widgets, user interaction, navigation only — **no API calls or business logic** |
| State management | `modules/*/controllers` | GetX controllers: `Rx` state, loading/error state, business rules, call repositories |
| Data | `data/models`, `repositories`, `services` | Models (`fromJson`/`toJson`), repositories hide data source, services do HTTP/storage calls |
| Core | `core/*` | Constants, theme, utils, network client, storage, shared widgets |
| External | — | APIs, local storage, Stripe, Cloudinary, third-party services |

**Frontend rules:**
- One module = `controllers/ + views/ + widgets/ + bindings/`; adding a new feature must not need edits outside its module (except `app_pages.dart`)
- Controllers registered via `Bindings` (lazy `Get.lazyPut`), not inside build methods
- Use `Obx` / `GetBuilder` for reactive UI; dispose controllers properly
- Repositories return typed models / `Result` objects; controllers never touch `dio` directly
- Named routes only (`Get.toNamed(AppRoutes.productDetail, arguments: ...)`); role and auth guards via `GetMiddleware`

## DATABASE SCHEMAS (Mongoose)
- **User:** name, email(unique), passwordHash, phone, role, addresses[], isBlocked, createdAt
- **Product:** name, slug, description, brand ("Shylog"), category(ref), images[], variants[{size, color, sku, stock, price}], basePrice, discountPrice, tags[], ratingAvg, ratingCount, isActive
- **Category:** name, slug, image, parent(ref)
- **Cart:** user(ref), items[{product, variantSku, qty}]
- **Order:** user, items[snapshot], shippingAddress, paymentMethod, paymentStatus, orderStatus, subtotal, shipping, discount, total, statusHistory[]
- **Review:** user, product, rating(1–5), comment
- **Coupon:** code, type(percent/fixed), value, minOrder, expiry, usageLimit, usedCount

## API ENDPOINTS (summary)
```
POST   /api/v1/auth/register | login | refresh | logout | forgot-password | reset-password
GET    /api/v1/products?search=&category=&size=&color=&minPrice=&maxPrice=&sort=&page=&limit=
GET    /api/v1/products/:slug
POST/PUT/DELETE /api/v1/products            (staff/admin)
GET/POST/PUT/DELETE /api/v1/cart
POST   /api/v1/orders            GET /api/v1/orders/my     PATCH /api/v1/orders/:id/status (staff/admin)
POST   /api/v1/payments/create-intent
POST   /api/v1/reviews
GET    /api/v1/admin/stats       (admin)
```

## CODING RULES
- Clean architecture, small reusable widgets/functions, no duplicated code
- Every API response format: `{ success, message, data, meta? }`
- Central error handler, async wrapper, input validation on every route
- Environment variables only for secrets (`.env.example` provided)
- Comments only where logic is non-obvious
- Include seed script with ~30 sample boys' products (shirts, pants, shorts, hoodies)

## OUTPUT ORDER (give step by step, wait for "next")
1. Full folder tree + setup commands
2. Backend: config → models → middleware → controllers/routes
3. Backend: seed data + Postman collection
4. Flutter: `core/` (constants, theme, network, storage, responsive helpers) + `routes/` + `main.dart`
5. Flutter: `data/` layer (models, repositories, services), then modules one by one: authentication → home → products → cart → checkout → orders
6. Flutter: admin panel
7. Deployment guide (GitHub, Vercel, Render, MongoDB Atlas) + README

Start with **Step 1**.
