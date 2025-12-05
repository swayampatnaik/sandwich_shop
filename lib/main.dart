import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/about_screen.dart';
import 'package:sandwich_shop/views/profile_screen.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/models/cart.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop',
      initialRoute: '/order',
      routes: {
        '/': (c) => const OrderScreen(), // optional
        '/order': (c) => const OrderScreen(),
        '/cart': (c) => CartScreen(cart: Cart()), // adapt as needed / or use provider
        '/profile': (c) => const ProfileScreen(),
        '/about': (c) => const AboutScreen(),
      },
    );
  }
}
