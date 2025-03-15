import 'package:card/screens/forgot_password.dart';
import 'package:card/screens/navigation_screen.dart';
import 'package:card/screens/signup_screen.dart';
import 'package:card/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;
  bool _isPasswordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  void _signIn() async {
    if (_formSignInKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        navigateToHomeScreen();
      }
    }
  }

  void navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const NavigationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTabletOrLarger = screenSize.width >= 600;

    return CustomScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenSize.height * 0.02),
          // Header
          Text(
            'Welcome back',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isTabletOrLarger ? 36 : 28,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to continue',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: isTabletOrLarger ? 18 : 16,
                ),
          ),
          SizedBox(height: screenSize.height * 0.03),
          // Sign in form
          Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: isTabletOrLarger ? 500 : double.infinity,
            ),
            margin: isTabletOrLarger && screenSize.width > 500
                ? EdgeInsets.symmetric(
                    horizontal: (screenSize.width > 800
                        ? (screenSize.width - 500) / 2
                        : 0))
                : null,
            padding: EdgeInsets.all(isTabletOrLarger ? 32 : 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isTabletOrLarger ? 30 : 24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Form(
              key: _formSignInKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email field
                  Text(
                    'Email',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isTabletOrLarger ? 18 : 16,
                        ),
                  ),
                  SizedBox(height: isTabletOrLarger ? 12 : 8),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: isTabletOrLarger ? 24 : 20,
                      ),
                    ),
                  ),
                  SizedBox(height: isTabletOrLarger ? 24 : 20),

                  // Password field
                  Text(
                    'Password',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isTabletOrLarger ? 18 : 16,
                        ),
                  ),
                  SizedBox(height: isTabletOrLarger ? 12 : 8),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Theme.of(context).colorScheme.primary,
                        size: isTabletOrLarger ? 24 : 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                          size: isTabletOrLarger ? 24 : 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),

                  // Remember me and forgot password
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: isTabletOrLarger ? 20 : 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: rememberPassword,
                                onChanged: (bool? value) {
                                  setState(() {
                                    rememberPassword = value!;
                                  });
                                },
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Remember me',
                              style: TextStyle(
                                fontSize: isTabletOrLarger ? 16 : 14,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: isTabletOrLarger ? 16 : 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Sign in button
                  SizedBox(
                    width: double.infinity,
                    height: isTabletOrLarger ? 56 : 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      child: _isLoading
                          ? SizedBox(
                              height: isTabletOrLarger ? 24 : 20,
                              width: isTabletOrLarger ? 24 : 20,
                              child: const CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: isTabletOrLarger ? 18 : 16,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: isTabletOrLarger ? 24 : 20),

                  // Sign up option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          fontSize: isTabletOrLarger ? 16 : 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: isTabletOrLarger ? 16 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: screenSize.height * 0.02),
        ],
      ),
    );
  }
}
