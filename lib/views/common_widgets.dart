import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/app_styles.dart';

//Logo for headers.
class AppLogo extends StatelessWidget {
  final double height;

  const AppLogo({super.key, this.height = 32});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.restaurant_menu,
          size: height,
          color: Theme.of(context).colorScheme.primary,
        );
      },
    );
  }
}

//Shopping cart icon with badge showing number of items.
class CartBadge extends StatelessWidget {
  final VoidCallback? onTap;

  const CartBadge({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        final bool hasItems = cart.countOfItems > 0;

        Widget icon = Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 26),
            if (hasItems)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${cart.countOfItems}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );

        if (onTap == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: icon,
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: icon,
          ),
        );
      },
    );
  }
}

//AppBar used across the app
PreferredSizeWidget buildCommonAppBar({
  required BuildContext context,
  required String title,
  Widget? leading,
  List<Widget>? actions,
  bool showCartAction = true,
}) {
  final List<Widget> trailing = [
    ...(actions ?? <Widget>[]),
    if (showCartAction)
      CartBadge(
        onTap: () {
          final String? current = ModalRoute.of(context)?.settings.name;
          if (current == '/cart') return;
          Navigator.of(context, rootNavigator: true).pushNamed('/cart');
        },
      ),
  ];

  return AppBar(
    leading: leading,
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppLogo(height: 32),
        const SizedBox(width: 12),
        Text(title, style: AppStyles.heading1),
      ],
    ),
    actions: trailing.isEmpty ? null : trailing,
  );
}

//Button used across the app.
class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      textStyle: normalText,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: myButtonStyle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
