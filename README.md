# Beespoke â€” Product Feed App

[![CI](https://github.com/MahalaxmiDhanai/Beespoke.ai/actions/workflows/ci.yml/badge.svg)](https://github.com/MahalaxmiDhanai/Beespoke.ai/actions/workflows/ci.yml)

A production-grade Flutter app demonstrating **Clean Architecture**, **SOLID principles**, and **Effective Dart** idioms.  
Fetches products from [FakeStoreAPI](https://fakestoreapi.com/), supports Like/Dislike, in-app WebView, and persistent browsing history.

---

## âœ¨ Features

| Feature | Details |
|---|---|
| ðŸ“¦ Product Feed | Grid of products from FakeStoreAPI with image, title, price |
| â¤ï¸ Like / Dislike | Animated heart button with Hive persistence (survives restart) |
| ðŸ” Search & Filter | Real-time text search + category filter chips |
| ðŸŒ In-App Browser | WebView with live progress bar + navigation controls |
| ðŸ“œ Browsing History | Sorted list of visited pages with relative timestamps |
| ðŸ’€ Skeleton Loaders | Animated shimmer placeholders while loading |
| âš ï¸ Error Handling | Friendly error screens with retry mechanism |
| ðŸŒ™ Dark Theme | Premium dark Material 3 design |

---

## ðŸ› Architecture

```
lib/
â”œâ”€ core/                        # App-level utilities, errors, network
â”‚  â”œâ”€ constants/                # API URLs, Hive box names, timeouts
â”‚  â”œâ”€ errors/                   # Failure hierarchy (NetworkFailure, CacheFailureâ€¦)
â”‚  â”œâ”€ network/                  # Dio client factory with interceptors
â”‚  â””â”€ utils/                    # Either extensions
â”œâ”€ shared/
â”‚  â”œâ”€ theme/                    # AppColors, AppTheme (Material 3 dark)
â”‚  â””â”€ widgets/                  # SkeletonCard, ErrorView (reusable)
â””â”€ features/
   â””â”€ products/
      â”œâ”€ presentation/          # Pages, Widgets, Riverpod providers
      â”œâ”€ domain/                # Models, UseCases, Repository interfaces
      â””â”€ data/                  # DTOs, Mappers, Datasources, Repository impls
```

### Clean Architecture layers

```
Presentation â”€â”€â–¶ Domain â—€â”€â”€ Data
(Riverpod)      (UseCases)   (Dio / Hive)
```

- **Presentation** calls use-cases; zero network or DB code in widgets.  
- **Domain** is pure Dart â€” no Flutter, no Dio, no Hive.  
- **Data** implements repository interfaces; fully swappable (e.g., swap Dio for a mock).

---

## ðŸ“¦ Libraries & Rationale

| Library | Why |
|---|---|
| `flutter_riverpod` | Compile-safe, testable DI & state. `AsyncNotifier` replaces BLoC boilerplate. |
| `dio` | Powerful HTTP with interceptors, timeout handling, and easy mocking. |
| `freezed` + `json_serializable` | Immutable value objects with `copyWith` & JSON parsing â€” zero boilerplate. |
| `hive_flutter` | Fast embedded key-value store; no native code for simple like/history persistence. |
| `dartz` | `Either<Failure, T>` makes error paths explicit and untuneable at the call site. |
| `cached_network_image` | Disk + memory caching for product images out of the box. |
| `webview_flutter` | Official Flutter WebView â€” best maintained in-app browser option. |
| `mocktail` | Type-safe mocking without codegen; cleaner than Mockito for Dart null-safety. |

---

## ðŸ”¬ analysis_options.yaml â€” Custom Rules

Rule | Reason
---|---
`avoid_print` | Forces structured logging instead of stdout noise.
`avoid_dynamic_calls` | Catches missing type annotations early.
`always_declare_return_types` | Improves readability and catches silent voids.
`prefer_const_constructors` | Enables Flutter to skip rebuilds for const widgets.
`require_trailing_commas` | Consistent `dart format` diffs in PRs.
`sort_constructors_first` | Predictable class structure to aid code review.
`strict-casts / strict-inference` | Surfaced hidden dynamic types during analysis.

---

## ðŸš€ How to Run

### Prerequisites
- Flutter 3.x (tested on 3.27)  
- Dart 3.6+  
- Android emulator or physical device

### Steps

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate freezed, json_serializable, and hive adapters
dart run build_runner build --delete-conflicting-outputs

# 3. Run the app
flutter run
```

### Build debug APK

```bash
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk
```

---

## ðŸ§ª Testing

```bash
# All tests
flutter test

# With coverage
flutter test --coverage

# Unit tests only
flutter test test/unit/

# Widget tests only
flutter test test/widget/

# Integration test (requires device/emulator)
flutter test integration_test/app_test.dart
```

### Test matrix

| Layer | File | What it tests |
|---|---|---|
| Data | `product_mapper_test.dart` | DTO â†’ domain mapping, isLiked stamping |
| Data | `product_repository_test.dart` | Remote + local merge, failure propagation |
| Domain | `get_products_usecase_test.dart` | Use case success and failure paths |
| Domain | `like_product_usecase_test.dart` | Like/dislike delegation and failure handling |
| Widget | `like_button_test.dart` | Icon state, tap animation, callback |
| Widget | `product_feed_page_test.dart` | Skeleton, data grid, error/retry, search |
| Integration | `app_test.dart` | Full app boot â†’ feed â†’ history navigation |

---

## ðŸ”„ CI/CD

The GitHub Actions pipeline (`.github/workflows/ci.yml`) runs on every push to `main`:

1. `flutter analyze --fatal-infos`  
2. `flutter test --coverage`  
3. `flutter build apk --debug`

APK is uploaded as a workflow artifact after each successful build.

---

## ðŸ”® What I'd Improve Next

- **Offline caching**: cache API responses to a Hive box for offline-first experience.  
- **Pagination**: FakeStoreAPI supports `limit` & `sort` query params.  
- **Liked products tab**: dedicated page filtering to only `isLiked = true`.  
- **Dependency inversion for WebView**: abstract the WebView behind an interface to allow unit-testing navigation.  
- **Error monitoring**: integrate Sentry for production crashes.  
- **Flavors**: add `dev` / `prod` build flavors with different API base URLs.
