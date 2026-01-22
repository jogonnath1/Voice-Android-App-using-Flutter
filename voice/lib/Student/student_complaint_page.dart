import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../ui/gradient_scaffold.dart';
import '../ui/back_button_widget.dart';

class StudentComplaintPage extends StatefulWidget {
  const StudentComplaintPage({super.key});

  @override
  State<StudentComplaintPage> createState() => _StudentComplaintPageState();
}

class _StudentComplaintPageState extends State<StudentComplaintPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool loading = false;

  Future<void> submitComplaint() async {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and description are required")),
      );
      return;
    }

    setState(() => loading = true);

    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('complaints').add({
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'userId': user!.uid,
      'anonymous': false,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    setState(() => loading = false);

    titleController.clear();
    descriptionController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Complaint submitted successfully")),
    );

    Navigator.pop(context);
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

          const SizedBox(height: 10),

          const Text(
            "Create Complaint",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // 🏷️ Title Field
                _inputField(
                  controller: titleController,
                  hint: "Complaint Title",
                  maxLines: 1,
                ),

                const SizedBox(height: 16),

                // 📝 Description Field
                _inputField(
                  controller: descriptionController,
                  hint: "Complaint Description",
                  maxLines: 6,
                ),

                const SizedBox(height: 30),

                loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: submitComplaint,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Submit Complaint",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required int maxLines,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
