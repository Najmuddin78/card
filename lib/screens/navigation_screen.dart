import 'package:card/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:card/screens/aboutus_screen.dart';
import 'package:card/screens/contactus_screen.dart';
import 'package:card/screens/home_screen.dart';
import 'package:card/screens/career.dart';
import 'package:card/screens/paymentdetails_screen.dart';
import 'package:card/screens/portolio_screen.dart';
import 'package:card/screens/service_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NavigationScreenState();
  }
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const AboutUsScreen(),
    const ServiceScreen(),
    const PortfolioScreen(),
    const PaymentDetailsScreen(),
    const ContactUsScreen(),
    const CareerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              _pages[_selectedIndex],
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CurvedNavigationBar(
                  backgroundColor: lightColorScheme.background,
                  buttonBackgroundColor: Colors.black,
                  color: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  items: <Widget>[
                    _buildNavItem(Icons.home, 'Home'),
                    _buildNavItem(Icons.info, 'About'),
                    _buildNavItem(Icons.work, 'Service'),
                    _buildNavItem(Icons.business, 'Portfolio'),
                    _buildNavItem(Icons.payment, 'Payment'),
                    _buildNavItem(Icons.contact_page, 'Contact'),
                    _buildNavItem(Icons.abc, 'Career'),
                  ],
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
        // Text(
        //   label,
        //   style: const TextStyle(
        //     color: Colors.white,
        //     fontWeight: FontWeight.bold,
        //     fontSize: 10,
        //   ),
        // ),
      ],
    );
  }
}
