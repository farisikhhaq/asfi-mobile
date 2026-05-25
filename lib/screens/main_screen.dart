import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'order_history_screen.dart';
import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isAuth = auth.isAuthenticated;

    final List<Widget> pages = [
      const HomeScreen(),
      isAuth ? const OrderHistoryScreen() : const _NeedLoginView(message: 'Login untuk melihat pesanan Anda'),
      const _DummyPage(title: 'Chat / Bantuan'),
      isAuth ? const _AccountPage() : const _NeedLoginView(message: 'Login untuk mengakses profil'),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF13132B),
        selectedItemColor: const Color(0xFF6C63FF),
        unselectedItemColor: Colors.white30,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class _DummyPage extends StatelessWidget {
  final String title;
  const _DummyPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(title: Text(title), backgroundColor: const Color(0xFF13132B)),
      body: Center(
        child: Text(
          '$title - Segera Hadir',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

class _NeedLoginView extends StatelessWidget {
  final String message;
  const _NeedLoginView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 64, color: Colors.white30),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen())),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Login Sekarang'),
            )
          ],
        ),
      ),
    );
  }
}

class _AccountPage extends StatelessWidget {
  const _AccountPage();

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final user = auth.user!;
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        title: const Text('Akun Saya'),
        backgroundColor: const Color(0xFF13132B),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFFFF6584)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6C63FF)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(user.email, style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white70),
            title: const Text('Pengaturan', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.white30),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.white70),
            title: const Text('Bantuan', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.white30),
            onTap: () {},
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              await auth.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6584).withOpacity(0.1),
              foregroundColor: const Color(0xFFFF6584),
              side: const BorderSide(color: Color(0xFFFF6584)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Keluar Akun'),
          )
        ],
      ),
    );
  }
}
