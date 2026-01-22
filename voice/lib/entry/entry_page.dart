import 'package:flutter/material.dart';
import '../auth/login_page.dart';
import '../ui/gradient_scaffold.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            const Spacer(),

            // 🔥 Welcome Text
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Welcome to\n",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: "VOICE",
                    style: TextStyle(
                      color: Color(0xFFF2994A),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // 🎓 Student Login Button
            _button(
              text: "Login as Student",
              bgColor: Colors.white,
              textColor: Colors.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(loginRole: 'student'),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // 🛡️ Admin Login Button
            _button(
              text: "Login as Admin",
              bgColor: const Color(0xFFF2994A),
              textColor: Colors.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(loginRole: 'admin'),
                  ),
                );
              },
            ),

            const Spacer(),

            // 👤 CREDIT TEXT (CLEAR + VISIBLE)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.28),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "App Developed by ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            letterSpacing: 0.6,
                          ),
                        ),
                        TextSpan(
                          text: "Jogonnath",
                          style: TextStyle(
                            color: Color(0xFF4CC9F0),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔘 Reusable Button
  Widget _button({
    required String text,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
