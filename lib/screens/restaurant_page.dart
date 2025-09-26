import 'package:flutter/material.dart';

class RestaurantPage extends StatelessWidget {
  const RestaurantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF256029),
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 36),
            const SizedBox(width: 12),
            const Text('Restaurants', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) => Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: ListTile(
            leading: const Icon(Icons.restaurant, color: Color(0xFF256029)),
            title: Text('Restaurant ${i + 1}'),
            subtitle: const Text('Cuisine • Location'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () {
              // TODO: Navigate to DeliveryDetailsScreen or restaurant details
            },
          ),
        ),
      ),
    );
  }
}
