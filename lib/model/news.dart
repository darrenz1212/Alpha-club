class News {
  final String? author;
  final String title;
  final String? description;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;
  final String? url;

  News({
    this.author,
    required this.title,
    this.description,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.url,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      author: json['author'],
      title: json['title'] ?? 'No Title',
      description: json['description'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : null,
      content: json['content'],
      url: json['url'],
    );
  }
}
