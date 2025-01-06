import 'package:dio/dio.dart';
import '../model/market_sentiment.dart';

class MarketSentimentService {
  final Dio _dio = Dio();

  Future<List<MarketNews>> fetchTopMarketSentiment() async {
    const String url =
        'https://www.alphavantage.co/query?function=NEWS_SENTIMENT&topics=blockchain,technology&apikey=TAQFTMQR8WBFW1PW';

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        List<dynamic> feed = response.data['feed'];
        final topNews = feed.take(7).map((item) => MarketNews.fromJson(item)).toList();
        return topNews;
      } else {
        throw Exception('Failed to load market sentiment data');
      }
    } catch (e) {
      throw Exception('Error fetching market sentiment data: $e');
    }
  }
}
