class Headline {
  final String? author;
  final String title;
  final String? description;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;

  Headline({
    this.author,
    required this.title,
    this.description,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory Headline.fromJson(Map<String, dynamic> json) {
    return Headline(
      author: json['author'], 
      title: json['title'] ?? 'No Title',
      description: json['description'], 
      urlToImage: json['urlToImage'], 
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt']) 
          : null,
      content: json['content'], 
    );
  }
}
