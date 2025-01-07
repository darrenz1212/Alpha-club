import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/outlook_provider.dart';
import '../providers/user_providers.dart';
import '../view/pricing.dart';
import 'dart:ui';
import 'package:flutter_markdown/flutter_markdown.dart';


class OutlookPage extends ConsumerWidget {
  const OutlookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outlookAsyncValue = ref.watch(outlookProvider);

    // Ambil role user dari userProvider
    final user = ref.watch(userProvider);
    final String role = user['role'] ?? 'guest';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Market Outlook',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: outlookAsyncValue.when(
              data: (outlook) => SingleChildScrollView(
                child: Stack(
                  children: [
                    // Konten teks utama
                    // Text(
                    //   MarkdownBody(data: outlook.summary,),
                    //   style: const TextStyle(fontSize: 16, color: Colors.white),
                    // ),
                    MarkdownBody(
                      data: outlook.summary,
                      styleSheet: MarkdownStyleSheet(
                        h1: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        h2: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[300],
                        ),
                        p: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400],
                          height: 1.5,
                        ),
                        blockquote: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[500],
                          backgroundColor: Colors.grey[800],
                        ),
                        code: TextStyle(
                          fontSize: 14,
                          color: Colors.greenAccent,
                          backgroundColor: Colors.grey[900],
                          fontFamily: 'Courier',
                        ),
                        listBullet: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, stack) => Center(
                child: Text(
                  'Failed to fetch outlook: $e',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
          // Tampilkan offer untuk role guest
          if (role == 'guest')
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
                      "Unlock Full Access",
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
                  ],
                ),
              ),
            ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
