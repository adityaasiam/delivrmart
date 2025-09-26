import '../search/search_repository.dart';
import '../../models/menu_item.dart';

class SearchUseCase {
  final SearchRepository repository;
  SearchUseCase({required this.repository});

  /// returns filtered items by query and category
  Future<List<MenuItem>> search({String? query, String? category}) async {
    final all = await repository.fetchAllMenuItems();
    var filtered = all;
    if (category != null && category.isNotEmpty) {
      final c = category.toLowerCase();
      filtered = filtered.where((i) => i.name.toLowerCase().contains(c) || (i.id.toLowerCase().contains(c))).toList();
    }
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      filtered = filtered.where((i) => i.name.toLowerCase().contains(q)).toList();
    }
    return filtered;
  }
}
