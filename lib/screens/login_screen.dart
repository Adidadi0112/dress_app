import 'package:dress_app/services/firebase_auth_service.dart';
import 'package:dress_app/widgets/gradient_button.dart';
import 'package:dress_app/widgets/modern_text_field.dart';
import 'package:dress_app/widgets/enhanced_card.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final void Function()? onTap;

  LoginScreen({super.key, required this.onTap});

  void login(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context); // for SnackBar

    final email = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text("Please enter both email and password.")),
      );
      return;
    }

    try {
      final authService =
          Provider.of<FirebaseAuthService>(context, listen: false);
      final response = await authService.signIn(
        email: email,
        password: password,
      );

      if (response['type'] == 'success') {
        // Navigation will be handled automatically by the StreamBuilder in main.dart
        // No need to manually navigate
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(SpacingTokens.space16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: SpacingTokens.space24),

                // logo
                Container(
                  padding: const EdgeInsets.all(SpacingTokens.space24),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    height: 100,
                    width: 100,
                  ),
                ),

                const SizedBox(height: SpacingTokens.space24),

                // welcome text
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),

                const SizedBox(height: SpacingTokens.space8),

                Text(
                  'Sign in to continue to your wardrobe',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: SpacingTokens.space24),

                // login form
                EnhancedCard(
                  child: Padding(
                    padding: const EdgeInsets.all(SpacingTokens.space8),
                    child: Column(
                      children: [
                        ModernTextField(
                          controller: usernameController,
                          label: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: SpacingTokens.space16),

                        ModernTextField(
                          controller: passwordController,
                          label: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: SpacingTokens.space16),

                        // sign in button
                        SizedBox(
                          width: double.infinity,
                          child: GradientButton(
                            onPressed: () => login(context),
                            text: 'Sign In',
                            icon: Icons.login,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: SpacingTokens.space8),

                // register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    TextButton(
                      onPressed: onTap,
                      child: Text(
                        'Register now',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
