import 'package:card/screens/career.dart';
import 'package:flutter/material.dart';
import 'package:card/screens/aboutus_screen.dart';
import 'package:card/screens/contactus_screen.dart';
import 'package:card/screens/home_screen.dart';
import 'package:card/screens/paymentdetails_screen.dart';
import 'package:card/screens/portolio_screen.dart';
import 'package:card/screens/service_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

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

  final List<GButton> _navigationItems = const [
    GButton(
      icon: LineIcons.home,
      text: 'Home',
    ),
    GButton(
      icon: LineIcons.infoCircle,
      text: 'About',
    ),
    GButton(
      icon: LineIcons.tools,
      text: 'Services',
    ),
    GButton(
      icon: LineIcons.briefcase,
      text: 'Portfolio',
    ),
    GButton(
      icon: LineIcons.creditCard,
      text: 'Payment',
    ),
    GButton(
      icon: LineIcons.phone,
      text: 'Contact',
    ),
    GButton(
      icon: LineIcons.suitcase,
      text: 'Career',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isLargeScreen = screenSize.width >= 1200;

    return Scaffold(
      appBar: !isSmallScreen
          ? AppBar(
              title: Text(
                _navigationItems[_selectedIndex].text!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      // For small screens, use bottom navigation
      bottomNavigationBar:
          isSmallScreen ? _buildBottomNavigation(context) : null,
      // For larger screens, use side navigation
      drawer: !isSmallScreen ? _buildSideNavigation(context) : null,
      // For large screens, permanently display the drawer
      endDrawerEnableOpenDragGesture: false,
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 400 ? 15.0 : 8.0;
    final gap = screenWidth > 400 ? 8.0 : 4.0;
    final tabPadding = screenWidth > 400
        ? const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 10);

    // For very small screens, we'll show a more compact navigation
    final visibleItems = screenWidth < 360
        ? _navigationItems.sublist(
            0, 5) // Show only first 5 items on very small screens
        : _navigationItems;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: gap,
            activeColor: Theme.of(context).colorScheme.primary,
            iconSize: 24,
            padding: tabPadding,
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
            color: Colors.grey[600],
            tabs: visibleItems,
            selectedIndex:
                _selectedIndex < visibleItems.length ? _selectedIndex : 0,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSideNavigation(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _navigationItems.length,
                itemBuilder: (context, index) {
                  final item = _navigationItems[index];
                  return ListTile(
                    leading: Icon(
                      item.icon,
                      color: _selectedIndex == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[600],
                    ),
                    title: Text(
                      item.text!,
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[800],
                        fontWeight: _selectedIndex == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: _selectedIndex == index,
                    selectedTileColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
