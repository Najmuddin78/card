import 'package:flutter/material.dart';
import 'package:card/screens/signin_screen.dart';
import 'package:card/widgets/custom_scaffold.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset link sent to your email'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to sign in
        Navigator.pop(context);
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
            'Forgot Password',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isTabletOrLarger ? 36 : 28,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your email to reset your password',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: isTabletOrLarger ? 18 : 16,
                ),
          ),
          SizedBox(height: screenSize.height * 0.03),
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
              key: _formKey,
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
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
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
                  SizedBox(height: isTabletOrLarger ? 32 : 24),

                  // Reset password button
                  SizedBox(
                    width: double.infinity,
                    height: isTabletOrLarger ? 56 : 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _resetPassword,
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
                              'Reset Password',
                              style: TextStyle(
                                fontSize: isTabletOrLarger ? 18 : 16,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: isTabletOrLarger ? 24 : 20),

                  // Back to sign in
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Remember your password?',
                        style: TextStyle(
                          fontSize: isTabletOrLarger ? 16 : 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
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
