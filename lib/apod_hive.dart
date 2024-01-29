import 'package:hive/hive.dart';
part 'apod_hive.g.dart';

@HiveType(typeId: 0)
class ApodHive {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final String explanation;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String url;

  ApodHive({
    required this.date,
    required this.explanation,
    required this.title,
    required this.url,
  });
}
