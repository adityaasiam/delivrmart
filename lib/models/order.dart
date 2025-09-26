import 'package:equatable/equatable.dart';
import 'cart_item.dart';

class Order extends Equatable {
  final String id;
  final List<CartItem> items;
  final String address;
  final String paymentMethod; // Card, PayPal, Cash

  const Order({required this.id, required this.items, required this.address, required this.paymentMethod});

  double get subtotal => items.fold(0, (p, e) => p + e.total);
  double get deliveryFee => items.isEmpty ? 0 : 3.0;
  double get total => subtotal + deliveryFee;

  @override
  List<Object?> get props => [id, items, address, paymentMethod];
}




