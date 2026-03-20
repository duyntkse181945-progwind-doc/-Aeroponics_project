import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';// server supabase
// AUTH SCREENS
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/reset_password_screen.dart';

// DASHBOARD
import 'screens/dashboard/garden_dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ukoscdntshlmressubcs.supabase.co',
    anonKey: 'sb_publishable_FoqTeodUGvYozRGWFaYadA_aRzD5NQe',
  );

  runApp(const SmartAgriApp());
}

class SmartAgriApp extends StatelessWidget {
  const SmartAgriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Agri App',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
      ),

      /// 🔹 Màn hình khởi đầu
      /// 👉 đổi sang GardenDashboardScreen() nếu muốn vào thẳng dashboard
      home: const LoginScreen(),

      /// 🔹 Khai báo route (điều hướng)
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/dashboard': (context) => const GardenDashboardScreen(),
      },
    );
  }
}
