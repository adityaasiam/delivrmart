import 'package:equatable/equatable.dart';
import 'menu_item.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final double rating;
  final List<MenuItem> menu;
  final String? imageUrl;

  const Restaurant({required this.id, required this.name, required this.rating, required this.menu, this.imageUrl});

  @override
  List<Object?> get props => [id, name, rating, menu, imageUrl];
}

final mockRestaurants = <Restaurant>[
  Restaurant(
    id: 'r1',
    name: 'The Italian Oven',
    rating: 4.7,
    menu: const [
      MenuItem(id: 'm1', name: 'Margherita Pizza', price: 9.5),
      MenuItem(id: 'm2', name: 'Spaghetti Carbonara', price: 12.0),
      MenuItem(id: 'm3', name: 'Tiramisu', price: 6.0),
    ],
    imageUrl: null,
  ),
  Restaurant(
    id: 'r2',
    name: 'Sushi Cloud',
    rating: 4.5,
    menu: const [
      MenuItem(id: 'm4', name: 'Salmon Nigiri', price: 8.0),
      MenuItem(id: 'm5', name: 'California Roll', price: 7.0),
    ],
    imageUrl: null,
  ),
];



