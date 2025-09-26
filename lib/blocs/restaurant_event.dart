part of 'restaurant_bloc.dart';

sealed class RestaurantEvent extends Equatable {
  const RestaurantEvent();
  @override
  List<Object?> get props => [];
}

class LoadRestaurants extends RestaurantEvent {
  const LoadRestaurants();
}

class LoadMenu extends RestaurantEvent {
  final String restaurantId;
  const LoadMenu(this.restaurantId);
  @override
  List<Object?> get props => [restaurantId];
}




