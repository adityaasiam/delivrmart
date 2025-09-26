import 'package:flutter/material.dart';
import '../widgets/remote_food_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/restaurant_bloc.dart';
import '../repositories/api_client.dart';
import 'menu_screen.dart';
import 'search_screen.dart';

class RestaurantListScreen extends StatefulWidget {
  static const routeName = '/restaurants';
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  bool _isGrid = true;
  double _minRating = 0.0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 800 ? 3 : (width > 600 ? 3 : 2);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Location selector header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'DELIVERY TO',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () {
                      // TODO: Show location picker
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Location picker coming soon!'),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Select your delivery location',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Search and filter bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, SearchScreen.routeName),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey.shade600),
                            const SizedBox(width: 8),
                            const Text(
                              'Search restaurants...',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(_isGrid ? Icons.grid_view : Icons.view_list),
                    tooltip: _isGrid ? 'Grid view' : 'List view',
                    onPressed: () => setState(() => _isGrid = !_isGrid),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<double>(
                    value: _minRating,
                    onChanged: (value) => setState(() => _minRating = value ?? 0.0),
                    items: const [
                      DropdownMenuItem(value: 0.0, child: Text('All Ratings')),
                      DropdownMenuItem(value: 2.0, child: Text('Top Rated 2+')),
                      DropdownMenuItem(value: 3.0, child: Text('Top Rated 3+')),
                      DropdownMenuItem(value: 4.0, child: Text('Top Rated 4+')),
                    ],
                  ),
                ],
              ),
            ),
            // Restaurant list
            Expanded(
              child: BlocProvider<RestaurantBloc>(
                create: (_) => RestaurantBloc(api: ApiClient())..add(const LoadRestaurants()),
                child: BlocBuilder<RestaurantBloc, RestaurantState>(
                  builder: (context, state) {
                    if (state.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.restaurants != null) {
                      final list = state.restaurants!.where((r) => r.rating >= _minRating).toList();
                      if (list.isEmpty) {
                        return const Center(child: Text('No restaurants found.'));
                      }
                      if (_isGrid) {
                        return GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 1.1,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: list.length,
                          itemBuilder: (context, i) {
                            final r = list[i];
                            return GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                context,
                                MenuScreen.routeName,
                                arguments: r,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: RemoteFoodImage(
                                        primaryImageUrl: r.imageUrl,
                                        query: r.name,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      r.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Up to ${r.rating.toStringAsFixed(1)}',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, i) {
                            final r = list[i];
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: RemoteFoodImage(
                                  primaryImageUrl: r.imageUrl,
                                  query: r.name,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(r.name),
                              subtitle: Text('Rating ${r.rating.toStringAsFixed(1)}'),
                              onTap: () => Navigator.pushNamed(
                                context,
                                MenuScreen.routeName,
                                arguments: r,
                              ),
                            );
                          },
                        );
                      }
                    }
                    // Handle error or unhandled state
                    return const Center(child: Text('Failed to load restaurants.'));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}