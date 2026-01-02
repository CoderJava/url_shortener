import 'package:dio/dio.dart';
import 'package:shared/shared.dart';
import '../constants/api_constants.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<LinkItem> shortenUrl(String url) async {
    try {
      final response = await _dio.post(
        ApiConstants.apiV1Links,
        data: {'url': url},
      );
      return LinkItem.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to shorten URL: $e');
    }
  }

  Future<List<LinkItem>> getHistory() async {
    try {
      final response = await _dio.get(ApiConstants.apiV1Links);
      final List<dynamic> data = response.data;
      return data.map((e) => LinkItem.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to get history: $e');
    }
  }
}
