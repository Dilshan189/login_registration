import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_provider.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_theme.dart';
import 'views/auth/login_screen.dart';
import 'views/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await authProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
      ],
      child: const AuthFlowApp(),
    ),
  );
}

class AuthFlowApp extends StatelessWidget {
  const AuthFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: authProvider.isAuthenticated
          ? const HomeScreen()
          : const LoginScreen(),
    );
  }
}
