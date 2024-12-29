import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:tuple/tuple.dart';
import '../api_service/stock_detail_service.dart';

// Provider untuk Stock Detail
final stockDetailProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, symbol) async {
  final service = StockDetailService();
  return await service.fetchStockDetail(symbol);
});

// Provider untuk Key Metrics
final stockKeyMetricsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, symbol) async {
  final service = StockDetailService();
  return await service.fetchStockKeyMetrics(symbol);
});
