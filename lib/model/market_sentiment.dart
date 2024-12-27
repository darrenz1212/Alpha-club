class MarketNews {
  final String title;
  final String url;
  final String bannerImage;
  final String timePublished;
  final List<String> authors;
  final String summary;
  final String overallSentimentLabel;
  final List<Map<String, dynamic>> tickerSentiments;

  MarketNews({
    required this.title,
    required this.url,
    required this.bannerImage,
    required this.timePublished,
    required this.authors,
    required this.summary,
    required this.overallSentimentLabel,
    required this.tickerSentiments,
  });

  factory MarketNews.fromJson(Map<String, dynamic> json) {
    return MarketNews(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      bannerImage: json['banner_image'] ?? '',
      timePublished: json['time_published'] ?? '',
      authors: List<String>.from(json['authors'] ?? []),
      summary: json['summary'] ?? '',
      overallSentimentLabel: json['overall_sentiment_label'] ?? 'Neutral',
      tickerSentiments: List<Map<String, dynamic>>.from(
        json['ticker_sentiment']?.map((ticker) => {
          'ticker': ticker['ticker'] ?? '',
          'label': ticker['ticker_sentiment_label'] ?? 'Neutral',
        }) ?? [],
      ),
    );
  }
}
