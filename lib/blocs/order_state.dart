part of 'order_bloc.dart';

class OrderState extends Equatable {
  final bool isProcessing;
  final model.Order? order;
  final String? error;

  const OrderState._({required this.isProcessing, this.order, this.error});

  const OrderState.initial() : this._(isProcessing: false);
  const OrderState.processing() : this._(isProcessing: true);
  const OrderState.failure(String message) : this._(isProcessing: false, error: message);
  const OrderState.success(model.Order order) : this._(isProcessing: false, order: order);

  @override
  List<Object?> get props => [isProcessing, order, error];
}


