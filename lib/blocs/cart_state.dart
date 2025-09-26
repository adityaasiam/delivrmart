part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  const CartState({required this.items});

  bool get isEmpty => items.isEmpty;
  double get subtotal => items.fold(0, (p, e) => p + e.total);
  double get deliveryFee => isEmpty ? 0 : 3.0;
  double get total => subtotal + deliveryFee;

  @override
  List<Object?> get props => [items];
}



