import 'package:equatable/equatable.dart';
import 'menu_item.dart';

class CartItem extends Equatable {
  final MenuItem item;
  final int quantity;

  const CartItem({required this.item, this.quantity = 1});

  CartItem copyWith({int? quantity}) => CartItem(item: item, quantity: quantity ?? this.quantity);

  double get total => item.price * quantity;

  @override
  List<Object?> get props => [item, quantity];
}



