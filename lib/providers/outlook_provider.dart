import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api_service/outlook_service.dart';
import '../model/outlook.dart';

final outlookServiceProvider = Provider((ref) => OutlookService());
final outlookProvider = FutureProvider<Outlook>((ref) async {
  final service = ref.watch(outlookServiceProvider);
  return service.fetchOutlook();
});
