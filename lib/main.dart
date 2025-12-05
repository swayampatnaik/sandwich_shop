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
      title: 'Sandwich Shop App',
      home: const OrderScreen(maxQuantity: 5),
      routes: {
        '/': (context) => const OrderScreen(maxQuantity: 5),
        '/about': (context) => const AboutScreen(),
        '/profile': (context) => const ProfileScreen(),
        // provide a basic cart route (note: the runtime app-level cart is maintained on OrderScreen)
        '/cart': (context) => CartScreen(cart: Cart()),
      },
    );
  }
}
