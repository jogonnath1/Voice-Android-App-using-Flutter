import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminComplaintsPage extends StatelessWidget {
  const AdminComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Complaints"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return const Center(
              child: Text("Failed to load complaints"),
            );
          }

          final complaints = snapshot.data!.docs;

          // Empty state
          if (complaints.isEmpty) {
            return const Center(
              child: Text("No complaints found"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final doc = complaints[index];
              final data = doc.data() as Map<String, dynamic>;

              // 🔁 Backward-compatible fields
              final String title = data['title'] ??
                  (data['text'] != null ? "Complaint" : "No Title");

              final String description = data['description'] ??
                  data['text'] ??
                  "";

              final String status = data['status'] ?? 'pending';
              final String userId = data['userId'] ?? '';
              final bool anonymous = data['anonymous'] == true;

              Color statusColor = status == 'approved'
                  ? Colors.green
                  : status == 'rejected'
                      ? Colors.red
                      : Colors.orange;

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🏷️ Title
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // 📝 Description
                      Text(
                        description,
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(height: 10),

                      // 👤 User Info
                      Text(
                        anonymous
                            ? "Submitted anonymously"
                            : "User ID: $userId",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // 📌 Status
                      Text(
                        "Status: ${status.toUpperCase()}",
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // 💬 Reply (if exists)
                      if (data.containsKey('reply'))
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "Reply: ${data['reply']}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
