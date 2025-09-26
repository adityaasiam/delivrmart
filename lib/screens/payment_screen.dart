import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../blocs/order_bloc.dart';
import '../widgets/widgets.dart';
import '../widgets/custom_app_bar.dart';
import 'order_confirmation_screen.dart';

class PaymentScreenArguments {
  final CartState state;
  final String address;
  final String? deliveryTime;

  const PaymentScreenArguments({
    required this.state,
    required this.address,
    this.deliveryTime,
  });
}

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment';
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _method = 'Card';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
    final address = args['address'] as String? ?? '';
    final deliveryTime = args['deliveryTime'] as String?;
    final cartState = context.read<CartBloc>().state;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Payment'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state.order != null) {
              context.read<CartBloc>().add(const ClearCart());
              Navigator.pushReplacementNamed(
                context,
                OrderConfirmationScreen.routeName,
                arguments: OrderConfirmationArguments(
                  state: cartState,
                  address: address,
                  deliveryTime: deliveryTime,
                ),
              );
            }
          },
          builder: (context, orderState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RadioListTile<String>(
                  value: 'Card',
                  groupValue: _method,
                  onChanged: (v) => setState(() => _method = v!),
                  title: const Text('Credit/Debit Card'),
                ),
                RadioListTile<String>(
                  value: 'PayPal',
                  groupValue: _method,
                  onChanged: (v) => setState(() => _method = v!),
                  title: const Text('PayPal'),
                ),
                RadioListTile<String>(
                  value: 'Cash',
                  groupValue: _method,
                  onChanged: (v) => setState(() => _method = v!),
                  title: const Text('Cash on Delivery'),
                ),
                const Spacer(),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, cartState) {
                    return PrimaryButton(
                      label: orderState.isProcessing ? 'Processing...' : 'Confirm Order',
                      onPressed: orderState.isProcessing
                          ? null
                          : () {
                        context.read<OrderBloc>().add(
                          PlaceOrder(
                            items: cartState.items,
                            address: address,
                            paymentMethod: _method,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}