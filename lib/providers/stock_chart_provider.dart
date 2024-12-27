import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api_service/StockChartService.dart';
import '../model/stock_chart.dart';

final stockChartProvider = StateNotifierProvider<StockChartNotifier, List<StockChartData>>(
  (ref) => StockChartNotifier(),
);

class StockChartNotifier extends StateNotifier<List<StockChartData>> {
  final StockChartService _service = StockChartService();

  StockChartNotifier() : super([]);

  Future<void> fetchChartData(String symbol, String timeframe) async {
    try {
      final data = await _service.fetchHistoricalData(symbol, timeframe);
      state = data;
    } catch (e) {
      throw Exception('Failed to fetch chart data: $e');
    }
  }
}
