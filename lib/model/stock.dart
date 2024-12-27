class Stock {
  final String symbol;
  final String name;
  final double price;
  final String exchange;

  Stock({
    required this.symbol,
    required this.name,
    required this.price,
    required this.exchange,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      exchange: json['exchange'] ?? '',
    );
  }
}
