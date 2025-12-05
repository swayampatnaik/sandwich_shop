import 'package:flutter/material.dart';

/// A simple, reusable navigation drawer for the app.
///
/// Use the optional [onNavigate] callback to handle navigation from a
/// parent (for example when you want to pass a specific Cart instance).
class AppDrawer extends StatelessWidget {
  final void Function(String route)? onNavigate;

  const AppDrawer({super.key, this.onNavigate});

  void _navigate(BuildContext context, String route) {
    // Close the drawer first
    Navigator.of(context).pop();

    if (onNavigate != null) {
      onNavigate!(route);
      return;
    }

    final String? current = ModalRoute.of(context)?.settings.name;
    if (current == route) return;

    // Use pushReplacementNamed so the back stack is kept small for top-level
    // navigation. This mirrors typical drawer behavior.
    Navigator.of(context).pushReplacementNamed(route);
  }

  Widget _buildTile(BuildContext context,
      {required IconData icon, required String label, required String route}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () => _navigate(context, route),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      horizontalTitleGap: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color headerColor = Theme.of(context).colorScheme.primary;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: headerColor,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  const FlutterLogo(size: 48),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Sandwich Shop',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Primary navigation
            _buildTile(context, icon: Icons.home, label: 'Order', route: '/'),
            _buildTile(context, icon: Icons.shopping_cart, label: 'Cart', route: '/cart'),
            _buildTile(context, icon: Icons.person, label: 'Profile', route: '/profile'),

            const Spacer(),
            const Divider(height: 1),

            // Secondary navigation
            _buildTile(context, icon: Icons.info_outline, label: 'About', route: '/about'),
          ],
        ),
      ),
    );
  }
}