import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../widgets/custom_app_bar.dart';
import 'payment_screen.dart';
import 'order_confirmation_screen.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  static const routeName = '/delivery';
  const DeliveryDetailsScreen({super.key});

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  final _addressCtrl = TextEditingController(text: '123 Main St, Springfield');
  TimeOfDay? _time;

  void _showCheckoutSheet(BuildContext context, CartState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Review & Checkout',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Delivery Details
                          Text('Delivery Details', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Address:', style: TextStyle(color: Colors.grey)),
                              const SizedBox(width: 8),
                              Expanded(child: Text(_addressCtrl.text, style: const TextStyle(fontWeight: FontWeight.w500))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text('Delivery Time:', style: TextStyle(color: Colors.grey)),
                              const SizedBox(width: 8),
                              Text(_time?.format(context) ?? 'ASAP (25-30m)', style: const TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(height: 18),
                          // Order Payment Details
                          Text('Order Payment Details', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                          const SizedBox(height: 8),
                          ...state.items.map((item) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text('${item.quantity} × ${item.item.name}', style: const TextStyle(fontSize: 14)),
                                    ),
                                    Text('Rs ${(item.total).toStringAsFixed(2)}', style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              )),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Subtotal', style: TextStyle(color: Colors.grey)),
                              Text('Rs ${state.subtotal.toStringAsFixed(2)}'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Delivery Fee', style: TextStyle(color: Colors.grey)),
                              Text('Rs ${state.deliveryFee.toStringAsFixed(2)}'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('Rs ${state.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushNamed(
                            context,
                            PaymentScreen.routeName,
                            arguments: {
                              'address': _addressCtrl.text.trim(),
                              'deliveryTime': _time?.format(context),
                              'state': state,
                            },
                          );
                        },
                        child: const Text('Proceed to Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Delivery Details'),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Address'),
                const SizedBox(height: 8),
                TextField(
                  controller: _addressCtrl,
                  decoration: const InputDecoration(labelText: ''),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Expanded(child: Text('Delivery Time:')),
                    const SizedBox(width: 8),
                    Text(_time == null ? 'ASAP (25-30m)' : _time!.format(context)),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () async {
                        final now = TimeOfDay.now();
                        final time = await showTimePicker(
                          context: context,
                          initialTime: now,
                        );
                        if (time != null) {
                          setState(() => _time = time);
                        }
                      },
                      child: const Text('Schedule'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (final item in state.items)
                      ListTile(
                        dense: true,
                        title: Text('${item.item.name} × ${item.quantity}'),
                        trailing: Text('Rs ${item.total.toStringAsFixed(2)}'),
                      ),
                    const Divider(),
                    ListTile(
                      title: const Text('Subtotal'),
                      trailing: Text('Rs ${state.subtotal.toStringAsFixed(2)}'),
                    ),
                    ListTile(
                      title: const Text('Delivery Fee'),
                      trailing: Text('Rs ${state.deliveryFee.toStringAsFixed(2)}'),
                    ),
                    ListTile(
                      title: const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text('Rs ${state.total.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Only show the main action button, which directly opens the modal sheet
                // The modal's 'Proceed to Payment' is the only confirmation button
                ElevatedButton(
                  onPressed: () => _showCheckoutSheet(context, state),
                  child: const Text('Proceed to Payment'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    super.dispose();
  }
}