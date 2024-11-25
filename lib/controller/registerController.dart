import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api_service/registerService.dart';

final registerControllerProvider =
    StateNotifierProvider<RegisterController, bool>((ref) {
  return RegisterController(ref);
});

class RegisterController extends StateNotifier<bool> {
  final Ref ref;
  final RegisterService _registerService = RegisterService();

  RegisterController(this.ref) : super(false);

  Future<String?> registerUser({
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    state = true; 

    try {
      final result = await _registerService.registerUser(
        username: username,
        password: password,
        confirmPassword: confirmPassword,
      );

      state = false; // Set loading to false

      return result; 
    } catch (e) {
      state = false;
      return e.toString();
    }
  }
}
