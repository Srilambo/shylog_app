# PROMPT 2 — UI/UX DESIGN (Shylog Online Store)

Copy everything below into your AI. Use it together with Prompt 1.

---

## ROLE
You are a senior UI/UX designer + Flutter UI engineer. Design and code the **Shylog** boys' fashion store UI. It must look modern, youthful, clean, and be **fully responsive on all phones, tablets, and desktops with ZERO overflow errors**.

## BRAND FEEL
Trendy, energetic, clean, trustworthy. Target buyers: parents (25–45) buying for boys, and teen boys (13–17). Lots of white space, big product photos, bold but simple typography.

## COLOR SYSTEM

### Option A — "Shylog Blue" (recommended)
| Role | Color | Hex |
|---|---|---|
| Primary | Royal Blue | `#2563EB` |
| Primary Dark | Navy | `#0F172A` |
| Secondary / Accent | Sunny Orange | `#F97316` |
| Background | Off White | `#F8FAFC` |
| Surface / Card | White | `#FFFFFF` |
| Text Primary | Slate 900 | `#0F172A` |
| Text Secondary | Slate 500 | `#64748B` |
| Border | Slate 200 | `#E2E8F0` |
| Success | Green | `#16A34A` |
| Warning | Amber | `#F59E0B` |
| Error | Red | `#DC2626` |

### Option B — "Street Dark"
Primary `#111827`, Accent `#22D3EE`, Highlight `#FACC15`, Background `#F3F4F6`

### Option C — "Fresh Mint"
Primary `#0D9488`, Accent `#FB7185`, Background `#F0FDFA`, Text `#134E4A`

Rules: 60% neutral / 30% primary / 10% accent. Sale badge = accent color. "Add to cart" = primary. Text/background contrast ≥ 4.5:1 (WCAG AA). Provide **light + dark theme** using `ColorScheme`.

## TYPOGRAPHY
- Headings: **Poppins** (600/700) — Body: **Inter** (400/500)
- Scale: H1 28–32, H2 22–24, H3 18–20, Body 14–16, Caption 12
- Use `Theme.of(context).textTheme` only — no hard-coded sizes in widgets
- Support text scaling up to 1.3× without breaking layouts

## SPACING & SHAPE
- 8-pt grid: 4, 8, 12, 16, 24, 32, 48
- Radius: buttons 12, cards 16, chips 999
- Soft shadows (elevation 1–3), min tap target **48×48**

## RESPONSIVE BREAKPOINTS
| Name | Width | Layout |
|---|---|---|
| Mobile S | < 360 | 1 column, compact padding (12) |
| Mobile | 360–599 | Product grid **2 cols**, bottom nav |
| Tablet | 600–1023 | Grid **3 cols**, navigation rail |
| Desktop | 1024–1439 | Grid **4 cols**, top nav bar, max content width 1200 |
| Large Desktop | ≥ 1440 | Grid **5 cols**, content centered, max width 1400 |

Create `ResponsiveBuilder` + `Breakpoints` helper + `ContentConstraint` (centered `ConstrainedBox`) in `core/utils/responsive.dart`.

## NO-OVERFLOW RULES (MANDATORY)
1. Never use fixed widths/heights for text containers; use `Flexible`, `Expanded`, `FittedBox`, `LayoutBuilder`
2. Every `Row` with text → wrap text in `Expanded`/`Flexible` + `maxLines` + `overflow: TextOverflow.ellipsis`
3. Every scrollable page → `SingleChildScrollView`/`CustomScrollView`; never a `Column` taller than screen without scroll
4. Grids → `SliverGridDelegateWithMaxCrossAxisExtent` or column count from breakpoint; product card uses `AspectRatio` (image 4:5), not hard heights
5. Never put `ListView`/`GridView` inside `Column` without `Expanded` or `shrinkWrap` + `NeverScrollableScrollPhysics`
6. Use `SafeArea`, `MediaQuery.viewInsets` (keyboard), `resizeToAvoidBottomInset`
7. Images: `CachedNetworkImage` + `BoxFit.cover` + placeholder + error widget
8. Use `Wrap` instead of `Row` for chips, size options, color swatches
9. Dialogs/bottom sheets: `ConstrainedBox(maxWidth: 480)` + scrollable content
10. Test at widths: **320, 360, 390, 412, 600, 768, 1024, 1280, 1440, 1920** + landscape + text scale 1.3 — fix every yellow-black stripe
11. Web: no horizontal scroll (`overflow-x` hidden at root), desktop tables in `SingleChildScrollView(horizontal)` only when needed

## LAYOUTS PER SCREEN

### Home
- **Mobile:** search bar → banner carousel (16:9) → horizontal category chips → "New Arrivals" (2-col grid) → "Best Sellers" → footer; bottom nav (Home, Shop, Wishlist, Cart, Profile)
- **Desktop:** sticky top nav (logo, categories mega-menu, search, cart, account) → hero banner split (text left, image right) → category tiles row (6) → product grids (4–5 cols) → newsletter → multi-column footer

### Product Listing
- **Mobile:** filter + sort buttons open bottom sheet; 2-col grid
- **Desktop:** left sidebar filters (280px: category, size, color swatches, price slider) + right grid; sort dropdown top-right; pagination

### Product Detail
- **Mobile:** image carousel with dots → name, price, rating → size chips (Wrap) → color swatches → qty → sticky bottom bar (Add to Cart + Wishlist)
- **Desktop:** 2 columns — thumbnails + large image (left, 55%), details (right, 45%), tabs below (Description, Size Guide, Reviews)

### Cart & Checkout
- **Mobile:** item cards stacked, sticky total + "Checkout" button; checkout as stepper (Address → Delivery → Payment → Review)
- **Desktop:** 2 columns — items (left 65%), order summary card sticky (right 35%)

### Orders / Profile
- **Mobile:** list with status chips + timeline
- **Desktop:** left profile menu, right content

### Admin Panel
- **Mobile:** drawer navigation, cards instead of tables
- **Desktop:** fixed sidebar (250px), top bar, KPI cards row (4), charts (fl_chart), data tables with search/filter/pagination

## COMPONENT LIBRARY (build first)
`AppButton (primary/secondary/outline/text)`, `AppTextField`, `ProductCard`, `CategoryChip`, `SizeChip`, `ColorSwatch`, `PriceTag (with strike-through + discount badge)`, `RatingStars`, `QuantityStepper`, `StatusChip`, `EmptyState`, `ErrorState`, `SkeletonLoader (shimmer)`, `AppBar / TopNav / BottomNav / SideNav`, `SnackBar helper`

## UX DETAILS
- Skeleton loaders (no blank screens), pull-to-refresh, empty/error states with retry
- Micro-animations 150–250 ms (Hero image transition, add-to-cart feedback, heart pop)
- Form validation inline, clear messages, keyboard type per field, autofill hints
- Size guide modal (age / height / chest chart for boys)
- Accessibility: `Semantics` labels, focus order, contrast, alt text on images
- Currency formatting (LKR / USD switchable), Tamil/Sinhala-ready text (no fixed widths)

## DELIVERABLES
1. `core/constants/app_colors.dart`, `core/theme/app_theme.dart` (light + dark), `core/utils/responsive.dart`
2. Shared widget library in `core/widgets/` with code
3. Each screen above as `modules/<feature>/views/` + `widgets/` — full Flutter code (GetX + `Obx`), mobile + desktop adaptive
4. Overflow test checklist result (widths listed above)
5. Short style guide (colors, fonts, spacing) as a markdown

Start with **item 1 + shared widgets**, then wait for "next".
