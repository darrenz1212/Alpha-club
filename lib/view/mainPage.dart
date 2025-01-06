import 'package:flutter/material.dart';
import './market_page.dart';
import './outlook_page.dart';
import 'package:alpha_club/view/news_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_providers.dart';
import '../view/pricing.dart';
import '../view/loginPage.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final String role = user['role'] ?? 'guest';
    final String membershipStatus =
        role == 'guest' ? "Don't have Active Member" : "Active Member";
    final String username = user['username'] ?? '-';

    // Definisikan halaman berdasarkan role
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

    final List<BottomNavigationBarItem> _items = [
      const BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('assets/images/home.png')),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('assets/images/stock.png')),
        label: 'Market',
      ),
      const BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('assets/images/overview.png')),
        label: 'Outlook',
      ),
      if (role == 'guest')
        const BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/trade.png')),
          label: 'Buy Membership',
        ),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: _titles[_selectedIndex] != "AlphaClub"
            ? Center(
                child: Text(
                  _titles[_selectedIndex],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            : Text(
                _titles[_selectedIndex],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey[900],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Center(
                  child: Text(
                    "Welcome back, $username",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Status: $membershipStatus",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const Divider(color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // Reset user state (logout logic)
                  ref.read(userProvider.notifier).state = {};

                  // Navigate to login page
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false, // Remove all previous routes
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white70,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: _items,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
