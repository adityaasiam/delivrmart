import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../widgets/widgets.dart';
import 'delivery_details_screen.dart';
import '../widgets/custom_app_bar.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cart'),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_basket_outlined, size: 64),
                  const SizedBox(height: 8),
                  const Text("Your cart is empty!"),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Browse Restaurants',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final ci = state.items[index];
                    return ListTile(
                      title: Text(ci.item.name),
                      subtitle: Text('\$${ci.item.price.toStringAsFixed(2)}'),
                      trailing: QuantityControl(
                        quantity: ci.quantity,
                        onAdd: () => context.read<CartBloc>().add(AddItem(ci.item)),
                        onRemove: () => context.read<CartBloc>().add(DecreaseItem(ci.item)),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Subtotal: \$${state.subtotal.toStringAsFixed(2)}'),
                    Text('Delivery Fee: \$${state.deliveryFee.toStringAsFixed(2)}'),
                    Text('Total: \$${state.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    PrimaryButton(
                      label: 'Proceed to Checkout',
                      onPressed: () => Navigator.pushNamed(context, DeliveryDetailsScreen.routeName),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}




