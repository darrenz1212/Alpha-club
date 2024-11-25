import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api_service/loginService.dart';
import '../providers/user_providers.dart';

final loginControllerProvider =
    StateNotifierProvider<LoginController, bool>((ref) {
  return LoginController(ref);
});

class LoginController extends StateNotifier<bool> {
  final Ref ref;
  final LoginService _loginService = LoginService();

  LoginController(this.ref) : super(false); 

  Future<String?> performLogin(String username, String password, String role) async {
    state = true;

    try {
      final response = await _loginService.login(username, password, role);

      state = false; // Set loading false
      print('Response from API: $response');
      if (response != null) {
        
        ref.read(userProvider.notifier).state = {
          'username': response['data']['username'], 
          'id': response['data']['id'], 
          'role': response['data']['role']
        };
        return null;
      } else {
        return 'Login failed. Please check your credentials.';
      }
    } catch (e) {
      state = false; 
      return e.toString(); 
    }
  }
}
