import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/restaurant.dart';
import '../models/menu_item.dart';
import '../repositories/api_client.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final ApiClient api;
  RestaurantBloc({required this.api}) : super(const RestaurantState.initial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<LoadMenu>(_onLoadMenu);
  }

  Future<void> _onLoadRestaurants(LoadRestaurants event, Emitter<RestaurantState> emit) async {
    emit(const RestaurantState.loading());
    final list = await api.fetchRestaurants();
    emit(RestaurantState.listLoaded(list));
  }

  Future<void> _onLoadMenu(LoadMenu event, Emitter<RestaurantState> emit) async {
    emit(const RestaurantState.loading());
    final menu = await api.fetchMenu(event.restaurantId);
    emit(RestaurantState.menuLoaded(menu));
  }
}




