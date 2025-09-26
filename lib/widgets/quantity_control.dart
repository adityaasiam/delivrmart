import 'package:flutter/material.dart';

class QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  const QuantityControl({super.key, required this.quantity, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.remove),
          color: Colors.white,
          style: IconButton.styleFrom(
            backgroundColor: Colors.brown[700],
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(8),
          ),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('$quantity')),
        IconButton(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          color: Colors.white,
          style: IconButton.styleFrom(
            backgroundColor: Colors.brown[700],
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(8),
          ),
        ),
      ],
    );
  }
}



