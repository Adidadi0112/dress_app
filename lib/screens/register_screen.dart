import 'package:dress_app/services/firebase_auth_service.dart';
import 'package:dress_app/widgets/gradient_button.dart';
import 'package:dress_app/widgets/modern_text_field.dart';
import 'package:dress_app/widgets/enhanced_card.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final void Function()? onTap;

  RegisterScreen({super.key, required this.onTap});

  void register(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        email.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text("All fields are required.")),
      );
      return;
    }

    if (password != confirmPassword) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text("Passwords do not match.")),
      );
      return;
    }

    try {
      final authService =
          Provider.of<FirebaseAuthService>(context, listen: false);
      final response = await authService.signUp(
        name: name,
        email: email,
        password: password,
      );

      if (response['type'] == 'success') {
        // Navigation will be handled automatically by the StreamBuilder in main.dart
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text("Account created successfully!")),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Registration failed')),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
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

                // welcome text
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),

                const SizedBox(height: SpacingTokens.space8),

                Text(
                  'Sign up to start organizing your wardrobe',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: SpacingTokens.space16),

                // register form
                EnhancedCard(
                  child: Padding(
                    padding: const EdgeInsets.all(SpacingTokens.space8),
                    child: Column(
                      children: [
                        ModernTextField(
                          controller: nameController,
                          label: 'Full Name',
                          prefixIcon: const Icon(Icons.person_outline),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: SpacingTokens.space16),

                        ModernTextField(
                          controller: emailController,
                          label: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
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
                          prefixIcon: Icon(Icons.lock_outline),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: SpacingTokens.space16),

                        ModernTextField(
                          controller: confirmPasswordController,
                          label: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock_outline),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: SpacingTokens.space16),

                        // register button
                        SizedBox(
                          width: double.infinity,
                          child: GradientButton(
                            onPressed: () => register(context),
                            text: 'Create Account',
                            icon: Icons.person_add,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: SpacingTokens.space16),

                // login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    TextButton(
                      onPressed: onTap,
                      child: Text(
                        'Sign In',
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
