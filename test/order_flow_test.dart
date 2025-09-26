import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:delivr_mart/blocs/cart_bloc.dart';
import 'package:delivr_mart/blocs/order_bloc.dart';
import 'package:delivr_mart/models/restaurant.dart';

void main() {
  test('CartBloc add and total', () {
    final bloc = CartBloc();
    final item = mockRestaurants.first.menu.first;
    bloc.add(AddItem(item));
    expectLater(
      bloc.stream,
      emits(predicate<CartState>((s) => s.items.isNotEmpty && s.subtotal > 0)),
    );
  });

  blocTest<OrderBloc, OrderState>(
    'places order successfully',
    build: () => OrderBloc(),
    act: (bloc) => bloc.add(PlaceOrder(items: const [], address: '123 Street', paymentMethod: 'Card')),
    wait: const Duration(milliseconds: 900),
    expect: () => [
      const OrderState.processing(),
      isA<OrderState>().having((s) => s.order != null, 'has order', true),
    ],
  );
}




