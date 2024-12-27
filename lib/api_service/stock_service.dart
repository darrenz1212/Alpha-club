import 'package:dio/dio.dart';
import '../model/stock.dart';

class StockService {
  final Dio _dio = Dio();

  Future<List<Stock>> fetchNYSEStocks({int pageSize = 20}) async {
    const String url =
        'https://financialmodelingprep.com/api/v3/stock/list?apikey=OJi8xFLNTS2fsHS37jbV4b0L2Q8h1NRp';

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data
            .where((stock) =>
                stock['exchange'] == 'New York Stock Exchange' ||
                stock['exchange'] == 'NASDAQ Global Select')
            .take(pageSize)
            .map((json) => Stock.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load stock data');
      }
    } catch (e) {
      throw Exception('Error fetching stock data: $e');
    }
  }
}
