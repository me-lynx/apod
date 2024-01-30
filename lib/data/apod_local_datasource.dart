import 'package:apod/models/apod.dart';

abstract class ApodLocalDataSource {
  Future<Apod> getApod(String date);
  Future<void> saveApod(Apod apod);
}
