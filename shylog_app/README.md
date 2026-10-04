# Shylog Online Store — Flutter Application

Production-ready Flutter cross-platform mobile/web/desktop app for **Shylog** (Boys' Fashion Online Store).

## Tech Stack & Architecture
- **Framework:** Flutter (Web, Mobile, Desktop)
- **State Management & Routing:** GetX (`GetxController`, `GetMaterialApp`, `GetPage` routes, `Bindings`, `GetMiddleware`)
- **Networking:** Dio HTTP client with custom Interceptors (Token refresh & Bearer authentication)
- **Local Storage:** `GetStorage` (non-sensitive state) & `flutter_secure_storage` (JWT tokens)
- **UI & Styling:** Custom Theme System (Light & Dark), Responsive Layout System (`ResponsiveBuilder`), Google Fonts (Poppins & Inter), Shimmer Skeletons, Custom Components

## Folder Structure
```
shylog_app/
├── lib/
│   ├── main.dart                     # App entry point, storage init, bindings
│   ├── core/
│   │   ├── constants/                # Colors, strings, sizes, API endpoints
│   │   ├── theme/                    # AppTheme (Light & Dark)
│   │   ├── utils/                    # ResponsiveBuilder, Breakpoints, Formatters
│   │   ├── network/                  # DioClient, Auth Interceptors, Exception handlers
│   │   ├── storage/                  # SecureStorage, LocalStorage
│   │   └── widgets/                  # Shared UI components (AppButton, AppTextField, ProductCard, etc.)
│   ├── data/
│   │   ├── models/                   # UserModel, ProductModel, CategoryModel, CartModel, OrderModel, etc.
│   │   ├── repositories/             # AuthRepository, ProductRepository, CartRepository, OrderRepository
│   │   └── services/                 # AuthService, ProductService, OrderService, PaymentService
│   ├── modules/
│   │   ├── authentication/           # Login, Register, Forgot Password
│   │   ├── home/                     # Banners, Categories, New Arrivals, Best Sellers
│   │   ├── products/                 # Listing, Search, Filters, Detail view
│   │   ├── cart/                     # Shopping cart management
│   │   ├── checkout/                 # Address, Shipping, Payment selection
│   │   ├── orders/                   # Order history, Tracking, Return requests
│   │   ├── wishlist/                 # Saved items
│   │   ├── profile/                  # Edit profile, Addresses, Change password
│   │   └── admin/                    # Admin KPI Dashboard, Product CRUD, Order Fulfillment, Users, Coupons
│   └── routes/
│       ├── app_routes.dart           # Named route definitions
│       ├── app_pages.dart            # GetPage route configurations & bindings
│       └── middlewares/              # AuthMiddleware, RoleMiddleware
└── pubspec.yaml
```

## Running the App
```bash
flutter pub get
flutter run -d chrome # Or android/ios/windows
```
