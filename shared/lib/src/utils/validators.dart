class Validators {
  static bool isValidUrl(String url) {
    // Simple validator, can be improved
    final uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  static bool isValidSlug(String slug) {
    // Only alphanumeric, e.g., 6 chars
    final regex = RegExp(r'^[a-zA-Z0-9]+$');
    return regex.hasMatch(slug);
  }
}
