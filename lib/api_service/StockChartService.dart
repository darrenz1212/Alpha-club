import 'package:dio/dio.dart';
import '../model/stock_chart.dart';
// import 'dart:developer';


class StockChartService {
  final Dio _dio = Dio();

  Future<List<StockChartData>> fetchHistoricalData(
      String symbol, String timeframe) async {
    final String url =
        'https://financialmodelingprep.com/api/v3/historical-chart/$timeframe/$symbol?from=2023-08-10&to=2023-09-10&apikey=OJi8xFLNTS2fsHS37jbV4b0L2Q8h1NRp';

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data
            .take(50)
            .map((json) => StockChartData.fromJson(json))
            .toList()
            .reversed 
            .toList();
      } else {
        throw Exception('Failed to load historical data');
      }
    } catch (e) {
      throw Exception('Error fetching historical data: $e');
    }
  }
}
