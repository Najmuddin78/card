import 'package:card/screens/navigation_screen.dart';
import 'package:card/screens/signin_screen.dart';
import 'package:card/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _signUp() async {
    if (_formSignupKey.currentState!.validate()) {
      if (!agreePersonalData) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please agree to the processing of personal data'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

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

        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const NavigationScreen(),
          ),
        );
      }
    }
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
          // Back button
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: isTabletOrLarger ? 28 : 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(height: isTabletOrLarger ? 16 : 12),
          // Header
          Text(
            'Create Account',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isTabletOrLarger ? 36 : 28,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sign up to get started',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: isTabletOrLarger ? 18 : 16,
                ),
          ),
          SizedBox(height: screenSize.height * 0.02),
          // Form container
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
            padding: EdgeInsets.all(isTabletOrLarger ? 24 : 20),
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
              key: _formSignupKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name field
                  Text(
                    'Full Name',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isTabletOrLarger ? 18 : 16,
                        ),
                  ),
                  SizedBox(height: isTabletOrLarger ? 8 : 6),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your full name',
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Theme.of(context).colorScheme.primary,
                        size: isTabletOrLarger ? 24 : 20,
                      ),
                    ),
                  ),
                  SizedBox(height: isTabletOrLarger ? 16 : 12),

                  // Email field
                  Text(
                    'Email',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isTabletOrLarger ? 18 : 16,
                        ),
                  ),
                  SizedBox(height: isTabletOrLarger ? 8 : 6),
                  TextFormField(
                    controller: _emailController,
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
                  SizedBox(height: isTabletOrLarger ? 16 : 12),

                  // Password field
                  Text(
                    'Password',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isTabletOrLarger ? 18 : 16,
                        ),
                  ),
                  SizedBox(height: isTabletOrLarger ? 8 : 6),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
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
                  SizedBox(height: isTabletOrLarger ? 16 : 12),

                  // Confirm Password field
                  Text(
                    'Confirm Password',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isTabletOrLarger ? 18 : 16,
                        ),
                  ),
                  SizedBox(height: isTabletOrLarger ? 8 : 6),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Confirm your password',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Theme.of(context).colorScheme.primary,
                        size: isTabletOrLarger ? 24 : 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                          size: isTabletOrLarger ? 24 : 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: isTabletOrLarger ? 12 : 10),

                  // Terms and conditions
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: agreePersonalData,
                          onChanged: (bool? value) {
                            setState(() {
                              agreePersonalData = value!;
                            });
                          },
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'I agree to the processing of personal data',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: isTabletOrLarger ? 16 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTabletOrLarger ? 20 : 16),

                  // Sign up button
                  SizedBox(
                    width: double.infinity,
                    height: isTabletOrLarger ? 56 : 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signUp,
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
                              'Sign Up',
                              style: TextStyle(
                                fontSize: isTabletOrLarger ? 18 : 16,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: isTabletOrLarger ? 16 : 12),

                  // Sign in option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          fontSize: isTabletOrLarger ? 16 : 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign In',
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
