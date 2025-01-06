import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/outlook_provider.dart';
import '../providers/user_providers.dart'; 
import '../view/pricing.dart'; 
import 'dart:ui'; 
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
          // Konten utama halaman
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: outlookAsyncValue.when(
              data: (outlook) => SingleChildScrollView(
                child: Stack(
                  children: [
                    // Konten teks utama
                    Text(
                      outlook.summary,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    // Lapisan blur untuk role guest
                    if (role == 'guest')
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
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
