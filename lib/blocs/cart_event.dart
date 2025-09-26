part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class AddItem extends CartEvent {
  final MenuItem item;
  const AddItem(this.item);
  @override
  List<Object?> get props => [item];
}

class RemoveItem extends CartEvent {
  final MenuItem item;
  const RemoveItem(this.item);
  @override
  List<Object?> get props => [item];
}

class DecreaseItem extends CartEvent {
  final MenuItem item;
  const DecreaseItem(this.item);
  @override
  List<Object?> get props => [item];
}

class ClearCart extends CartEvent {
  const ClearCart();
}




