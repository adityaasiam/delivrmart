import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';
import '../models/menu_item.dart';

class ApiClient {
  static const String baseUrl = 'https://fakerestaurantapi.runasp.net';
  final http.Client _client;
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Restaurant>> fetchRestaurants() async {
    try {
      final res = await _client.get(Uri.parse('$baseUrl/api/Restaurant'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body) as List;
    return data
      .map((e) => Restaurant(
          id: (e['restaurantID'] ?? e['id'] ?? '').toString(),
          name: (e['restaurantName'] ?? e['name'] ?? 'Restaurant').toString(),
          rating: 4.5,
          menu: const [],
          imageUrl: (e['imageUrl'] ?? e['image'] ?? e['photo'] ?? null)?.toString(),
        ))
      .toList();
      }
      throw Exception('HTTP ${res.statusCode}');
    } catch (_) {
      return mockRestaurants; // graceful fallback to mock data
    }
  }

  Future<List<MenuItem>> fetchMenu(String restaurantId) async {
    try {
      final res = await _client.get(Uri.parse('$baseUrl/api/Restaurant/$restaurantId/menu'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body) as List;
    return data
      .map((e) => MenuItem(
          id: (e['itemID'] ?? e['id'] ?? '').toString(),
          name: (e['itemName'] ?? e['name'] ?? 'Item').toString(),
          price: ((e['itemPrice'] ?? e['price'] ?? 0) as num).toDouble(),
          restaurantId: (e['restaurantID'] ?? '').toString(),
          imageUrl: (e['imageUrl'] ?? e['image'] ?? e['photo'] ?? null)?.toString(),
        ))
      .toList();
      }
      throw Exception('HTTP ${res.statusCode}');
    } catch (_) {
      // Use first restaurant's menu as fallback
      return mockRestaurants.first.menu;
    }
  }

  Future<Map<String, dynamic>> makeOrder({
    required String apiKey,
    required String restaurantId,
    required List<Map<String, dynamic>> menuDTO,
  }) async {
    final uri = Uri.parse('$baseUrl/api/Order/$restaurantId/makeorder?apikey=$apiKey');
    final res = await _client.post(uri, body: jsonEncode({'menuDTO': menuDTO}), headers: {'Content-Type': 'application/json'});
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Order API failed ${res.statusCode}');
  }
}


