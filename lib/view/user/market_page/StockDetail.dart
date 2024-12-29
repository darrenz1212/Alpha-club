import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/stock_detail_provider.dart';
// import '../../../providers/stock_key_metrics_provider.dart';
// import '../../number_fomating .dart';

class StockDetailPage extends ConsumerWidget {
  final String stockSymbol;

  const StockDetailPage({Key? key, required this.stockSymbol})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockDetail = ref.watch(stockDetailProvider(stockSymbol));
    final stockKeyMetrics = ref.watch(stockKeyMetricsProvider(stockSymbol));

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: stockDetail.when(
        data: (data) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Informasi Perusahaan
              Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade800, Colors.blue.shade400],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 20,
                    child: Text(
                      data['companyName'] ?? '-',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 20,
                    child: Image.network(
                      data['image'] ?? '',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Informasi Singkat Perusahaan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow('Sector', data['sector']),
                    _infoRow('Industry', data['industry']),
                    _infoRow('Exchange', data['exchangeShortName']),
                    _infoRow('Current Price', '\$${data['price']?.toStringAsFixed(2) ?? '-'}'),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Divider(color: Colors.grey[700]),
              const SizedBox(height: 20),
              // Key Metrics Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Key Metrics',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    stockKeyMetrics.when(
                      data: (metrics) {
                        return GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 2.5,
                          children: [
                            // Market Cap dengan simbol $
                            _metricCard(
                              'Market Cap',
                              metrics['marketCap'] is num
                                  ? '\$${(metrics['marketCap'] as num).toStringAsFixed(2)}'
                                  : '\$${double.tryParse(metrics['marketCap'].toString())?.toStringAsFixed(2) ?? '0.00'}',
                            ),

                            // P/E Ratio tanpa simbol $
                            _metricCard(
                              'P/E Ratio',
                              metrics['peRatio'] is num
                                  ? (metrics['peRatio'] as num)
                                      .toStringAsFixed(2)
                                  : double.tryParse(
                                              metrics['peRatio'].toString())
                                          ?.toStringAsFixed(2) ??
                                      '0.00',
                            ),

                            // EPS dengan simbol $
                            _metricCard(
                              'EPS',
                              metrics['netIncomePerShare'] is num
                                  ? '\$${(metrics['netIncomePerShare'] as num).toStringAsFixed(2)}'
                                  : '\$${double.tryParse(metrics['netIncomePerShare'].toString())?.toStringAsFixed(2) ?? '0.00'}',
                            ),

                            // 52W High dengan simbol $
                            _metricCard(
                              '52W High',
                              metrics['revenuePerShare'] is num
                                  ? '\$${(metrics['revenuePerShare'] as num).toStringAsFixed(2)}'
                                  : '\$${double.tryParse(metrics['revenuePerShare'].toString())?.toStringAsFixed(2) ?? '0.00'}',
                            ),

                            // P/B Value tanpa simbol $
                            _metricCard(
                              'P/B Value',
                              metrics['pbRatio'] is num
                                  ? (metrics['pbRatio'] as num)
                                      .toStringAsFixed(2)
                                  : double.tryParse(
                                              metrics['pbRatio'].toString())
                                          ?.toStringAsFixed(2) ??
                                      '0.00',
                            ),

                            // Debt To Equity tanpa simbol $
                            _metricCard(
                              'Debt To Equity',
                              metrics['debtToEquity'] is num
                                  ? (metrics['debtToEquity'] as num)
                                      .toStringAsFixed(2)
                                  : double.tryParse(metrics['debtToEquity']
                                              .toString())
                                          ?.toStringAsFixed(2) ??
                                      '0.00',
                            ),
                          ],
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(
                        child: Text(
                          'Error: $err',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Divider(color: Colors.grey[700]),

              // Deskripsi Perusahaan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Company Description',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      data['description'] ?? 'No description available',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan Informasi Umum
  Widget _infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Text(
            value ?? '-',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan Key Metric dalam Card Grid
  Widget _metricCard(String title, dynamic value) {
    String formattedValue;

    if (value == null) {
      formattedValue = '-';
    } else if (value is num) {
      // Format angka dengan dua angka di belakang koma
      formattedValue = value.toStringAsFixed(2);
    } else {
      // Jika bukan angka, konversi langsung ke string
      formattedValue = value.toString();
    }

    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formattedValue,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
