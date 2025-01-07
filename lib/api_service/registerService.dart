import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class RegisterService {
  final Dio _dio = Dio();

  Future<String?> registerUser({
    required String username,
    required String password,
    required String confirmPassword,
    String role = 'guest',
  }) async {
    const String url = 'http://192.168.163.125:8000/auth/register';

    try {
      // Hitung tanggal hari ini dikurangi satu hari
      final DateTime today = DateTime.now();
      final DateTime membershipEnd = today.subtract(Duration(days: 1));
      final String formattedDate = DateFormat('yyyy-MM-dd').format(membershipEnd);

      final response = await _dio.post(
        url,
        data: {
          'username': username,
          'password': password,
          'confirmPassword': confirmPassword,
          'role': role,
          'membership_end': formattedDate, 
        },
      );

      if (response.statusCode == 200) {
        return response.data['status'];
      } else {
        return response.data['message'] ?? 'Registration failed.';
      }
    } on DioError catch (e) {
      return e.response?.data['message'] ?? 'An error occurred.';
    }
  }
}
