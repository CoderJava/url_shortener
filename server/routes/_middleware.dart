import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import '../lib/services/link_service.dart';

// Singleton instance
final _linkService = LinkService();

Handler middleware(Handler handler) {
  return (RequestContext context) async {
    // CORS Preflight
    if (context.request.method == HttpMethod.options) {
      return Response(statusCode: HttpStatus.ok, headers: _corsHeaders);
    }

    final response = await handler(context);
    return response.copyWith(
      headers: {...response.headers, ..._corsHeaders},
    );
  }.use(requestLogger()).use(provider<LinkService>((_) => _linkService));
}

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type',
};
