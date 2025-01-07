import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../api_service/midtrans_service.dart';

final dioProvider = Provider((ref) => Dio(BaseOptions(
      baseUrl: 'http://localhost:3000/api/midtrans', 
    )));

final midtransServiceProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return MidtransService(dio);
});
