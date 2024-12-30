import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api_service/stock_service.dart';
import '../model/stock.dart';

final stockProvider =
    StateNotifierProvider<StockNotifier, List<Stock>>((ref) => StockNotifier());

class StockNotifier extends StateNotifier<List<Stock>> {
  final StockService _stockService = StockService();
  bool _isLoading = false;
  bool _isInitialized = false;
  int _currentBatch = 0;
  static const int _batchSize = 20;

  List<Stock> _allStocks = []; 

  StockNotifier() : super([]);

  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  // Fetch semua data saham saat pertama kali aplikasi dimulai
  Future<void> fetchAllStocks() async {
    if (_isLoading || _isInitialized) return;

    _isLoading = true;
    state = [];
    try {
      final stocks = await _stockService.fetchNYSEStocks(pageSize: 10000); 
      _allStocks = stocks;
      _isInitialized = true;
      loadMoreStocks(); // Load batch pertama (20 data pertama)
    } catch (e) {
      throw Exception('Error fetching all stock data: $e');
    } finally {
      _isLoading = false;
    }
  }

  // Menambahkan batch saham ke daftar yang ditampilkan
  void loadMoreStocks() {
    final int start = _currentBatch * _batchSize;
    final int end = start + _batchSize;

    if (start < _allStocks.length) {
      state = [
        ...state,
        ..._allStocks.sublist(start, end > _allStocks.length ? _allStocks.length : end),
      ];
      _currentBatch++;
    }
  }

  // Fungsi Pencarian Lokal di Semua Data yang Sudah Di-cache
  void searchStocks(String query) {
    if (query.isEmpty) {
      _currentBatch = 0;
      state = _allStocks.sublist(
          0, _batchSize > _allStocks.length ? _allStocks.length : _batchSize);
    } else {
      state = _allStocks.where((stock) {
        final symbolMatch =
            stock.symbol.toLowerCase().contains(query.toLowerCase());
        final nameMatch =
            stock.name.toLowerCase().contains(query.toLowerCase());
        return symbolMatch || nameMatch;
      }).toList();
    }
  }

  void reset() {
    state = [];
    _allStocks = [];
    _currentBatch = 0;
    _isInitialized = false;
  }
}
