import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_providers.dart';
import './market_page.dart';
import './outlook_page.dart';
import '../view/news_page.dart';
import '../view/pricing.dart';
import '../view/loginPage.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final String role = user['role'] ?? 'guest';
    final String membershipStatus =
        role == 'guest' ? "Don't have Active Member" : "Active Member";
    final String username = user['username'] ?? '-';

    final List<Widget> _pages = [
      const NewsPage(),
      const MarketPage(),
      const OutlookPage(),
      if (role == 'guest') const PricingPage(),
    ];

    final List<String> _titles = [
      "AlphaClub",
      "Market",
      "Outlook",
      if (role == 'guest') "Choose your Plan",
    ];

    final List<IconData> _icons = [
      Icons.home_outlined,
      Icons.show_chart_outlined,
      Icons.analytics_outlined,
      if (role == 'guest') Icons.shopping_bag_outlined,
    ];

    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Stack(
            children: [
              // Lapisan blur dan transparansi
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      border: const Border(
                        bottom: BorderSide(color: Colors.white12, width: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 16),
                            Image.asset(
                              'assets/images/altlogo.png',
                              height: 36,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _titles[_selectedIndex],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        // tombol drawer
                        IconButton(
                          icon: const Icon(Icons.menu_rounded,
                              color: Color(0xFF00FFD1), size: 26),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Glow bar animasi di bawah AppBar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(seconds: 3),
                  curve: Curves.easeInOut,
                  height: 3,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color(0xFF00FFD1),
                        Colors.transparent
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

      // Drawer bergaya glassmorphism
      drawer: Drawer(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: Colors.white.withOpacity(0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome back,",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          username,
                          style: const TextStyle(
                            color: Color(0xFF00FFD1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Status: $membershipStatus",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white24, indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      ref.read(userProvider.notifier).state = {};
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // Body dengan gradient futuristik
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF001F1F), Color(0xFF0A0F0F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: PageView(
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) => setState(() => _selectedIndex = index),
          children: _pages,
        ),
      ),

      // Floating glass bottom navigation bar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FFD1).withOpacity(0.15),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_icons.length, (index) {
                  final bool isActive = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () => _onItemTapped(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF00FFD1).withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        _icons[index],
                        size: 28,
                        color:
                            isActive ? const Color(0xFF00FFD1) : Colors.white70,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
