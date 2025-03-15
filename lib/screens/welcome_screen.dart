import 'package:card/screens/signin_screen.dart';
import 'package:card/screens/signup_screen.dart';
import 'package:card/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTabletOrLarger = screenSize.width >= 600;
    final logoSize = isTabletOrLarger ? 120.0 : 100.0;

    return CustomScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top section with logo and text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenSize.height * 0.03),
              // Logo or app icon
              Center(
                child: Container(
                  height: logoSize,
                  width: logoSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(logoSize * 0.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(logoSize * 0.15),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.04),
              // Welcome text
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isTabletOrLarger ? 40 : 32,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Enter personal details to access your employee account',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: isTabletOrLarger ? 18 : 16,
                    ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ],
          ),

          // Bottom section with buttons
          Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: isTabletOrLarger ? 400 : double.infinity,
            ),
            margin: isTabletOrLarger
                ? EdgeInsets.symmetric(
                    horizontal: (screenSize.width > 800
                        ? (screenSize.width - 400) / 2
                        : 0))
                : null,
            child: Column(
              children: [
                // Sign in button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize:
                        Size(double.infinity, isTabletOrLarger ? 60 : 56),
                  ),
                  child: const Text('Sign In'),
                ),
                SizedBox(height: isTabletOrLarger ? 20 : 16),
                // Sign up button
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 2),
                    foregroundColor: Colors.white,
                    minimumSize:
                        Size(double.infinity, isTabletOrLarger ? 60 : 56),
                  ),
                  child: const Text('Create Account'),
                ),
                SizedBox(height: screenSize.height * 0.05),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
