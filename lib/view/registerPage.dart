import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controller/registerController.dart';
import 'loginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _register(BuildContext context, WidgetRef ref) async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    final registerController = ref.read(registerControllerProvider.notifier);
    final result = await registerController.registerUser(
      username: username,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (result == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful! Please log in.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final isLoading = ref.watch(registerControllerProvider);

      return Scaffold(
        backgroundColor: const Color(0xFF0A0F0F),
        body: Stack(
          children: [
            // Background gradasi
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF001F1F), Color(0xFF0A0F0F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Efek glow lembut turquoise
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF00FFD1).withOpacity(0.2),
                      Colors.transparent
                    ],
                    radius: 0.6,
                  ),
                ),
              ),
            ),

            // Form Register
            Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.1)),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF00FFD1).withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/altlogo.png',
                            width: 100,
                            height: 100,
                          )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .scale(
                                  begin: const Offset(0.8, 0.8),
                                  curve: Curves.easeOut),

                          const SizedBox(height: 16),
                          const Text(
                            'Create Your Account',
                            style: TextStyle(
                              color: Color(0xFF00FFD1),
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Join the Alpha Club community',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Username
                          _buildInputField(
                            controller: _usernameController,
                            hint: 'Username',
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 20),

                          // Password
                          _buildInputField(
                            controller: _passwordController,
                            hint: 'Password',
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),
                          const SizedBox(height: 20),

                          // Confirm Password
                          _buildInputField(
                            controller: _confirmPasswordController,
                            hint: 'Confirm Password',
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),
                          const SizedBox(height: 32),

                          // Tombol register
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  isLoading ? null : () => _register(context, ref),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: const Color(0xFF00FFD1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                shadowColor:
                                    const Color(0xFF00FFD1).withOpacity(0.6),
                                elevation: 8,
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.black)
                                  : const Text(
                                      'REGISTER',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 1,
                                      ),
                                    ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 800.ms, delay: 200.ms)
                              .slideY(begin: 0.3, curve: Curves.easeOut),

                          const SizedBox(height: 24),

                          // Link ke Login
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            },
                            child: Text(
                              "Already have an account? Log in",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                          Text(
                            'Version 1.0.0',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: Icon(icon, color: const Color(0xFF00FFD1)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
