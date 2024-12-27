import 'package:dio/dio.dart';
import '../model/news.dart';

class NewsService {
  final Dio _dio = Dio();

  Future<List<News>> fetchNews() async {
    const String url =
        'https://newsapi.org/v2/everything?q=economic&apiKey=7dc9b8b4454a4dfc8462637d2b745714';

    try {
      final response = await _dio.get(url);

      if (response.data['status'] == 'ok') {
        List<dynamic> articles = response.data['articles'];
         final newsList = articles.map((article) => News.fromJson(article)).toList();
      
          // Debug log
          print('Fetched ${newsList.length} articles');
          
          return newsList;
      } else {
        throw Exception('Failed to fetch news: ${response.data['message']}');
      }
    } on DioError catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'An error occurred while fetching news.');
    }
  }

    Future<News> fetchHeadline() async {
  const String url = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=7dc9b8b4454a4dfc8462637d2b745714';
  try {
    final response = await _dio.get(url);

    if (response.data['status'] == 'ok') {
      List<dynamic> articles = response.data['articles'];
      if (articles.isNotEmpty) {
        return News.fromJson(Map<String, dynamic>.from(articles[0]));
      } else {
        throw Exception('No articles found.');
      }
    } else {
      throw Exception('Failed to fetch headline: ${response.data['message']}');
    }
  } on DioError catch (e) {
    throw Exception(
      e.response?.data['message'] ?? 'An error occurred while fetching headline.',
    );
  }
}

}
