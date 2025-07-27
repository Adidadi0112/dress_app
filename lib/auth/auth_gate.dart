import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dress_app/auth/login_or_register.dart';
import 'package:dress_app/screens/home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print(
            'AuthGate: Auth state changed - connectionState: ${snapshot.connectionState}, hasData: ${snapshot.hasData}, user: ${snapshot.data?.email}');

        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If user is logged in, show main app
        if (snapshot.hasData) {
          print('AuthGate: User is authenticated, showing HomeScreen');
          return const HomeScreen();
        }

        // If not logged in, show login/register
        print('AuthGate: User is not authenticated, showing LoginOrRegister');

        // Force clear any dialogs or overlays that might be showing
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context, rootNavigator: true).popUntil((route) {
            return route.isFirst;
          });
        });

        return const LoginOrRegister();
      },
    );
  }
}
