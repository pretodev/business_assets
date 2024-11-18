import 'package:dio/dio.dart';

class TractanHttpClient {
  final String baseUrl;
  final Dio _dio;

  TractanHttpClient({
    this.baseUrl = 'https://fake-api.tractian.com', //TODO: move to env.json
  }) : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<dynamic> get(String path) async {
    final response = await _dio.get(path);
    return response.data;
  }
}
