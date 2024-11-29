import 'package:dio/dio.dart';

class NewsService {
  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> fetchNews() async {
    const String url =
        'https://newsapi.org/v2/everything?q=economic&apiKey=7dc9b8b4454a4dfc8462637d2b745714';

    try {
      // Fetch data from API
      final response = await _dio.get(url);

      // Check if the response status is "ok"
      if (response.data['status'] == 'ok') {
        // Extract articles from the response
        List<dynamic> articles = response.data['articles'];

        // Return a list of articles
        return articles.map((article) => Map<String, dynamic>.from(article)).toList();
      } else {
        throw Exception('Failed to fetch news: ${response.data['message']}');
      }
    } on DioError catch (e) {
      print('DioError occurred: ${e.message}');
      throw Exception(
          e.response?.data['message'] ?? 'An error occurred while fetching news.');
    }
  }

    Future<Map<String, dynamic>> fetchHeadline() async {
    const String url = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=7dc9b8b4454a4dfc8462637d2b745714';
    try {
      final response = await _dio.get(url);

      if (response.data['status'] == 'ok') {
        List<dynamic> articles = response.data['articles'];
        if (articles.isNotEmpty) {
          return Map<String, dynamic>.from(articles[0]);
        } else {
          throw Exception('No articles found.');
        }
      } else {
        throw Exception('Failed to fetch headline: ${response.data['message']}');
      }
    } on DioError catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'An error occurred while fetching news.',
      );
    }
  }
}
