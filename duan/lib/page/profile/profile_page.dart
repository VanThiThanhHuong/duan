import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // =====================
            // 🔶 PROFILE CARD
            // =====================
            _profileCard(user),

            const SizedBox(height: 20),

            // =====================
            // 📊 LEARNING STATISTICS
            // =====================
            _learningStatistics(),

            const SizedBox(height: 20),

            // =====================
            // 🏆 ACHIEVEMENTS
            // =====================
            _achievements(),

            const SizedBox(height: 20),

            // =====================
            // 🌍 LANGUAGE PROGRESS
            // =====================
            _languages(),

            const SizedBox(height: 20),

            // =====================
            // ⚙️ SETTINGS
            // =====================
            _settings(),

            const SizedBox(height: 20),

            // =====================
            // 🚪 LOG OUT BUTTON
            // =====================
            _logoutButton(context),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // 🟦 PROFILE CARD
  // ----------------------------------------------------------
  Widget _profileCard(User? user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          // Avatar cố định
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              "lib/image/dung.png",
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.email?.split('@')[0] ?? "User Name",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  user?.email ?? "No Email",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text("Edit Profile", style: TextStyle(color: Colors.white),),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // 📊 LEARNING STATISTICS
  // ----------------------------------------------------------
  Widget _learningStatistics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Learning Statistics",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem(Icons.calendar_month, "120 Days"),
              _statItem(Icons.local_fire_department, "24-Day Streak"),
              _statItem(Icons.star, "3,450 XP"),
              _statItem(Icons.check_circle, "87%"),
            ],
          )
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // 🏆 ACHIEVEMENTS
  // ----------------------------------------------------------
  Widget _achievements() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Achievements",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _achievementIcon("🔥", "7-Day Streak"),
              _achievementIcon("⚡", "Fast Learner"),
              _achievementIcon("💎", "Perfect Score"),
              _achievementIcon("🏅", "Silver Badge"),
            ],
          )
        ],
      ),
    );
  }

  Widget _achievementIcon(String emoji, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  // ----------------------------------------------------------
  // 🌍 LANGUAGE PROGRESS
  // ----------------------------------------------------------
  Widget _languages() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "My Languages",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          _languageItem(
            flag: "🇯🇵",
            name: "Japanese",
            level: 4,
            progress: 0.72,
            words: 350,
            gradient: [Colors.red, Colors.pinkAccent],
          ),
          const SizedBox(height: 22),

          _languageItem(
            flag: "🇰🇷",
            name: "Korean",
            level: 3,
            progress: 0.45,
            words: 210,
            gradient: [Colors.blue, Colors.lightBlueAccent],
          ),
          const SizedBox(height: 22),

          _languageItem(
            flag: "🇨🇳",
            name: "Chinese",
            level: 2,
            words: 150,
            progress: 0.30,
            gradient: [Colors.orange, Colors.deepOrangeAccent],
          ),
        ],
      ),
    );
  }

  Widget _languageItem({
    required String flag,
    required String name,
    required int level,
    required double progress,
    required int words,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$name  •  Level $level",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),

                // Gradient Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: gradient),
                    ),
                    width: progress * 200,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  "$words words learned",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // ⚙️ SETTINGS
  // ----------------------------------------------------------
  Widget _settings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Settings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          _settingItem(Icons.notifications, "Notifications"),
          _settingItem(Icons.access_time, "Reminders"),
          _settingItem(Icons.person, "Account"),
          _settingItem(Icons.privacy_tip, "Privacy"),
          _settingItem(Icons.help, "Help"),
          _settingItem(Icons.info, "About"),
        ],
      ),
    );
  }

  Widget _settingItem(IconData icon, String text) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.orange),
      title: Text(text, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  // ----------------------------------------------------------
  // 🚪 LOGOUT BUTTON
  // ----------------------------------------------------------
  Widget _logoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.orange),
          foregroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pop(context);
        },
        child: const Text(
          "Log Out",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // DECORATION
  // ----------------------------------------------------------
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          spreadRadius: 2,
          blurRadius: 8,
        )
      ],
    );
  }
}
