import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/stock_detail_provider.dart';
import '../../pricing.dart'; 
import '../../../providers/user_providers.dart'; 

final newsDetailClickProvider = StateProvider<int>((ref) => 0);

class StockDetailPage extends ConsumerStatefulWidget {
  final String stockSymbol;

  const StockDetailPage({Key? key, required this.stockSymbol})
      : super(key: key);

  @override
  ConsumerState<StockDetailPage> createState() => _StockDetailPageState();
}

class _StockDetailPageState extends ConsumerState<StockDetailPage> {
  bool showNotification = false;

  @override
  void initState() {
    super.initState();


    Future.microtask(() {
      final viewCount = ref.read(newsDetailClickProvider.notifier);
      viewCount.state++;

      
      if (viewCount.state >= 3) {
        setState(() {
          showNotification = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stockDetail = ref.watch(stockDetailProvider(widget.stockSymbol));
    final stockKeyMetrics = ref.watch(stockKeyMetricsProvider(widget.stockSymbol));

    final int newsDetailClicks = ref.watch(newsDetailClickProvider);
    final user = ref.watch(userProvider);
    final String role = user['role'] ?? 'guest';

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(),
      body: Stack(
        children: [
          stockDetail.when(
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
                        _infoRow(
                          'Current Price',
                          '\$${data['price']?.toStringAsFixed(2) ?? '-'}',
                        ),
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

                        // Tampilkan card kosong jika klik NewsDetailPage sudah 3 kali
                        (role == 'guest' && newsDetailClicks >= 3)
                            ? Center(
                                child: const Text(
                                  "Key Metrics are unavailable due to your free limit.",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              )
                            : stockKeyMetrics.when(
                                data: (metrics) {
                                  return GridView.count(
                                    crossAxisCount: 2,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 2.5,
                                    children: [
                                      _metricCard(
                                        'Market Cap',
                                        metrics['marketCap'],
                                      ),
                                      _metricCard(
                                        'P/E Ratio',
                                        metrics['peRatio'],
                                      ),
                                      _metricCard(
                                        'EPS',
                                        metrics['netIncomePerShare'],
                                      ),
                                      _metricCard(
                                        '52W High',
                                        metrics['revenuePerShare'],
                                      ),
                                      _metricCard(
                                        'P/B Value',
                                        metrics['pbRatio'],
                                      ),
                                      _metricCard(
                                        'Debt To Equity',
                                        metrics['debtToEquity'],
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

          // Tambahkan card di bawah dengan Positioned jika role guest dan klik >= 3
          if (role == 'guest' && showNotification)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "You've reached your free quote limit.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Subscribe for Rp 31.000,00/mo for unlimited digital access.",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PricingPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Claim This Offer",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
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
