// import 'package:alpha_club/model/stock.dart';
import 'package:dio/dio.dart';

class StockDetailService{
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> fetchStockDetail(String symbol) async {
    const String baseUrl = 'https://financialmodelingprep.com/api/v3/profile/';
    final String apiKey = 'OJi8xFLNTS2fsHS37jbV4b0L2Q8h1NRp';

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
}
