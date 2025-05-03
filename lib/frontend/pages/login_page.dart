import 'package:flutter/material.dart';
import 'package:meal_planner/imports.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    Color actionColor = Colors.blue;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Logo
                Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.grey.shade900,
                ),

                // Title
                TailwindText(context, classes: 'text-2xl text-center font-bold text-gray-900', 'Sign in to your account'),

                const SizedBox(height: 40),

                // Email field
                TextInput(
                  controller: emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                ),

                const SizedBox(height: 16),

                // Password field
                TextInput(
                  controller: passwordController,
                  labelText: 'Password',

                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,

                  autofillHints: const [AutofillHints.password],

                  actionText: 'Forgot password?',
                  actionFunction: () {
                    // TODO: Implement forgot password
                  },
                ),

                const SizedBox(height: 24),
                // Sign in button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: actionColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),

                  child: TailwindText(context, classes: 'text-sm font-medium text-white', 'Sign in'),
                ),

                const SizedBox(height: 40),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TailwindText(context, classes: 'text-sm text-gray-500 font-medium', 'Not a member?'),

                    TextButton(
                      onPressed: () {
                        // TODO: Implement sign up
                      },
                      child: TailwindText(context, classes: 'text-sm font-medium text-blue', 'Start a 14 day free trial'),
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
