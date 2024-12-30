import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/outlook_provider.dart';

class OutlookPage extends ConsumerWidget {
  const OutlookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outlookAsyncValue = ref.watch(outlookProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Market Outlook',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: outlookAsyncValue.when(
          data: (outlook) => SingleChildScrollView(
            child: Text(
              outlook.summary,
              style: const TextStyle(fontSize: 16, color: Colors.white),
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
      backgroundColor: Colors.black,
    );
  }
}
