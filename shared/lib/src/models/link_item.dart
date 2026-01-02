class LinkItem {
  final String id; // UUID
  final String originalUrl; // URL asli user
  final String slug; // Kode unik (misal: "Xy7z1A")
  final int clickCount; // Statistik klik
  final DateTime createdAt; // Tanggal pembuatan

  LinkItem({
    required this.id,
    required this.originalUrl,
    required this.slug,
    this.clickCount = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originalUrl': originalUrl,
      'slug': slug,
      'clickCount': clickCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LinkItem.fromJson(Map<String, dynamic> json) {
    return LinkItem(
      id: json['id'] as String,
      originalUrl: json['originalUrl'] as String,
      slug: json['slug'] as String,
      clickCount: json['clickCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
