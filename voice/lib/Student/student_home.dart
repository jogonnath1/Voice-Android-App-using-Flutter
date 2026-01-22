import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entry/entry_page.dart';
import 'student_complaint_page.dart';
import 'student_complaints_list_page.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final user = FirebaseAuth.instance.currentUser;

  // 🔓 LOGOUT
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _goToEntry();
  }

  void _goToEntry() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const EntryPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawer(context),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFFF2994A)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // ☰ SIDEBAR BUTTON
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Builder(
                  builder: (context) => GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.menu,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            const Text(
              "Student Dashboard",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            _button(
              text: "Create Complaint",
              color: Colors.white,
              textColor: Colors.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StudentComplaintPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            _button(
              text: "My Complaints",
              color: const Color(0xFFF2994A),
              textColor: Colors.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StudentComplaintsListPage(),
                  ),
                );
              },
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  // 🟦 SIDEBAR (NO DELETE ACCOUNT)
  Drawer _drawer(BuildContext context) {
    return Drawer(
      child: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get(),
        builder: (context, snapshot) {
          Map<String, dynamic> data = {};

          if (snapshot.hasData && snapshot.data!.exists) {
            data = snapshot.data!.data() as Map<String, dynamic>;
          }

          final String name = data['name'] ?? 'Student';
          final String title = data['title'] ?? 'User';
          final String email = data['email'] ?? user!.email ?? '';

          return Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFF1E3C72)),
                accountName: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(email),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.black),
                ),
                otherAccountsPictures: [
                  Text(title, style: const TextStyle(color: Colors.white)),
                ],
              ),

              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home"),
                onTap: () => Navigator.pop(context),
              ),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: logout,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _button({
    required String text,
    required VoidCallback onTap,
    required Color color,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
