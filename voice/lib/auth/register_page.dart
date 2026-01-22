import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../ui/gradient_scaffold.dart';
import '../ui/back_button_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool loading = false;

  Future<void> register() async {
    if (nameController.text.trim().isEmpty ||
        titleController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmController.text.trim().isEmpty) {
      _show("All fields are required");
      return;
    }

    if (passwordController.text != confirmController.text) {
      _show("Passwords do not match");
      return;
    }

    setState(() => loading = true);

    try {
      // 🔐 Create Auth User
      UserCredential cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      // 📦 Create Firestore User Document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
            'name': nameController.text.trim(),
            'title': titleController.text.trim(),
            'email': emailController.text.trim(),
            'role': 'student', // default role
            'createdAt': FieldValue.serverTimestamp(),
          });

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      _show(e.message ?? "Signup failed");
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
          // 🔙 Back Button
          SafeArea(
            child: Align(
              alignment: Alignment.centerLeft,
              child: BackIconButton(),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  const Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  _input(nameController, "NAME", false),
                  const SizedBox(height: 14),

                  _input(titleController, "TITLE", false),
                  const SizedBox(height: 14),

                  _input(emailController, "EMAIL ID", false),
                  const SizedBox(height: 14),

                  _input(passwordController, "PASSWORD", true),
                  const SizedBox(height: 14),

                  _input(confirmController, "CONFIRM PASSWORD", true),
                  const SizedBox(height: 30),

                  loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                  const SizedBox(height: 20),
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
