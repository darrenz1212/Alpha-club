import 'package:dio/dio.dart';
import '../model/market.dart';

class MarketService {
  final Dio _dio = Dio();

  final List<String> _symbols = [
    'MSFT', // Microsoft
    'AAPL', // Apple
    'AMZN', // Amazon
    'NVDA', // NVIDIA
    'GOOGL', // Alphabet
    'META', // Meta
    'TSLA', // Tesla
    'BTC-USD' // Bitcoin
  ];

  Future<List<Market>> fetchMagnificent7AndBTC() async {
    const String baseUrl =
        'https://financialmodelingprep.com/api/v3/stock-price-change/';

    List<Market> markets = [];

    try {
      for (String symbol in _symbols) {
        final response = await _dio.get('$baseUrl$symbol?apikey=qm7dfWSql5Uf8VkOKTkCz8acB5xljAbM');
        
        if (response.statusCode == 200) {
          List<dynamic> data = response.data;
          if (data.isNotEmpty) {
            markets.add(Market.fromJson(data[0]));
          }
        } else {
          throw Exception('Failed to fetch data for symbol: $symbol');
        }
      }

      return markets;
    } catch (e) {
      throw Exception('Error fetching market data: $e');
    }
  }
}
