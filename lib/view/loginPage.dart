import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controller/loginController.dart';
import 'registerPage.dart';
import 'mainPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _login(BuildContext context, WidgetRef ref) async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final role = _roleController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    final loginController = ref.read(loginControllerProvider.notifier);
    final result = await loginController.performLogin(username, password, role);

    if (result == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isLoading = ref.watch(loginControllerProvider);

        return Scaffold(
          backgroundColor: const Color(0xFF0A0F0F),
          body: Stack(
            children: [
              // Background gradien
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF001F1F), Color(0xFF0A0F0F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              // Lapisan glow lembut di atas
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

              // Konten utama
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00FFD1).withOpacity(0.1),
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
                                .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOut),

                            const SizedBox(height: 16),
                            const Text(
                              'Alpha Club',
                              style: TextStyle(
                                color: Color(0xFF00FFD1),
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sign in to continue',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Username
                            _buildInputField(
                              controller: _usernameController,
                              hint: 'Username / Email',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 20),

                            // Password
                            _buildInputField(
                              controller: _passwordController,
                              hint: 'Password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              obscureText: _obscureText,
                              togglePassword: _togglePasswordVisibility,
                            ),
                            const SizedBox(height: 32),

                            // Tombol login
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : () => _login(context, ref),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: const Color(0xFF00FFD1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  shadowColor: const Color(0xFF00FFD1).withOpacity(0.6),
                                  elevation: 8,
                                ),
                                child: isLoading
                                    ? const CircularProgressIndicator(color: Colors.black)
                                    : const Text(
                                        'LOGIN',
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

                            // Link register
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                                );
                              },
                              child: Text(
                                "Don't have an account? Register",
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
      },
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? togglePassword,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? obscureText : false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: Icon(icon, color: const Color(0xFF00FFD1)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  onPressed: togglePassword,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
