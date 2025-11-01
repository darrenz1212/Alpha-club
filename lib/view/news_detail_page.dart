import 'dart:ui' show ImageFilter;
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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Stack(
          children: [
            // Efek blur dan transparansi
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    border: const Border(
                      bottom: BorderSide(color: Colors.white10, width: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo + judul
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Image.asset(
                            'assets/images/altlogo.png',
                            height: 34,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "AlphaClub",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Color(0xFF00FFD1)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Glow turquoise di bawah AppBar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 3,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Color(0xFF00FFD1),
                      Colors.transparent,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // BODY
      body: Stack(
        children: [
          // Background futuristik
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF001F1F), Color(0xFF0A0F0F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Glow accent di pojok
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00FFD1).withOpacity(0.15),
                    Colors.transparent,
                  ],
                  radius: 0.6,
                ),
              ),
            ),
          ),

          // Konten berita
          Center(
            child: Container(
              width: isDesktop ? 700 : double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 100, 16, 80),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.news.title,
                      style: TextStyle(
                        fontSize: isDesktop ? 30 : 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00FFD1),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Published at: ${widget.news.publishedAt != null ? "${widget.news.publishedAt!.day}-${widget.news.publishedAt!.month}-${widget.news.publishedAt!.year}" : "No Date"}',
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.news.urlToImage != null
                          ? Image.network(
                              widget.news.urlToImage!,
                              width: double.infinity,
                              height: 220,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: double.infinity,
                              height: 220,
                              color: Colors.grey[900],
                              child: const Icon(Icons.image_not_supported,
                                  color: Colors.white54, size: 50),
                            ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.news.description ?? 'No Description Available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.news.content ?? 'No Content Available',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Notifikasi langganan
          if (role == 'guest' && showNotification)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.black.withOpacity(0.6),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "You've reached your free article limit.",
                          style: TextStyle(
                            color: Color(0xFF00FFD1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Subscribe for Rp 31.000,00/mo for unlimited access.",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PricingPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: const Color(0xFF00FFD1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              shadowColor:
                                  const Color(0xFF00FFD1).withOpacity(0.4),
                              elevation: 6,
                            ),
                            child: const Text(
                              "Claim This Offer",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Already a subscriber? Sign In",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
