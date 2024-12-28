import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/stock_detail_provider.dart';
// import 'package:url_launcher/url_launcher.dart';

class StockDetailPage extends ConsumerWidget {
  final String stockSymbol;

  const StockDetailPage({Key? key, required this.stockSymbol}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockDetail = ref.watch(stockDetailProvider(stockSymbol));

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'Stock Detail: $stockSymbol',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: stockDetail.when(
        data: (data) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  children: [
                    _infoRow('Sector', data['sector']),
                    _infoRow('Industry', data['industry']),
                    _infoRow('Exchange', data['exchangeShortName']),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Divider(color: Colors.grey[700]),

              // Informasi Harga Saham
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Stock Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _stockInfoTile('Current Price', '\$${data['price']}'),
                    _stockInfoTile('Market Cap', '\$${data['mktCap']}'),
                    _stockInfoTile('Beta', '${data['beta']}'),
                    _stockInfoTile('Dividend Yield', '${data['lastDiv']}'),
                    _stockInfoTile('Price Range', data['range']),
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
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan Informasi Saham
  Widget _stockInfoTile(String title, String value) {
    return Card(
      color: Colors.grey[850],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }


}
