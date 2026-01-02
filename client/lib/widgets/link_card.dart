import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared/shared.dart';
import '../constants/api_constants.dart';

class LinkCard extends StatelessWidget {
  final LinkItem link;
  final VoidCallback? onTap;

  const LinkCard({super.key, required this.link, this.onTap});

  @override
  Widget build(BuildContext context) {
    final shortUrl = '${ApiConstants.baseUrl}/${link.slug}';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        title: Text(
          shortUrl,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              link.originalUrl,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${link.clickCount} clicks • ${link.createdAt.toLocal().toString().split('.')[0]}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: shortUrl));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Copied to clipboard!')),
            );
          },
        ),
      ),
    );
  }
}
