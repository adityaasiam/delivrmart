import '../../repositories/api_client.dart';
import '../../models/menu_item.dart';

/// Repository to fetch searchable items from the existing API client.
class SearchRepository {
  final ApiClient apiClient;
  SearchRepository({ApiClient? apiClient}) : apiClient = apiClient ?? ApiClient();

  /// Fetches all menu items across restaurants and returns a flat list.
  /// Falls back to local mock data if API fails.
  Future<List<MenuItem>> fetchAllMenuItems() async {
    final restaurants = await apiClient.fetchRestaurants();
    final List<MenuItem> items = [];
    for (final r in restaurants) {
      final menu = await apiClient.fetchMenu(r.id);
      items.addAll(menu);
    }
    return items;
  }
}
