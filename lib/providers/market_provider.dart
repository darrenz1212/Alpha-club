import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api_service/MarketService.dart';
import '../model/market.dart';

final marketProvider = FutureProvider<List<Market>>((ref) async {
  final marketService = MarketService();
  return await marketService.fetchMagnificent7AndBTC();
});
