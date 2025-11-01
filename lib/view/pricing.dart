import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PricingPage extends StatelessWidget {
  const PricingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
     
      body: Stack(
        children: [
          // Background gradient Web3
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF001F1F), Color(0xFF0A0F0F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Glow turquoise lembut
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00FFD1).withOpacity(0.18),
                    Colors.transparent
                  ],
                  radius: 0.7,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00FFD1).withOpacity(0.12),
                    Colors.transparent
                  ],
                  radius: 0.8,
                ),
              ),
            ),
          ),

          // Konten utama
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Container(
                  width: isDesktop ? 800 : double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        "Unlock the power of AlphaClub",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Kartu harga
                      _buildPricingCard(
                        title: "Monthly Plan",
                        price: "Rp 31K",
                        description: "Billed monthly. Cancel anytime.",
                        highlight: false,
                        onPressed: () {},
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: 0.2, curve: Curves.easeOut),

                      const SizedBox(height: 20),

                      _buildPricingCard(
                        title: "Yearly Plan",
                        price: "Rp 300K",
                        description: "Save 19% compared to monthly billing.",
                        highlight: true,
                        onPressed: () {},
                      )
                          .animate()
                          .fadeIn(duration: 700.ms, delay: 100.ms)
                          .slideY(begin: 0.2, curve: Curves.easeOut),

                      const SizedBox(height: 20),

                      _buildPricingCard(
                        title: "Alpha Plan",
                        price: "Rp 5000K",
                        description: "One-time payment for lifetime access.",
                        highlight: false,
                        onPressed: () {},
                      )
                          .animate()
                          .fadeIn(duration: 800.ms, delay: 150.ms)
                          .slideY(begin: 0.2, curve: Curves.easeOut),

                      const SizedBox(height: 30),
                      Text(
                        "*Prices are inclusive of all taxes.",
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        textAlign: TextAlign.center,
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

  Widget _buildPricingCard({
    required String title,
    required String price,
    required String description,
    required bool highlight,
    required VoidCallback onPressed,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: highlight
                ? const Color(0xFF00FFD1).withOpacity(0.15)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: highlight
                  ? const Color(0xFF00FFD1).withOpacity(0.4)
                  : Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: highlight
                    ? const Color(0xFF00FFD1).withOpacity(0.25)
                    : Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: highlight ? const Color(0xFF00FFD1) : Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: highlight ? Colors.white : const Color(0xFF00FFD1),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor:
                        highlight ? const Color(0xFF00FFD1) : Colors.white,
                    foregroundColor:
                        highlight ? Colors.black : Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: highlight
                        ? const Color(0xFF00FFD1).withOpacity(0.4)
                        : Colors.white.withOpacity(0.2),
                    elevation: 5,
                  ),
                  child: Text(
                    "Choose Plan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
