class Market {
  final String symbol;
  final double priceChange1D;

  Market({
    required this.symbol,
    required this.priceChange1D,
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      symbol: json['symbol'] ?? 'Unknown',
      priceChange1D: json['1D']?.toDouble() ?? 0.0,
    );
  }
}
