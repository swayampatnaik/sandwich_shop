import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Sandwich Counter')),
        body: Center(
          child: Container(
            color: Colors.blue,
            width: 800.0,
            height: 100.0,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OrderItemDisplay(3, 'BLT'),
                OrderItemDisplay(5, 'Club'),
                OrderItemDisplay(2, 'Footlong'),
              ]
            )
          ),
        ),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final String itemType;
  final int quantity;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text('$quantity $itemType sandwich(es): ${'🥪' * quantity}');
  }
}