import 'package:dio/dio.dart';



class LoginService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> login(String username, String password, String role) async {
    const String url = 'http://localhost:8000/auth/login';
    
    try {
      final response = await _dio.post(
        url,
        data: {
          'username': username,
          'password': password,
          'role' : role
        },
      );

      if (response.statusCode == 200) {
        return response.data; 
      } else {
        return null; 
      }
    } on DioError catch (e) {
      throw e.response?.data['message'] ?? 'An error occurred.';
    }
  }
}
