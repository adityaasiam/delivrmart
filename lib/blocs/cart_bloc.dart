import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState(items: [])) {
    on<AddItem>((event, emit) {
      final items = List<CartItem>.from(state.items);
      final index = items.indexWhere((e) => e.item.id == event.item.id);
      if (index >= 0) {
        final existing = items[index];
        items[index] = existing.copyWith(quantity: existing.quantity + 1);
      } else {
        items.add(CartItem(item: event.item));
      }
      emit(CartState(items: items));
    });
    on<RemoveItem>((event, emit) {
      final items = state.items.where((e) => e.item.id != event.item.id).toList();
      emit(CartState(items: items));
    });
    on<DecreaseItem>((event, emit) {
      final items = List<CartItem>.from(state.items);
      final index = items.indexWhere((e) => e.item.id == event.item.id);
      if (index >= 0) {
        final existing = items[index];
        final newQty = existing.quantity - 1;
        if (newQty <= 0) {
          items.removeAt(index);
        } else {
          items[index] = existing.copyWith(quantity: newQty);
        }
      }
      emit(CartState(items: items));
    });
    on<ClearCart>((event, emit) => emit(const CartState(items: [])));
  }
}




