class StockChartData {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;

  StockChartData({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  factory StockChartData.fromJson(Map<String, dynamic> json) {
    return StockChartData(
      date: DateTime.parse(json['date']),
      open: (json['open'] ?? 0).toDouble(),
      high: (json['high'] ?? 0).toDouble(),
      low: (json['low'] ?? 0).toDouble(),
      close: (json['close'] ?? 0).toDouble(),
    );
  }
}
