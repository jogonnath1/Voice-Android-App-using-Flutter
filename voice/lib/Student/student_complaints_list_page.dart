import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../ui/gradient_scaffold.dart';
import '../ui/back_button_widget.dart';

class StudentComplaintsListPage extends StatelessWidget {
  const StudentComplaintsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
            "My Complaints",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('complaints')
                  .where('userId', isEqualTo: user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "Unable to load complaints",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                final complaints = snapshot.data!.docs;

                if (complaints.isEmpty) {
                  return const Center(
                    child: Text(
                      "No complaints found",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    final doc = complaints[index];
                    final data = doc.data() as Map<String, dynamic>;

                    // 🔁 BACKWARD-COMPATIBLE FIELDS
                    final String title = data.containsKey('title')
                        ? data['title']
                        : 'Complaint';

                    final String description = data.containsKey('description')
                        ? data['description']
                        : data.containsKey('text')
                        ? data['text']
                        : '';

                    final String status = data['status'] ?? 'pending';

                    Color statusColor = status == 'approved'
                        ? Colors.green
                        : status == 'rejected'
                        ? Colors.red
                        : Colors.orange;

                    final bool canEdit = status == 'pending';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🏷️ Title
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          // 📝 Description
                          Text(
                            description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // 📌 Status
                          Text(
                            "Status: ${status.toUpperCase()}",
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // ✏️ Edit / Delete
                          if (canEdit)
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () => _showEditDialog(
                                    context,
                                    doc.reference,
                                    title,
                                    description,
                                  ),
                                  icon: const Icon(Icons.edit, size: 18),
                                  label: const Text("Edit"),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () =>
                                      _showDeleteDialog(context, doc.reference),
                                  icon: const Icon(Icons.delete, size: 18),
                                  label: const Text("Delete"),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),

                          // 💬 Admin Reply
                          if (data.containsKey('reply'))
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                "Reply: ${data['reply']}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ✏️ Edit Dialog
  void _showEditDialog(
    BuildContext context,
    DocumentReference ref,
    String oldTitle,
    String oldDescription,
  ) {
    final titleController = TextEditingController(text: oldTitle);
    final descriptionController = TextEditingController(text: oldDescription);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Complaint"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isEmpty ||
                  descriptionController.text.trim().isEmpty) {
                return;
              }

              await ref.update({
                'title': titleController.text.trim(),
                'description': descriptionController.text.trim(),
                'updatedAt': FieldValue.serverTimestamp(),
              });

              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // 🗑️ Delete Dialog
  void _showDeleteDialog(BuildContext context, DocumentReference ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Complaint"),
        content: const Text("Are you sure you want to delete this complaint?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await ref.delete();
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
