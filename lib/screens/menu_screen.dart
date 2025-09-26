import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/restaurant.dart';
import '../blocs/restaurant_bloc.dart';
import '../repositories/api_client.dart';
import '../blocs/cart_bloc.dart';

import 'cart_screen.dart';


import '../widgets/remote_food_image.dart';

class MenuScreen extends StatefulWidget {
  static const routeName = '/menu';
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _isGrid = false;

  @override
  Widget build(BuildContext context) {
    final restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant?;
    final r = restaurant ?? mockRestaurants.first;
    return Scaffold(
      appBar: AppBar(
        title: Text(r.name),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.grid_view : Icons.view_list),
            tooltip: _isGrid ? 'Grid view' : 'List view',
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, CartScreen.routeName),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) => RestaurantBloc(api: ApiClient())..add(LoadMenu(r.id)),
        child: BlocBuilder<RestaurantBloc, RestaurantState>(
          builder: (context, state) {
            final items = state.menu ?? r.menu;
            if (state.loading && state.menu == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_isGrid) {
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final m = items[i];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RemoteFoodImage(
                              primaryImageUrl: m.imageUrl,
                              query: m.name,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(m.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('\$${m.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                              FilledButton(
                                onPressed: () => context.read<CartBloc>().add(AddItem(m)),
                                child: const Text('Add'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final m = items[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: RemoteFoodImage(
                        primaryImageUrl: m.imageUrl,
                        query: m.name,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(m.name),
                    subtitle: Text('\$${m.price.toStringAsFixed(2)}'),
                    trailing: FilledButton(
                      onPressed: () => context.read<CartBloc>().add(AddItem(m)),
                      child: const Text('Add'),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

