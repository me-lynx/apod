import 'package:apod/apod.dart';
import 'package:apod/dio_interceptor.dart';
import 'package:dio/dio.dart';

class ApodRemoteDataSource {
  final String _baseUrl = 'https://api.nasa.gov/planetary/apod';
  final Dio _dio;

  ApodRemoteDataSource() : _dio = Dio() {
    _dio.interceptors.add(createDioInterceptor());
  }

  String formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }

    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  Future<List<Apod>> getApods(DateTime? startDate, DateTime? endDate) async {
    final formattedStartDate = formatDate(startDate);
    final formattedEndDate = formatDate(endDate);

    final url =
        '$_baseUrl?start_date=$formattedStartDate&end_date=$formattedEndDate';
    final response = await _dio.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonList = response.data;
      return jsonList.map((json) => Apod.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load APODs');
    }
  }
}
