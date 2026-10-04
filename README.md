# Shylog — Online Boys' Fashion Store

A modern full-stack e-commerce solution for trendy boys' apparel and accessories.

## Architecture

- **`shylog_app/`**: Flutter cross-platform client (Web, Android, iOS, Desktop) built with **GetX** state management, responsive breakpoints, light/dark themes, and Dio HTTP networking.
- **`shylog-backend/`**: Node.js + Express.js REST API with **MongoDB Atlas**, JWT authentication, security hardening (Helmet, rate limiting, sanitization), and Stripe integration.

## Getting Started

### 1. Backend Setup (`shylog-backend`)
```bash
cd shylog-backend
npm install
# Copy .env.example to .env and configure MONGO_URI
npm run dev
```
The API will run on `http://localhost:5001/api/v1` with health check at `http://localhost:5001/health`.

### 2. Frontend Setup (`shylog_app`)
```bash
cd shylog_app
flutter pub get
flutter run -d chrome
```

## Features
- **Modern Responsive Design**: Adaptive layout for Mobile, Tablet, and Desktop with 0 overflow errors.
- **Interactive Catalog**: Real-time category filtering, search, and sorting.
- **Product Details**: Image gallery, age/size selectors (`4-6 Y`, `6-8 Y`, `8-10 Y`, `10-12 Y`), and color swatches.
- **Shopping Bag & Wishlist**: Reactive cart with coupon code redemption (`SHYLOG15`) and price calculations.
- **Theming**: Instant Dark / Light theme toggle.
