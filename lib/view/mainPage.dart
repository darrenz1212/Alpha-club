import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/user_providers.dart';
import '../api_service/NewsService.dart';
import '../utils/date_formater.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<Map<String, dynamic>> _breakingNewsFuture;
  late Future<List<Map<String, dynamic>>> _newsFuture;
  // late Future<List<Map<String, dynamic>>> _userProvider;

  @override
  void initState() {
    super.initState();
    final newsService = NewsService();
    _breakingNewsFuture = newsService.fetchHeadline();
    _newsFuture = newsService.fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AlphaClub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breaking News Section
            FutureBuilder<Map<String, dynamic>>(
              future: _breakingNewsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final article = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Breaking News',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          article['title'] ?? 'No Title',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        article['urlToImage'] != null
                            ? Image.network(
                                article['urlToImage'],
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
                        const Divider(),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                      child: Text('No breaking news available.'));
                }
              },
            ),
            // Regular News Section
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _newsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator()); // Loading indicator
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final articles = snapshot.data!;
                  // Article limit(only 10)
                  final limitedArticles = articles.take(10).toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: limitedArticles.length,
                    itemBuilder: (context, index) {
                      final article = limitedArticles[index];
                      final publishedDate = formatPublishedDate(article['publishedAt']);
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 8.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            article['urlToImage'] != null
                                ? Image.network(
                                    article['urlToImage'],
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: double.infinity,
                                    height: 200,
                                    color: Colors.grey[300],
                                  ),
                            const SizedBox(height: 20),
                            Text(
                              article['title'] ?? 'No Title',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              publishedDate, 
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Divider(height: 5,),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No news available.'));
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white70,
        unselectedItemColor: Colors.white,
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
            label: 'Trade Idea',
          ),
        ],
      ),
    );
  }
}
