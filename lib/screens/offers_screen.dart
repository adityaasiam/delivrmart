// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cards = [
      _Offer('Buy 1 Get 1', 'On selected pizzas', Colors.deepPurple),
      _Offer('Flat 50% Off', 'Desserts today', Colors.teal),
      _Offer('Party for Two', 'Use code PARTY300', Colors.indigo),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Offers')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (c, i) => _OfferCard(offer: cards[i]),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: cards.length,
      ),
    );
  }
}

class _Offer {
  final String title;
  final String subtitle;
  final Color color;
  _Offer(this.title, this.subtitle, this.color);
}

class _OfferCard extends StatelessWidget {
  final _Offer offer;
  const _OfferCard({required this.offer});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: offer.color.withOpacity(.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                'https://images.unsplash.com/photo-1543353071-10c8ba85a904?w=1200&q=60&fit=crop',
                fit: BoxFit.cover,
                color: offer.color.withOpacity(.25),
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(offer.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 6),
                Text(offer.subtitle, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          )
        ],
      ),
    );
  }
}



