import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

class OrderScreen extends StatefulWidget{
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;
  String _note = '';
  String _sandwichSize = 'Footlong';

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  void _updateNote(String value) {
    setState(() => _note = value);
    debugPrint('Note updated: $_note');
  }

  void _updateSandwichSize(String newSize) {
    setState(() => _sandwichSize = newSize);
    debugPrint('Sandwich size updated: $_sandwichSize');
  }

  @override
  Widget build(BuildContext context) {
    final bool canAdd = _quantity < widget.maxQuantity;
    final bool canRemove = _quantity > 0;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OrderItemDisplay(_quantity, _sandwichSize),
              const SizedBox(height: 16),
              
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment<String>(
                    value: 'Six-inch',
                    label: Text('Six-inch'),
                  ),
                  ButtonSegment<String>(
                    value: 'Footlong',
                    label: Text('Footlong'),
                  ),
                ],
                selected: {_sandwichSize},
                onSelectionChanged: (Set<String> newSelection) {
                  _updateSandwichSize(newSelection.first);
                },
              ),
              
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Add a note',
                  hintText: 'e.g., no onions, extra pickles',
                  border: OutlineInputBorder(),
                ),
                onChanged: _updateNote, 
              ),
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledButton(
                    label: 'Add',
                    color: Colors.green,
                    onPressed: canAdd ? _increaseQuantity : null,
                  ),
                  StyledButton(
                    label: 'Remove',
                    color: Colors.red,
                    onPressed: canRemove ? _decreaseQuantity : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class StyledButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onPressed;

  const StyledButton({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey,
          disabledForegroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onPressed: onPressed,
        child: Text(label),
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
