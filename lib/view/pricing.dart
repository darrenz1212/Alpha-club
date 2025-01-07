import 'package:flutter/material.dart';

class PricingPage extends StatelessWidget {
  const PricingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Scaffold(
      body: Center(
        child: Container(
          width: isDesktop ? 800 : double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _buildPricingCard(
                      title: "Monthly Plan",
                      price: "Rp 31K",
                      description: "Billed monthly. Cancel anytime.",
                      backgroundColor: Color(0xFF6A7B76),
                      textColor: Colors.white,
                      onPressed: () {

                      },
                    ),
                    const SizedBox(height: 20),
                    _buildPricingCard(
                      title: "Yearly Plan",
                      price: "Rp 300K",
                      description: "Save 19% compared to monthly billing.",
                      backgroundColor: const Color(0xFF8B9D83),
                      textColor: Colors.white,
                      onPressed: () {

                      },
                    ),
                    const SizedBox(height: 20),
                    _buildPricingCard(
                      title: "Alpha Plan",
                      price: "Rp 5000K",
                      description: "One-time payment for lifetime access.",
                      backgroundColor: Colors.black, 
                      textColor: Colors.white,
                      onPressed: () {

                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "*Prices are inclusive of all taxes.",
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPricingCard({
    required String title,
    required String price,
    required String description,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
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
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: textColor.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Choose Plan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
