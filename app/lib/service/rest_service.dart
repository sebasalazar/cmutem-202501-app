import 'package:dio/dio.dart';
import 'package:hm/model/weather_data.dart';
import 'package:hm/model/weather_info.data.dart';
import 'package:logger/logger.dart';

class RestService {
  static final Dio _client = Dio();
  static final Logger _logger = Logger();

  static const String _mime = "application/json";
  static const String _baseUrl = "https://api.boostr.cl";

  static Future<WeatherData?> getWheather(String station) async {
    WeatherData? data;
    try {
      if (!_client.interceptors.any(
        (interceptor) => interceptor is LogInterceptor,
      )) {
        _client.interceptors.add(
          LogInterceptor(
            request: true,
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            responseHeader: true,
          ),
        );
      }

      final String url = "$_baseUrl/weather/$station.json";
      final Map<String, String> headers = {"accept": _mime};

      final Response<String> response = await _client.get(
        url,
        options: Options(headers: headers),
      );

      final int status = response.statusCode ?? 400;
      if (status >= 200 && status < 300) {
        final String json = response.data ?? '';
        if (json.isNotEmpty) {
          WeatherInfo info = WeatherInfo.fromRawJson(json);
          data = info.data;
        }
      } else {
        _logger.e("Error HTTP con código $status");
      }
    } catch (error) {
      _logger.e("Ocurrió un problema con la petición rest $error");
    }
    return data;
  }
}
