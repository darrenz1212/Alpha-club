import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'user/market_page/OverviewTab.dart';
import 'user/market_page/StockTab.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.black.withOpacity(0.3),
              title: const Text(
                "Market Overview",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00FFD1).withOpacity(0.15),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: const Color(0xFF00FFD1).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    labelColor: const Color(0xFF00FFD1),
                    unselectedLabelColor: Colors.white70,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Stock'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      // BODY
      body: Stack(
        children: [
          // Background Futuristik
          AnimatedContainer(
            duration: const Duration(seconds: 5),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF001F1F),
                  Color(0xFF0A0F0F),
                  Color(0xFF002626)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Efek Glow
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 250,
              height: 250,
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
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00FFD1).withOpacity(0.1),
                    Colors.transparent,
                  ],
                  radius: 0.7,
                ),
              ),
            ),
          ),

          // Konten Tab dengan transisi halus
          SafeArea(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: const [
                FadeTransitionWrapper(child: OverviewTab()),
                FadeTransitionWrapper(child: StockTab()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget pembungkus transisi fade halus antar tab
class FadeTransitionWrapper extends StatefulWidget {
  final Widget child;
  const FadeTransitionWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _FadeTransitionWrapperState createState() => _FadeTransitionWrapperState();
}

class _FadeTransitionWrapperState extends State<FadeTransitionWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _fadeAnimation, child: widget.child);
  }
}
