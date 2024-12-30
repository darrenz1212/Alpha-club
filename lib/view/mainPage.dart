import 'package:flutter/material.dart';
import './market_page.dart';
import './outlook_page.dart';
import 'package:alpha_club/view/news_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const NewsPage(), 
    const MarketPage(), 
    const OutlookPage(), 
    const Placeholder(), 
  ];

  final List<String> _titles = [
    "AlphaClub",
    "Market",
    "Outlook",
    "Trade"
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/stock.png')),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/overview.png')),
            label: 'Outlook',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/trade.png')),
            label: 'Trade',
          ),
        ],
        type: BottomNavigationBarType.fixed, 
        selectedFontSize: 12,
        unselectedFontSize: 12,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}

