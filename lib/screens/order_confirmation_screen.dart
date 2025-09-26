import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/widgets.dart';

class OrderConfirmationArguments {
  final CartState state;
  final String address;
  final String? deliveryTime;

  const OrderConfirmationArguments({
    required this.state,
    required this.address,
    this.deliveryTime = null,
  });
}

class OrderConfirmationScreen extends StatelessWidget {
  static const routeName = '/order-confirmation';
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OrderConfirmationArguments?;
    if (args == null) {
      return const Scaffold(body: Center(child: Text('No order details provided.')));
    }
    final state = args.state;
    final address = args.address;
    final deliveryTime = args.deliveryTime;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Order Confirmed'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'Order Confirmed!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Your order has been placed successfully.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Delivery Info
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Address',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Delivery Time',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deliveryTime ?? 'ASAP (25-30m)',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),
            // Order Summary
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Order Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
            ...state.items.map((item) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('${item.quantity} × ${item.item.name}'),
              trailing: Text('Rs ${(item.item.price * item.quantity).toStringAsFixed(2)}'),
            )),
            const Divider(height: 32),
            // Pricing Details
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Subtotal'),
              trailing: Text('Rs ${state.subtotal.toStringAsFixed(2)}'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Delivery Fee'),
              trailing: Text('Rs ${state.deliveryFee.toStringAsFixed(2)}'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: Text(
                'Rs ${state.total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: 'Back to Home',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/restaurants',
                        (route) => false,
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