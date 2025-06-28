import 'package:dress_app/screens/home.dart';
import 'package:dress_app/service/api.dart';
import 'package:dress_app/widgets/gradient_button.dart';
import 'package:dress_app/widgets/modern_text_field.dart';
import 'package:dress_app/widgets/enhanced_card.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final void Function()? onTap;

  LoginScreen({super.key, required this.onTap});

  void login(BuildContext context) async {
    final navigator = Navigator.of(context); // Save before await
    final scaffoldMessenger = ScaffoldMessenger.of(context); // for SnackBar

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text("Please enter both email and password.")),
      );
      return;
    }

    final response = await Api().login({
      "email": username,
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
                const SizedBox(height: SpacingTokens.space32),

                // logo
                Container(
                  padding: const EdgeInsets.all(SpacingTokens.space24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    height: 120,
                    width: 120,
                  ),
                ),

                const SizedBox(height: SpacingTokens.space32),

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

                const SizedBox(height: SpacingTokens.space32),

                // login form
                EnhancedCard(
                  child: Padding(
                    padding: const EdgeInsets.all(SpacingTokens.space24),
                    child: Column(
                      children: [
                        ModernTextField(
                          controller: usernameController,
                          label: 'Email',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: SpacingTokens.space16),

                        ModernTextField(
                          controller: passwordController,
                          label: 'Password',
                          prefixIcon: Icons.lock_outline,
                          obscureText: true,
                        ),

                        const SizedBox(height: SpacingTokens.space16),

                        // forgot password?
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Implement forgot password
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: SpacingTokens.space16),

                        // sign in button
                        GradientButton(
                          onPressed: () => login(context),
                          text: 'Sign In',
                          icon: Icons.login,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: SpacingTokens.space24),

                // register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
