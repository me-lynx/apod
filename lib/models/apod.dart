import 'package:apod/apod_hive.dart';

class Apod {
  final String title;
  final String explanation;
  final String url;
  final String date;

  Apod(
      {required this.title,
      required this.explanation,
      required this.url,
      required this.date});

  ApodHive toApodHive() {
    return ApodHive(
      date: date,
      explanation: explanation,
      title: title,
      url: url,
    );
  }

  factory Apod.fromJson(Map<String, dynamic> json) {
    return Apod(
      title: json['title'],
      explanation: json['explanation'],
      url: json['url'],
      date: json['date'],
    );
  }
}

Apod apodHiveToApod(ApodHive apodHive) {
  return Apod(
    date: apodHive.date,
    explanation: apodHive.explanation,
    title: apodHive.title,
    url: 'file://${apodHive.url}',
  );
}
