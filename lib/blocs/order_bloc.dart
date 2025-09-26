import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/order.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../repositories/api_client.dart';
import '../models/cart_item.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final ApiClient _api = ApiClient();
  OrderBloc() : super(const OrderState.initial()) {
    on<PlaceOrder>(_onPlaceOrder);
    on<ResetOrder>((event, emit) => emit(const OrderState.initial()));
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
    emit(const OrderState.processing());
    await Future.delayed(const Duration(milliseconds: 800));
    // simple mocked network failure simulation
    if (event.address.trim().isEmpty) {
      emit(const OrderState.failure('Please provide a valid address'));
      return;
    }
    final order = model.Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: event.items,
      address: event.address,
      paymentMethod: event.paymentMethod,
    );
    try {
      final user = fb.FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .doc(order.id)
            .set({
          'total': order.total,
          'address': order.address,
          'paymentMethod': order.paymentMethod,
          'createdAt': FieldValue.serverTimestamp(),
          'items': [
            for (final i in order.items)
              {
                'id': i.item.id,
                'name': i.item.name,
                'price': i.item.price,
                'qty': i.quantity,
              }
          ],
        });

        // If user profile has apiKey (usercode), also place order via API
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final apiKey = userDoc.data()?['apiKey'] as String?;
        final restaurantId = order.items.isNotEmpty
            ? (order.items.first.item.restaurantId ?? '')
            : '';
        if (apiKey != null && apiKey.isNotEmpty && restaurantId.isNotEmpty) {
          final menuDTO = [
            for (final i in order.items)
              {
                'itemName': i.item.name,
                'quantity': i.quantity,
              }
          ];
          try {
            await _api.makeOrder(apiKey: apiKey, restaurantId: restaurantId, menuDTO: menuDTO);
          } catch (_) {}
        }
      }
    } catch (_) {}
    emit(OrderState.success(order));
  }
}

