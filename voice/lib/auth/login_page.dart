import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../ui/gradient_scaffold.dart';
import '../ui/back_button_widget.dart';
import '../auth/auth_wrapper.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  final String loginRole;

  const LoginPage({super.key, required this.loginRole});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      _show("Email and password required");
      return;
    }

    setState(() => loading = true);

    try {
      // 🔐 Firebase Auth login
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = cred.user!.uid;

      // 🔥 CRITICAL FIX: sync role on login
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      final snap = await userRef.get();

      if (snap.exists) {
        await userRef.update({
          'role': widget.loginRole, // admin or student
        });
      }

      // 🚀 Go to AuthWrapper
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthWrapper()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      _show(e.message ?? "Login failed");
    }

    setState(() => loading = false);
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Column(
        children: [
          SafeArea(
            child: Align(
              alignment: Alignment.centerLeft,
              child: BackIconButton(),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.loginRole == 'admin'
                        ? "Admin Login"
                        : "Student Login",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  _input(emailController, "EMAIL ID", false),
                  const SizedBox(height: 14),
                  _input(passwordController, "PASSWORD", true),
                  const SizedBox(height: 30),

                  loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(TextEditingController controller, String hint, bool obscure) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}
