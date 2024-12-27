import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api_service/MarketSentimentService.dart';
import '../model/market_sentiment.dart';

final marketSentimentProvider = FutureProvider<List<MarketNews>>((ref) async {
  final marketNewsService = MarketSentimentService();
  return await marketNewsService. fetchTopMarketSentiment();
});
