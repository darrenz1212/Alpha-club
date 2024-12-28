import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/stock_detail_provider.dart';

class StockDetailPage extends ConsumerWidget {
  final String stockSymbol;

  const StockDetailPage({Key? key, required this.stockSymbol}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockDetail = ref.watch(stockDetailProvider(stockSymbol));

    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Detail: $stockSymbol'),
        backgroundColor: Colors.black,
      ),
      body: stockDetail.when(
        data: (data) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    data['image'] ?? '',
                    height: 100,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  data['companyName'] ?? 'Unknown Company',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Sector: ${data['sector']}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Industry: ${data['industry']}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Exchange: ${data['exchangeShortName']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Divider(),
                Text(
                  'Stock Information:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: Text('Current Price'),
                  trailing: Text('\$${data['price']}'),
                ),
                ListTile(
                  title: Text('Market Cap'),
                  trailing: Text('\$${data['mktCap']}'),
                ),
                ListTile(
                  title: Text('Beta'),
                  trailing: Text('${data['beta']}'),
                ),
                ListTile(
                  title: Text('Dividend Yield'),
                  trailing: Text('${data['lastDiv']}'),
                ),
                ListTile(
                  title: Text('Price Range'),
                  trailing: Text(data['range']),
                ),
                Divider(),
                Text(
                  'Company Description:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  data['description'] ?? 'No description available',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (data['website'] != null) {
                      launchURL(data['website']);
                    }
                  },
                  child: Text('Visit Company Website'),
                ),
              ],
            ),
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void launchURL(String url) {
    // Buka URL di browser
    // Implementasikan menggunakan url_launcher
  }
}
