import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/stock_provider.dart';
import './StockDetail.dart';

class StockTab extends ConsumerStatefulWidget {
  const StockTab({Key? key}) : super(key: key);

  @override
  ConsumerState<StockTab> createState() => _StockTabState();
}

class _StockTabState extends ConsumerState<StockTab> {
  final ScrollController _scrollController = ScrollController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(stockProvider.notifier).fetchAllStocks();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(stockProvider.notifier).loadMoreStocks();
    }
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
    });
    ref.read(stockProvider.notifier).searchStocks(query);
  }

  @override
  Widget build(BuildContext context) {
    final stocks = ref.watch(stockProvider);
    final isLoading = ref.read(stockProvider.notifier).isLoading;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search Stock by Symbol or Name',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _onSearch,
            ),
          ),

          // Stock List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: stocks.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < stocks.length) {
                  final stock = stocks[index];
                  bool isPositive = stock.price >= 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StockDetailPage(stockSymbol: stock.symbol),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Symbol Avatar
                              CircleAvatar(
                                backgroundColor: isPositive
                                    ? Colors.green
                                    : Colors.red,
                                radius: 24,
                                child: Text(
                                  stock.symbol[0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Stock Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stock.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      stock.symbol,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Price and Status
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${stock.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: isPositive
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isPositive
                                          ? Colors.green.withOpacity(0.2)
                                          : Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      isPositive ? '↑ Up' : '↓ Down',
                                      style: TextStyle(
                                        color: isPositive
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'No more stocks to load',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
