import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:shared/shared.dart';

import '../../../../lib/services/link_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final service = context.read<LinkService>();

  if (context.request.method == HttpMethod.get) {
    return _getLinks(context, service);
  } else if (context.request.method == HttpMethod.post) {
    return _createLink(context, service);
  }

  return Response(statusCode: HttpStatus.methodNotAllowed);
}

Future<Response> _getLinks(RequestContext context, LinkService service) async {
  final links = await service.getAllLinks();
  return Response.json(body: links.map((e) => e.toJson()).toList());
}

Future<Response> _createLink(
    RequestContext context, LinkService service) async {
  final body = await context.request.json();
  final url = body['url'] as String?;

  if (url == null || url.isEmpty) {
    return Response(statusCode: HttpStatus.badRequest, body: 'URL is required');
  }

  if (!Validators.isValidUrl(url)) {
    return Response(
        statusCode: HttpStatus.badRequest, body: 'Invalid URL format');
  }

  final link = await service.createLink(url);
  return Response.json(body: link.toJson());
}
