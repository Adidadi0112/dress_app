import 'package:dress_app/screens/home.dart';
import 'package:dress_app/service/api.dart';
import 'package:dress_app/widgets/gradient_button.dart';
import 'package:dress_app/widgets/modern_text_field.dart';
import 'package:dress_app/widgets/enhanced_card.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final void Function()? onTap;

  RegisterScreen({super.key, required this.onTap});

  void register(BuildContext context) async {
    final navigator = Navigator.of(context);
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

    final response = await Api().signUp({
      "name": name,
      "email": email,
      "password": password,
    });

    if (response['type'] == 'success') {
      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(response['data']['message'])),
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
            padding: const EdgeInsets.all(SpacingTokens.space24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: SpacingTokens.space16),

                // logo
                Container(
                  padding: const EdgeInsets.all(SpacingTokens.space20),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    height: 80,
                    width: 80,
                  ),
                ),

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

                const SizedBox(height: SpacingTokens.space32),

                // register form
                EnhancedCard(
                  child: Padding(
                    padding: const EdgeInsets.all(SpacingTokens.space24),
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

                        const SizedBox(height: SpacingTokens.space24),

                        // register button
                        GradientButton(
                          onPressed: () => register(context),
                          text: 'Create Account',
                          icon: Icons.person_add,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: SpacingTokens.space24),

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
