import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/news.dart';
import '../providers/user_providers.dart';
import '../view/pricing.dart';

final viewCountProvider = StateProvider<int>((ref) => 0);

class NewsDetailPage extends ConsumerStatefulWidget {
  final News news;

  const NewsDetailPage({Key? key, required this.news}) : super(key: key);

  @override
  ConsumerState<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends ConsumerState<NewsDetailPage> {
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final viewCount = ref.read(viewCountProvider.notifier);
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
    final user = ref.watch(userProvider);
    final String role = user['role'] ?? 'guest';
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AlphaClub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: isDesktop ? 600 : double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.news.title,
                      style: TextStyle(
                        fontSize: isDesktop ? 32 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Published at: ${widget.news.publishedAt != null ? "${widget.news.publishedAt!.day}-${widget.news.publishedAt!.month}-${widget.news.publishedAt!.year}" : "No Date"}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 16),
                    widget.news.urlToImage != null
                        ? Image.network(
                            widget.news.urlToImage!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey[300],
                          ),
                    const SizedBox(height: 16),
                    Text(
                      widget.news.description ?? 'No Description Available',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.news.content ?? 'No Content Available',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
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
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        // Tambahkan logika untuk sign in jika user sudah berlangganan
                      },
                      child: const Text(
                        "Already a subscriber? Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
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
}
