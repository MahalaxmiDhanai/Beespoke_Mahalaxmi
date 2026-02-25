<div align="center">
  <img src="assets/images/logo.png" alt="Beespoke Logo" width="120" height="auto" />
  <h1>Beespoke — Flutter Product Feed</h1>
  <p><em>A production-grade Flutter application built with Clean Architecture & Riverpod.</em></p>

[![CI](https://github.com/MahalaxmiDhanai/Beespoke_Mahalaxmi/actions/workflows/ci.yml/badge.svg)](https://github.com/MahalaxmiDhanai/Beespoke_Mahalaxmi/actions/workflows/ci.yml)
[![Flutter](https://img.shields.io/badge/Flutter-3.27+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.6+-blue.svg)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean-success.svg)](#architecture)

</div>

---

## 📖 Overview

A fully functional product feed mobile application built for the **Beespoke AI Round 2 Assignment**. The app fetches and displays real products from the [FakeStoreAPI](https://fakestoreapi.com/), allowing users to browse, search, filter, and interact with products.

It is built with a focus on **Clean Architecture**, **SOLID principles**, and **Test-Driven Development (TDD)** ensuring scalability, maintainability, and reliability.

---

## ✨ Key Features

- **🛍️ Product Feed** — A responsive grid displaying products with images, titles, prices, and ratings.
- **❤️ Like / Dislike System** — Animated interactive buttons. Preferences are saved locally and persist across app restarts.
- **🔍 Search & Filter** — Instant real-time text search and category-based filtering (e.g., *electronics, jewellery, men's clothing*).
- **🌐 In-App Browser** — Tapping a product seamlessly opens the Google Shopping page for that specific item using an in-app WebView.
- **🕰️ Browsing History** — Tracks all visited products. A dedicated history page displays previous visits with relative timestamps.
- **⏳ Elegant Loading States** — Shimmer skeleton loaders provide immediate feedback while products are being fetched.
- **🛡️ Robust Error Handling** — Catch-all error screens with 'Retry' functionality for network and server anomalies.
- **🌙 Modern Design** — Beautiful, premium Material 3 Dark Theme implementation.

---

## 🏗️ Architecture Stack

This project strictly adheres to **Clean Architecture** principles, dividing the application into three decoupled layers:

### 1. Presentation Layer (UI & State)
- **Widgets & Pages:** Flutter UI components built with Material 3.
- **State Management:** Powered by `flutter_riverpod` using `AsyncNotifier`.
  - *Why Riverpod?* Compile-safe dependency injection, effortless `AsyncValue` handling (loading/data/error states), and superior testability.

### 2. Domain Layer (Business Logic)
- **Entities & Models:** Pure Dart representations of business objects.
- **Use Cases:** Encapsulate specific business rules (e.g., `GetProductsUseCase`, `LikeProductUseCase`).
- **Repository Interfaces:** Abstract contracts for data operations.
- *Zero dependencies on Flutter, Dio, or Hive. Fully agnostic.*

### 3. Data Layer (External Services & Persistence)
- **Remote Data Source:** API communication using `dio` with robust interceptors and timeout management.
- **Local Data Source:** Blazing-fast local persistence using `hive_flutter`.
  - *Likes:* Stored as a `Set` of IDs in `likes_box`.
  - *History:* Stored as `Map` entries in `history_box`.
- **Mappers & DTOs:** Translation between raw API JSON, local storage formats, and Domain Entities.

<details>
<summary><b>📂 View Directory Structure</b></summary>

```text
lib/
├── core/                      # Shared utilities, constants, and network configs
│   ├── constants/             
│   ├── errors/                
│   └── network/               
├── shared/                    # Reusable UI components and theme
│   ├── theme/                 
│   └── widgets/               
└── features/
    └── products/              # The main feature module
        ├── presentation/      # UI, Providers
        ├── domain/            # Entities, Use Cases, Interfaces
        └── data/              # DTOs, Mappers, Repositories, DataSources
```
</details>

---

## 🛠️ Technical Decisions & Libraries

| Dependency | Purpose | Implementation Detail |
|:---|:---|:---|
| **[Riverpod](https://pub.dev/packages/flutter_riverpod)** | State Management | `^2.6.1` — Safe DI and robust Async/Await state modeling. |
| **[Dio](https://pub.dev/packages/dio)** | HTTP Networking | `^5.4.0` — Handles FakeStoreAPI requests with built-in interceptors. |
| **[Dartz](https://pub.dev/packages/dartz)** | Functional Error Handling | `^0.10.1` — Uses `Either<Failure, Type>` to force explicit error checking. |
| **[Hive](https://pub.dev/packages/hive_flutter)** | Local Storage | `^1.1.0` — Lightweight NoSQL persistence for Likes and History. |
| **[Webview Flutter](https://pub.dev/packages/webview_flutter)** | In-App Browser | `^4.7.0` — Renders Google Shopping search results internally. |
| **[Freezed](https://pub.dev/packages/freezed)** | Data Classes | `^2.4.1` — Generates immutable classes and unions. |

> **Note on Error Handling (`dartz`)**: Every repository method explicitly returns an `Either<Failure, T>`. This functional approach ensures that developers *must* handle both success (`Right`) and failure (`Left`) scenarios, eliminating silent runtime exceptions.

---

## 🚀 Getting Started

Follow these steps to run the project locally.

### Prerequisites
- **Flutter SDK**: `3.27.0` or higher
- **Dart SDK**: `3.6.0` or higher
- An active iOS Simulator, Android Emulator, or connected physical device.

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/MahalaxmiDhanai/Beespoke_Mahalaxmi.git
   cd Beespoke_Mahalaxmi
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate required code** (for Freezed and JSON Serializable)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Building for Release

To build an optimized APK for Android:
```bash
flutter build apk --release
```
*The output will be located at: `build/app/outputs/flutter-apk/app-release.apk`*

---

## 🧪 Testing Strategy

The project includes comprehensive test coverage across all architectural layers.

```bash
# Run all tests
flutter test

# Run tests with coverage report
flutter test --coverage
```

### Coverage Breakdown

- **Data Layer:** `product_mapper_test.dart`, `product_repository_test.dart` *(Validates DTO mapping, remote/local merging, and failure propagation)*
- **Domain Layer:** `get_products_usecase_test.dart`, `like_product_usecase_test.dart` *(Validates pure business logic and delegation)*
- **Presentation (Widget):** `like_button_test.dart`, `product_feed_page_test.dart` *(Validates UI states, skeleton loaders, and interactions)*
- **Integration:** `app_test.dart` *(E2E test verifying app boot, feed loading, and history navigation)*

---

## 🔄 CI/CD Pipeline

The project utilizes GitHub Actions (`.github/workflows/ci.yml`) to ensure code quality on every push and pull request. The pipeline executes:

1. **Linting:** `flutter analyze` (Zero warnings enforced)
2. **Testing:** `flutter test --coverage` (All unit and widget tests must pass)
3. **Building:** `flutter build apk --debug` (Verifies the application compiles successfully)

---

## 🛣️ Roadmap & Future Improvements

- [ ] **Offline-First Support:** Cache API JSON responses in Hive to allow browsing the catalog without an internet connection.
- [ ] **Pagination:** Implement lazy loading utilizing FakeStoreAPI limit/offset parameters for infinite scrolling.
- [ ] **Favorites Tab:** Create a dedicated screen aggregating only the products the user has liked.
- [ ] **Enhanced Build Flavors:** Establish `dev`, `staging`, and `production` environments with distinct configurations.

---

## 📬 Contact & Submission

This project was developed and submitted for the **Beespoke AI — Flutter Developer Role (Round 2)**.

For any inquiries or feedback, please contact:
📧 [viswas@beespoke.ai](mailto:viswas@beespoke.ai)

---
<div align="center">
  <i>Built with ❤️ using Flutter</i>
</div>
