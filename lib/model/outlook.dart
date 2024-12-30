class Outlook {
  final String summary;

  Outlook({required this.summary});

  factory Outlook.fromJson(Map<String, dynamic> json) {
    return Outlook(
      summary: json['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? 'No data available',
    );
  }
}