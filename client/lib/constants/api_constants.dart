class ApiConstants {
  // Use localhost:8080 for web/macOS.
  // For Android Emulator use 10.0.2.2:8080 (handled dynamically if needed, but for now simple)
  // Since we target web mainly based on spec description "Flutter Web (Dashboard)", localhost is fine.
  // static const String baseUrl = 'http://localhost:8080';
  static const String baseUrl =
      'https://dart-server-url-shortener-9rbdf2r-coderjava.globeapp.dev';
  static const String apiV1Links = '$baseUrl/api/v1/links';
}
