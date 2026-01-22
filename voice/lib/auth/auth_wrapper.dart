import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entry/entry_page.dart';
import '../student/student_home.dart';
import '../admin/admin_home.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        // ⏳ Auth loading
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ❌ Not logged in
        if (!authSnapshot.hasData || authSnapshot.data == null) {
          return const EntryPage();
        }

        final user = authSnapshot.data!;

        // 🔍 Fetch role from Firestore
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // 🔴 If user document does NOT exist → treat as student
            if (!roleSnapshot.hasData || !roleSnapshot.data!.exists) {
              return const StudentHome();
            }

            final data = roleSnapshot.data!.data() as Map<String, dynamic>;

            final role = data['role'];

            // ✅ ADMIN
            if (role == 'admin') {
              return const AdminHome();
            }

            // ✅ STUDENT (default)
            return const StudentHome();
          },
        );
      },
    );
  }
}
