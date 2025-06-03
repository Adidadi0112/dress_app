import 'package:dress_app/screens/home.dart';
import 'package:dress_app/service/api.dart';
import 'package:dress_app/widgets/my_button.dart';
import 'package:dress_app/widgets/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final void Function()? onTap;

  LoginScreen({super.key, required this.onTap});

  void login(BuildContext context) async {
    final navigator = Navigator.of(context); // Zapisz przed await
    final scaffoldMessenger = ScaffoldMessenger.of(context); // do SnackBar

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
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25),

              // logo
              const Icon(Icons.checkroom, size: 100),

              const SizedBox(height: 25),

              // welcome back, you've been missed!
              Text(
                'Welcome back you\'ve been missed!',
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),

              const SizedBox(height: 25),

              // username textfield
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // sign in button
              MyButton(title: "Sign In", onTap: () => login(context)),

              // const SizedBox(height: 10),

              // // or continue with
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Divider(thickness: 0.5, color: Colors.grey[400]),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //         child: Text(
              //           'Or continue with',
              //           style: TextStyle(color: Colors.grey[700]),
              //         ),
              //       ),
              //       Expanded(
              //         child: Divider(thickness: 0.5, color: Colors.grey[400]),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 10),

              // // google + apple sign in buttons
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: const [
              //     // google button
              //     SquareTile(
              //       imagePath:
              //           '/Users/adamgruda/Projects/dress_app/assets/images/google.png',
              //     ),

              //     SizedBox(width: 25),

              //     // apple button
              //     SquareTile(
              //       imagePath:
              //           '/Users/adamgruda/Projects/dress_app/assets/images/apple.png',
              //     ),
              //   ],
              // ),

              // const SizedBox(height: 25),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.blue,
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
    );
  }
}
