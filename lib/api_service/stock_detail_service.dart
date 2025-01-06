import 'package:dio/dio.dart';

class StockDetailService {
  final Dio _dio = Dio();

  // Fetch Stock Detail
  Future<Map<String, dynamic>> fetchStockDetail(String symbol) async {
    const String baseUrl = 'https://financialmodelingprep.com/api/v3/profile/';
    final String apiKey = 'qm7dfWSql5Uf8VkOKTkCz8acB5xljAbM';

    try {
      final response = await _dio.get('$baseUrl$symbol?apikey=$apiKey');
      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return response.data[0];
      } else {
        throw Exception('Failed to fetch stock detail');
      }
    } catch (e) {
      throw Exception('Error fetching stock detail: $e');
    }
  }

  // Fetch Key Metrics
  Future<Map<String, dynamic>> fetchStockKeyMetrics(String symbol) async {
    const String baseUrl = 'https://financialmodelingprep.com/api/v3/key-metrics/';
    final String apiKey = 'qm7dfWSql5Uf8VkOKTkCz8acB5xljAbM';

    try {
      final response = await _dio.get('$baseUrl$symbol?period=annual&apikey=$apiKey');
      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return response.data[0];
      } else {
        throw Exception('Failed to fetch stock key metrics');
      }
    } catch (e) {
      throw Exception('Error fetching stock key metrics: $e');
    }
  }
}
