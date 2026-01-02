import 'dart:math';

import 'package:shared/shared.dart';
import 'package:uuid/uuid.dart';

class LinkService {
  // In-memory storage
  final Map<String, LinkItem> _store = {};

  // Helper for random string generation
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
  final Random _rnd = Random();

  String _generateSlug(int length) {
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
    ));
  }

  Future<LinkItem> createLink(String originalUrl) async {
    // Check if URL already exists? (Optional optimization)
    // For now, we always create a new one as per spec simple logic,
    // or we could check valid URL

    // Generate unique slug
    String slug;
    do {
      slug = _generateSlug(6);
    } while (_store.containsKey(slug));

    final id = const Uuid().v4();
    final now = DateTime.now();

    final link = LinkItem(
      id: id,
      originalUrl: originalUrl,
      slug: slug,
      createdAt: now,
      clickCount: 0,
    );

    _store[slug] = link;
    return link;
  }

  Future<LinkItem?> getLink(String slug) async {
    final link = _store[slug];
    if (link == null) return null;

    // Increment click count (simple in-memory mutation)
    final updatedLink = LinkItem(
      id: link.id,
      originalUrl: link.originalUrl,
      slug: link.slug,
      clickCount: link.clickCount + 1,
      createdAt: link.createdAt,
    );

    _store[slug] = updatedLink;
    return updatedLink;
  }

  Future<List<LinkItem>> getAllLinks() async {
    // Sort by newest first
    final list = _store.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }
}
