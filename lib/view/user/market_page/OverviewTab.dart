import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:url_launcher/url_launcher.dart'; // Import untuk membuka URL
import '../../../providers/market_provider.dart';
import '../../../providers/market_sentiment_provider.dart';

class OverviewTab extends ConsumerWidget {
  const OverviewTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketData = ref.watch(marketProvider);
    final sentimentData = ref.watch(marketSentimentProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Magnificent 7 Section
            const Text(
              'Magnificent 7',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = (constraints.maxWidth - 32) / 4;
                return marketData.when(
                  data: (markets) => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: markets.map((market) {
                      Color boxColor = market.priceChange1D >= 0
                          ? Colors.green
                          : Colors.red;

                      return SizedBox(
                        width: itemWidth,
                        child: Container(
                          decoration: BoxDecoration(
                            color: boxColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    market.symbol,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${market.priceChange1D.toStringAsFixed(2)}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(
                    child: Text(
                      'Error: $error',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            const Divider(
              color: Colors.grey,
              thickness: 1,
              height: 32,
            ),
            const Text(
              'Market Sentiment',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            sentimentData.when(
              data: (sentiments) => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sentiments.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                  height: 16,
                ),
                itemBuilder: (context, index) {
                  final sentiment = sentiments[index];
                  return GestureDetector(
                    onTap: () => (), 
                    child: ListTile(
                      leading: Image.network(
                        sentiment.bannerImage,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        sentiment.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      subtitle: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: sentiment.tickerSentiments.map((ticker) {
                          Color bgColor = ticker['label'] == 'Bullish' ||
                                  ticker['label'] == 'Somewhat-Bullish'
                              ? Colors.green
                              : ticker['label'] == 'Bearish' ||
                                      ticker['label'] == 'Somewhat-Bearish'
                                  ? Colors.red
                                  : Colors.grey;

                          return Container(
                            constraints: const BoxConstraints(
                              maxWidth: 60,
                            ),
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                ticker['ticker'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(
                  'Error: $error',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
