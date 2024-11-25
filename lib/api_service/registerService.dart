import 'package:dio/dio.dart';

class RegisterService {
  final Dio _dio = Dio();

  Future<String?> registerUser({
    required String username,
    required String password,
    required String confirmPassword,
    String role = 'user', 
  }) async {
    const String url = 'http://localhost:8000/auth/register';

    try {
      final response = await _dio.post(
        url,
        data: {
          'username': username,
          'password': password,
          'confirmPassword': confirmPassword,
          'role': role,
        },
      );

      if (response.statusCode == 200) {
        return null;
      } else {
        return response.data['message'] ?? 'Registration failed.';
      }
    } on DioError catch (e) {
      return e.response?.data['message'] ?? 'An error occurred.';
    }
  }
}
