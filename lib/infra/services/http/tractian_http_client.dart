import 'package:dio/dio.dart';

import '../../../config/tractian/tractian_environment.dart';
import 'tractian_http_response.dart';

class TractanHttpClient {
  final Dio _dio;

  TractanHttpClient({
    required TractianEnvironment environment,
  }) : _dio = Dio(BaseOptions(baseUrl: environment.apiUrl));

  Future<TractianHttpResponse> get(String path) async {
    final response = await _dio.get(path);
    return TractianHttpResponse(
      statusCode: response.statusCode ?? 200,
      data: response.data,
    );
  }
}
