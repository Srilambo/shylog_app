# Shylog Online Store — Backend REST API

Production-ready Node.js + Express.js + MongoDB backend API for **Shylog** (Boys' Fashion Online Store).

## Tech Stack
- **Runtime:** Node.js (v18+)
- **Framework:** Express.js
- **Database:** MongoDB Atlas with Mongoose ORM
- **Security:** JWT (Access + Refresh token rotation), bcryptjs, Helmet, Rate Limiting, Mongo Sanitize, HPP, XSS Clean
- **Services:** Stripe PaymentIntents & Webhooks, Cloudinary Image Hosting
- **Validation:** Joi schema validation

## Folder Structure
```
shylog-backend/
├── src/
│   ├── config/          # Database, Cloudinary, Stripe, Env configs
│   ├── models/          # User, Product, Category, Cart, Order, Review, Coupon, Wishlist, RefreshToken, AuditLog
│   ├── controllers/     # Auth, User, Product, Category, Cart, Order, Payment, Review, Coupon, Admin
│   ├── routes/          # Express route definitions per module
│   ├── middleware/      # Auth, Role/RBAC, Joi Validation, Sanitize, Rate Limiter, Error Handler
│   ├── validators/      # Joi schema definitions
│   ├── services/        # Stripe, Cloudinary, Email, Invoice services
│   ├── utils/           # ApiError, asyncHandler, logger, pagination
│   ├── seed/            # Sample boys' clothing product & admin user seeder
│   ├── app.js           # Express app setup & middleware pipeline
│   └── server.js        # Server listener entrypoint
├── .env.example
├── package.json
└── README.md
```

## Setup & Running
1. `npm install`
2. Copy `.env.example` to `.env` and fill in credentials.
3. `npm run seed` (to populate MongoDB with ~30 sample boys' clothing items and admin credentials)
4. `npm run dev` (starts server on `http://localhost:5000`)
