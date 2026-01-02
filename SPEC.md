# Project Specification: DartLink (URL Shortener & QR Generator)

## 1. Ringkasan Projek
Aplikasi Fullstack Dart sederhana yang berfungsi untuk memendekkan URL panjang menjadi tautan singkat, sekaligus menghasilkan QR Code untuk tautan tersebut. Projek ini memaksimalkan penggunaan bahasa Dart di sisi Server (Backend), Web (Admin Dashboard), dan Mobile (User App).

## 2. Tech Stack

### Backend (Server)
* **Framework:** [Dart Frog](https://dartfrog.vg/) (Minimalist backend framework for Dart).
* **Environment:** Dart SDK (Latest Stable).
* **Database:** * *Opsi Awal:* In-memory Map (untuk prototyping cepat).
    * *Opsi Lanjut:* SQLite (menggunakan package `sqlite3`) atau Hive.
* **Hosting Target:** Docker container / Dart Frog cloud (opsional).

### Frontend (Client)
* **Framework:** Flutter (Web & Mobile).
* **State Management:** Bloc.
* **HTTP Client:** `dio` atau `http`.
* **UI Library:** Google Fonts, `qr_flutter` (untuk render QR Code).

### Shared Code (Monorepo)
* **Models:** Class data (`LinkModel`) yang digunakan bersama oleh Backend dan Frontend untuk memastikan tipe data konsisten.

---

## 3. Fitur Utama

### A. Backend (API & Logic)
1.  **Shorten Endpoint:** Menerima URL panjang, membuat *slug* unik (6 karakter alfanumerik), menyimpan data, dan mengembalikan URL pendek.
2.  **Redirect Logic:** Menangani request ke `BASE_URL/[slug]`. Jika ditemukan, redirect (HTTP 302) ke URL asli. Jika tidak, tampilkan 404.
3.  **Analytics Tracker:** Menambah counter `click_count` setiap kali short link diakses.
4.  **List Endpoint:** Mengambil semua daftar link yang pernah dibuat (untuk Admin Dashboard).

### B. Flutter Web (Dashboard)
1.  **Input Form:** Text field untuk menempel (paste) URL panjang.
2.  **Result Card:** Menampilkan URL pendek yang berhasil dibuat + tombol "Copy to Clipboard".
3.  **QR Display:** Menampilkan QR Code dari URL pendek yang baru dibuat.
4.  **History Table:** Tabel daftar link yang pernah dibuat beserta jumlah klik-nya (*analytics* sederhana).

### C. Flutter Mobile (Android/iOS)
1.  **Simple UI:** Fokus pada kecepatan. Buka aplikasi -> Paste Link -> Dapat Short URL & QR.
2.  **Share Intent (Advanced):** Mampu menerima teks/url dari menu "Share" aplikasi lain (misal: dari Browser Chrome di HP -> Share ke DartLink).
3.  **Save QR:** Fitur untuk menyimpan gambar QR Code ke galeri HP.

---

## 4. Struktur Data (Shared Model)

Class ini harus ada di folder `packages/shared` agar bisa diimport oleh Client dan Server.

```dart
class LinkItem {
  final String id;           // UUID
  final String originalUrl;  // URL asli user
  final String slug;         // Kode unik (misal: "Xy7z1A")
  final int clickCount;      // Statistik klik
  final DateTime createdAt;  // Tanggal pembuatan

  LinkItem({
    required this.id,
    required this.originalUrl,
    required this.slug,
    this.clickCount = 0,
    required this.createdAt,
  });

  // Tambahkan method: toJson() dan fromJson()
}
```

---

## 5. Rencana API Endpoint (Dart Frog)

| Method | Endpoint | Deskripsi | Request Body | Response |
| :--- | :--- | :--- | :--- | :--- |
| **POST** | `/api/v1/links` | Membuat short link baru | `{"url": "https://..."}` | JSON `LinkItem` |
| **GET** | `/api/v1/links` | Mengambil history link | - | List JSON `LinkItem` |
| **GET** | `/[slug]` | Redirect ke URL asli | - | HTTP 302 Redirect |

---

## 6. Tahapan Pengerjaan (Step-by-Step Instructions)

### Fase 1: Setup Monorepo & Shared
1. Buat folder root projek.
2. Setup workspace Melos atau struktur folder manual:
    * `/server` (Dart Frog project)
    * `/client` (Flutter project)
    * `/shared` (Dart library package)

### Fase 2: Backend Development
1. Buat `LinkModel` di `/shared`.
2. Implementasi In-memory storage di Dart Frog.
3. Buat route POST `/api/v1/links` untuk generate slug.
4. Buat route dynamic `/[slug]` untuk logic redirect.
5. Tes menggunakan Postman/Curl.

### Fase 3: Frontend Development
1. Setup Flutter project (tambahkan support Web, Android, & iOS).
2. Buat service class untuk memanggil API Dart Frog.
3. Buat UI Input dan Result (tampilkan URL pendek + QR Code menggunakan `qr_flutter`).
4. Implementasi fitur "Copy to Clipboard".

### Fase 4: Integrasi & Polishing
1. Sambungkan data Analycits (jumlah klik) ke UI Frontend.
2. Pastikan Mobile app responsif.
3. Implementasi LocalStorage di Flutter untuk menyimpan history link secara lokal di HP juga.

### Fase 5: Struktur Direktori
```
dart_link_project/
│
├── SPEC.md                  # File spesifikasi projek yang tadi kita buat
├── README.md                # Dokumentasi umum
├── .gitignore               # Git ignore global
│
├── shared/                  # [PACKAGE] Library Dart murni (Shared Code)
│   ├── lib/
│   │   ├── src/
│   │   │   ├── models/
│   │   │   │   └── link_item.dart    # Model data yang dipakai Client & Server
│   │   │   └── utils/
│   │   │       └── validators.dart   # Regex validasi URL (biar konsisten)
│   │   └── shared.dart      # Export file untuk memudahkan import
│   └── pubspec.yaml
│
├── server/                  # [APP] Backend menggunakan Dart Frog
│   ├── routes/
│   │   ├── index.dart       # Health check / Welcome page
│   │   ├── [slug].dart      # Dynamic route untuk Redirect (contoh: /Xy7z1A)
│   │   └── api/
│   │       └── v1/
│   │           └── links/
│   │               ├── index.dart    # GET & POST handler
│   │               └── [id].dart     # (Opsional) Update/Delete per ID
│   ├── services/            # Logika bisnis & Database connection
│   │   └── link_service.dart
│   ├── pubspec.yaml
│   └── analysis_options.yaml
│
└── client/                  # [APP] Frontend menggunakan Flutter (Web & Mobile)
    ├── assets/              # Gambar/Icon
    ├── lib/
    │   ├── main.dart
    │   ├── constants/       # API URL constants
    │   ├── services/
    │   │   └── api_service.dart  # Memanggil endpoint server
    │   ├── screens/
    │   │   ├── home_screen.dart  # Form input & result
    │   │   └── history_screen.dart # List history
    │   └── widgets/
    │       ├── qr_display.dart   # Widget untuk render QR
    │       └── link_card.dart
    ├── pubspec.yaml
    └── analysis_options.yaml
```

### Fase 6: Kunci Penting: Konfigurasi `pubspec.yaml` (The Glue)
1. Di file `server/pubspec.yaml`:
```
dependencies:
  dart_frog: ^1.0.0
  # Dependency ke folder shared
  shared:
    path: ../shared
```
2. Di file `client/pubspec.yaml`:
```
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.0.0
  qr_flutter: ^4.1.0
  # Dependency ke folder shared
  shared:
    path: ../shared
```