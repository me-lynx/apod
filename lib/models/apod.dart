class Apod {
  final String title;
  final String explanation;
  final String url;
  final String date;
  final String? path;

  Apod(
      {required this.title,
      required this.explanation,
      required this.url,
      required this.date,
      this.path});

  factory Apod.fromJson(Map<String, dynamic> json) {
    return Apod(
      title: json['title'],
      explanation: json['explanation'],
      url: json['url'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'explanation': explanation,
      'url': url,
      'date': date,
      'path': path,
    };
  }
}
