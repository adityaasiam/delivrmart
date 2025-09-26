part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object?> get props => [];
}

class PlaceOrder extends OrderEvent {
  final List<CartItem> items;
  final String address;
  final String paymentMethod;
  const PlaceOrder({required this.items, required this.address, required this.paymentMethod});
  @override
  List<Object?> get props => [items, address, paymentMethod];
}

class ResetOrder extends OrderEvent {
  const ResetOrder();
}




