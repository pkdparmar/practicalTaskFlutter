# Paws & Care Portal - Flutter Application

A premium, high-fidelity Flutter application built using **BLoC State Management** and clean architecture patterns. The app serves as a portal for dog supplements, grooming, and wellness items, integrated with WooCommerce APIs.

---

## 🏗️ Architecture & Stack

- **Framework**: Flutter
- **State Management**: `flutter_bloc` (Cubit architecture)
- **Networking**: `dio` (with interceptor-level exception handling)
- **Caching & Local Storage**: `shared_preferences` (for login session and saved/bookmark favorites)
- **Responsive Layout**: `flutter_screenutil_plus` (utilizing responsive size extensions like `.h`, `.w`, `.r`, `.sp`)
- **Aesthetics**: Glassmorphic overlay cards, dark/rich background gradients, custom shimmers, and micro-animations.

---

## 📱 Screens & Core Features

### 1. Splash Screen
* **Location**: `lib/ui/splash/`
* **Features**:
  * Displays a premium splash view with high-fidelity branding.
  * Checks authentication status using `PrefHelper`.
  * Automatically handles standard named routing redirects: navigates to **Dashboard** if logged in, otherwise routes to **Login**.

### 2. Login Screen
* **Location**: `lib/ui/login/`
* **Features**:
  * **Input Validation**: Uses email format regex checks and minimum-length password checks (integrated via `ValidationHelper`).
  * **Interactive Passwords**: Supports toggleable visibility (eye icon) with clean, reactive state updates.
  * **Global Loading Overlay**: Triggers a global progress indicator barrier via `AppClass().isShowLoading` during auth delays.
  * **Session Persistence**: Saves the user's active session upon successful login.

### 3. Dashboard (Storefront)
* **Location**: `lib/ui/dashboard/`
* **Features**:
  * **Horizontal Categories List**: Loads WooCommerce categories dynamically with custom circle image loaders, caching, and category scroll pagination.
  * **Dynamic Categories Header**: Displays the name of the currently selected category dynamically (e.g., "Accessories", "Wellness") as the list header.
  * **Product Grid Fetching**: Fetches products filtered by the selected category dynamically.
  * **Debounced Search**: Features a glassmorphic top search field. Changes to search text are debounced by `500ms` before triggering API calls to minimize API overhead.
  * **Product Pagination**: Implements infinite scrolling, loading more products automatically as the user scrolls to the bottom of the grid.
  * **Pull-to-Refresh**: Implements `RefreshIndicator` at the top level to cleanly reset and reload category and product states.
  * **Scroll-to-Top FAB**: Fades in a mini floating action button after the user scrolls down past `400` logical pixels, smoothly animating back to the top of the viewport on click.

### 4. Product Details Screen
* **Location**: `lib/ui/product_details/`
* **Features**:
  * **Interactive Image Gallery**: Renders a swipable image carousel with smooth dot indicator guides.
  * **Full-Screen Image Viewer**: Supports interactive zoom gestures (pinch-to-zoom) and swiping through alternate image gallery lists inside a full-screen dialog box.
  * **Pricing & Sale Badges**: Displays original prices alongside marked-down sale prices, completed with strike-through text and sale tags.
  * **Technical Specifications**: Dynamically builds attribute matrices (e.g., size, color options) and category detail tables.
  * **Add to Cart & Buy Now**: Interactive, context-aware action triggers.

### 5. Saved Items (Bookmarks) Screen
* **Location**: `lib/ui/saved_items/`
* **Features**:
  * **Cross-Screen Syncing**: Favoriting a product in the grid or details screen synchronizes instantly across all screens.
  * **Disk Caching**: Serializes favorite products to local disk cache using `SharedPreferences` to ensure they persist across app restarts.
  * **Dynamic Count badge**: Renders live counts of favorited items inside the navigation drawer menu using `SavedItemsCubit` listeners.

### 6. No Internet (Offline) Screen
* **Location**: `lib/ui/no_internet/`
* **Features**:
  * **Transparent Interceptor Routing**: The HTTP data layer transparently intercepts request failures caused by lack of network access and redirects the user to the offline screen.
  * **Interactive Testing**: Features a "Try Again" button that pings servers to verify socket connection availability.
  * **Request Retrying**: Automatically resolves and returns back to the caller screen to retry the interrupted API call once connection is restored.

---

## 🛠️ Specialized Technical Details

### Reusable Shimmer Skeletons
* All shimmers are unified in `lib/ui/widgets/shimmer_layouts.dart`, exposing:
  - `CategoryListShimmer`
  - `ProductGridShimmer`
  - `ProductDetailsShimmer`
  - `DashboardShimmer` (which keeps the search textfield interactive during initial loading)

### Cached Net Images
* `CommonCacheImage` is integrated across circular categories, product cards, and carousels, providing automated disk caching, error fallback handlers, and seamless custom loading shimmers.

### File Structure (BLoC/Cubit Isolation)
To adhere to standard BLoC patterns, state declarations have been fully separated from Cubits into isolated files inside each module folder:
```
lib/ui/module_name/
├── module_name_cubit.dart    # Cubit state-dispatch logic
├── module_name_state.dart    # Immutable states definition
└── module_name_view.dart     # UI and widget layout definitions
```
