import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api_service/NewsService.dart';
import '../model/news.dart';


// Breaking News 
final breakingNewsProvider = FutureProvider<News>((ref) async {
  final newsService = NewsService();
  return await newsService.fetchHeadline();
});

// Regular News
final newsProvider = FutureProvider<List<News>>((ref) async {
  final newsService = NewsService();
  return await newsService.fetchNews();
});