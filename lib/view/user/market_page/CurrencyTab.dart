import 'package:flutter/material.dart';

class CurrenciesTab extends StatelessWidget {
  const CurrenciesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Currencies Content',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
