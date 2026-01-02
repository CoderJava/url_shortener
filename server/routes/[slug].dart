import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import '../lib/services/link_service.dart';

Future<Response> onRequest(RequestContext context, String slug) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final service = context.read<LinkService>();
  final link = await service.getLink(slug);

  if (link == null) {
    return Response(statusCode: HttpStatus.notFound, body: 'Link not found');
  }

  // HTTP 302 Redirect
  return Response(
    statusCode: HttpStatus.found, // 302
    body: null,
    headers: {
      HttpHeaders.locationHeader: link.originalUrl,
      // Optional: Cache control? For now, no-cache to track clicks accurately?
    },
  );
}
