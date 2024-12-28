import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api_service/stock_detail_service.dart';

final stockDetailProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, symbol) async {
  final service = StockDetailService();
  return await service.fetchStockDetail(symbol);
});
