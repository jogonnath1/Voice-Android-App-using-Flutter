import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../entry/entry_page.dart';
import 'admin_complaints_page.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  // 🔓 Logout
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
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
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298), Color(0xFFF2994A)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // ☰ Sidebar button
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
                      child: const Icon(Icons.menu, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            const Text(
              "Admin Dashboard",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            _button(
              text: "View Complaints",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminComplaintsPage(),
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

  // 🟦 Sidebar
  Drawer _drawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF1E3C72)),
            accountName: Text("Admin"),
            accountEmail: Text("Administrator"),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: logout,
          ),
        ],
      ),
    );
  }

  Widget _button({required String text, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
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
