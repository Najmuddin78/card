import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final horizontalPadding = screenSize.width > 600 ? 48.0 : 24.0;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 56, // Fixed height to ensure consistency
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Modern gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                ],
              ),
            ),
          ),
          // Modern pattern overlay
          Opacity(
            opacity: 0.05,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg1.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Content with safe area
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenSize.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      56,
                ),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 16,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: screenSize.width > 1200 ? 800 : double.infinity,
                    ),
                    margin: screenSize.width > 1200
                        ? EdgeInsets.symmetric(
                            horizontal: (screenSize.width - 800) / 2)
                        : null,
                    child: child!,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
