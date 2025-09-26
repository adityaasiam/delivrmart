part of 'restaurant_bloc.dart';

class RestaurantState extends Equatable {
  final bool loading;
  final List<Restaurant>? restaurants;
  final List<MenuItem>? menu;

  const RestaurantState._({required this.loading, this.restaurants, this.menu});
  const RestaurantState.initial() : this._(loading: false);
  const RestaurantState.loading() : this._(loading: true);
  const RestaurantState.listLoaded(List<Restaurant> restaurants) : this._(loading: false, restaurants: restaurants);
  const RestaurantState.menuLoaded(List<MenuItem> menu) : this._(loading: false, menu: menu);

  @override
  List<Object?> get props => [loading, restaurants, menu];
}




