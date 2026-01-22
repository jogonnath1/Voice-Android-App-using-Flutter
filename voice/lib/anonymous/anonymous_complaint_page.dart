import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../ui/gradient_scaffold.dart';
import '../ui/back_button_widget.dart';

class AnonymousComplaintPage extends StatefulWidget {
  const AnonymousComplaintPage({super.key});

  @override
  State<AnonymousComplaintPage> createState() =>
      _AnonymousComplaintPageState();
}

class _AnonymousComplaintPageState extends State<AnonymousComplaintPage> {
  final TextEditingController complaintController = TextEditingController();
  bool loading = false;

  Future<void> submitComplaint() async {
    if (complaintController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a complaint")),
      );
      return;
    }

    setState(() => loading = true);

    await FirebaseFirestore.instance.collection('complaints').add({
      'text': complaintController.text.trim(),
      'status': 'pending',
      'anonymous': true,
      'createdAt': FieldValue.serverTimestamp(),
    });

    complaintController.clear();
    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Complaint submitted successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Column(
        children: [
          // ❌ DO NOT use const SafeArea here
          SafeArea(
            child: Align(
              alignment: Alignment.centerLeft,
              child: BackIconButton(), // ✅ NO ERROR NOW
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  "Anonymous Complaint",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: complaintController,
                  maxLines: 6,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Write your complaint here...",
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: submitComplaint,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Submit"),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
