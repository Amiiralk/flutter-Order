import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder:
              (context) => FutureBuilder(
                future:
                    Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    ).initialize(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final isAuthenticated =
                        Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        ).username !=
                        null;
                    return isAuthenticated
                        ? const HomeScreen()
                        : const LoginScreen();
                  }
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
        );
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
