import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AsfiApp());
}

class AsfiApp extends StatelessWidget {
  const AsfiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'ASFI Marketplace Client',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Inter',
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0D0D1A),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF6C63FF),
            secondary: Color(0xFFFF6584),
            surface: Color(0xFF13132B),
            background: const Color(0xFF0D0D1A),
            error: Color(0xFFFF6584),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF13132B),
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          cardTheme: const CardTheme(
            color: Color(0xFF13132B),
            elevation: 0,
            margin: EdgeInsets.zero,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
