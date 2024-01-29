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

  factory Apod.fromJson(Map<String, dynamic> json) {
    return Apod(
      title: json['title'],
      explanation: json['explanation'],
      url: json['url'],
      date: json['date'],
    );
  }
}
