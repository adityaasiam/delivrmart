// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class RestaurantHomeScreen extends StatelessWidget {
  static const routeName = '/home-rich';
  const RestaurantHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final text = theme.textTheme;
    final width = MediaQuery.of(context).size.width;
    final gridCrossAxisCount = width > 600 ? 4 : width > 400 ? 3 : 2;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header(text: text)),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),
            SliverToBoxAdapter(child: _DeliveryOptionsRow()),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),
            SliverToBoxAdapter(child: _SearchBar()),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(child: _DealsBanner(isDark: isDark)),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('Popular restaurants', style: text.titleLarge),
                    const Spacer(),
                    TextButton(onPressed: () {}, child: const Text('See all')),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCrossAxisCount,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _RestaurantCard(index: index),
                  childCount: 8,
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(child: _FestiveStrip()),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'My Profile'),
          NavigationDestination(icon: Icon(Icons.local_offer_outlined), selectedIcon: Icon(Icons.local_offer), label: 'Multi-Resto'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), selectedIcon: Icon(Icons.shopping_cart), label: 'Cart'),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final TextTheme text;
  const _Header({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_on, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_formatTimeOfDay(TimeOfDay.now()), style: text.labelLarge?.copyWith(color: Colors.grey)),
                Text('Crossings Republik', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                Text('Supertech Livingston, Dund...', style: text.bodySmall),
              ],
            ),
          ),
          Row(children: const [
            Icon(Icons.signal_cellular_alt, size: 18),
            SizedBox(width: 8),
            Icon(Icons.wifi, size: 18),
            SizedBox(width: 8),
            Icon(Icons.battery_full, size: 18),
          ])
        ],
      ),
    );
  }

  static String _formatTimeOfDay(TimeOfDay tod) {
    final h = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final m = tod.minute.toString().padLeft(2, '0');
    final ampm = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }
}

class _DeliveryOptionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget chip(IconData icon, String label) => Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(icon),
            label: Text(label, overflow: TextOverflow.ellipsis),
          ),
        );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        chip(Icons.flash_on, 'Get in 15 min'),
        const SizedBox(width: 8),
        chip(Icons.pedal_bike, 'Get'),
        const SizedBox(width: 8),
        chip(Icons.schedule, 'in ~35 mins'),
        const SizedBox(width: 8),
        chip(Icons.train, 'Food On Train'),
      ]),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search for restaurants, cuisines and more...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}

class _DealsBanner extends StatelessWidget {
  final bool isDark;
  const _DealsBanner({required this.isDark});
  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF311B92) : const Color(0xFFEDE7F6);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Everyday CRAZY DEALS', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => _DealCard(index: index),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: 4,
            ),
          ),
        ],
      ),
    );
  }
}

class _DealCard extends StatelessWidget {
  final int index;
  const _DealCard({required this.index});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=800&q=60&fit=crop',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(8)),
              child: const Text('OFFER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Buy 1 Get 1 Free', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(height: 2),
                Text('LunchBox', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final int index;
  const _RestaurantCard({required this.index});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              'https://images.unsplash.com/photo-1604908814110-7c4b9c4640b0?w=1200&q=60&fit=crop',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Faasos', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(height: 6),
                Text('50% off upto ₹ 500', style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FestiveStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0B2),
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1478144592103-25e218a04891?w=1600&q=60&fit=crop'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Color(0x66000000), BlendMode.darken),
        ),
      ),
      child: Row(
        children: const [
          Icon(Icons.celebration, color: Colors.white),
          SizedBox(width: 8),
          Expanded(
            child: Text('Navratri Bites - Festive offers up to 50%',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}



