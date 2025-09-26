import 'package:flutter/material.dart';
import '../widgets/remote_food_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/search_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../features/search/search_repository.dart';
import '../features/search/search_usecase.dart';
import '../widgets/primary_button.dart';
import '../widgets/custom_app_bar.dart';

class SearchScreen extends StatelessWidget {
  static const routeName = '/search';
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(useCase: SearchUseCase(repository: SearchRepository()))..add(const FetchResults()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();
  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _searchCtrl = TextEditingController();
  final _categories = ['Pizza', 'Salad', 'Burger', 'Hotdog', 'Ramen', 'Sushi'];
  String _selected = 'Pizza';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      context.read<SearchBloc>().add(SearchQueryChanged(_searchCtrl.text.trim()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Search'),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search for food or restaurants',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),

            // Category chips
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, i) {
                  final c = _categories[i];
                  final selected = c == _selected;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: selected,
                      onSelected: (_) {
                        setState(() => _selected = c);
                        context.read<SearchBloc>().add(CategorySelected(c));
                      },
                      selectedColor: Colors.red.shade600,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Results
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is SearchError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Something went wrong: ${state.message}'),
                          const SizedBox(height: 8),
                          PrimaryButton(label: 'Retry', onPressed: () => context.read<SearchBloc>().add(const FetchResults())),
                        ],
                      ),
                    );
                  }
                  if (state is SearchLoaded) {
                    if (state.items.isEmpty) {
                      return Center(child: Text('No results found'));
                    }
                    // Grid view of items
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .78, crossAxisSpacing: 12, mainAxisSpacing: 12),
                      itemCount: state.items.length,
                      itemBuilder: (context, i) {
                        final item = state.items[i];
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: RemoteFoodImage(
                                      primaryImageUrl: item.imageUrl,
                                      query: item.name,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                    Row(children: [
                                      IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
                                      IconButton(onPressed: () => context.read<CartBloc>().add(AddItem(item)), icon: Icon(Icons.add_circle, color: Colors.red.shade600)),
                                    ])
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
