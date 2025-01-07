import 'package:dio/dio.dart';

class MidtransService {
  final Dio dio;

  MidtransService(this.dio);
  Future<String> createTransaction({
    required String orderId,
    required int grossAmount,
    required Map<String, dynamic> customerDetails,
  }) async {
    try {
      final response = await dio.post('/createTransaction', data: {
        'order_id': orderId,
        'gross_amount': grossAmount,
        'customer_details': customerDetails,
      });

      if (response.statusCode == 200) {
        return response.data['snapToken'];
      } else {
        throw Exception('Failed to create transaction: ${response.data}');
      }
    } catch (e) {
      throw Exception('Error creating transaction: $e');
    }
  }

  Future<void> updateMembership({
    required String username,
    required String plan,
  }) async {
    try {
      final response = await dio.post('/updateMembership', data: {
        'username': username,
        'plan': plan,
      });

      if (response.statusCode != 200) {
        throw Exception('Failed to update membership: ${response.data}');
      }
    } catch (e) {
      throw Exception('Error updating membership: $e');
    }
  }
}
