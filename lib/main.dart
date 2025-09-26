import 'package:delivr_mart/screens/get_started_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'screens/login_signup_page.dart';
import 'screens/restaurant_list_screen.dart';
import 'screens/search_screen.dart';
import 'screens/offers_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/restaurant_home_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/delivery_details_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/order_confirmation_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth_bloc.dart';
import 'blocs/cart_bloc.dart';
import 'blocs/order_bloc.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const DelivrMartApp());
}

class DelivrMartApp extends StatelessWidget {
  const DelivrMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => CartBloc()),
        BlocProvider(create: (_) => OrderBloc()),
      ],
      child: MaterialApp(
        title: 'DelivrMart',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.orange,
          scaffoldBackgroundColor: const Color(0xFFF8F0E8),
          dividerTheme: DividerThemeData(color: Colors.brown.shade200, thickness: 1),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (_) => const SplashScreen(),
          '/get-started': (_) => GetStartedPage(),
          '/login-signup': (_) => LoginSignupPage(),
          RestaurantListScreen.routeName: (_) => const RestaurantListScreen(),
          '/offers': (_) => const OffersScreen(),
          '/profile': (_) => const ProfileScreen(),
          '/root': (_) => const _RootScaffold(),
          RestaurantHomeScreen.routeName: (_) => const RestaurantHomeScreen(),
          MenuScreen.routeName: (_) => const MenuScreen(),
          CartScreen.routeName: (_) => const CartScreen(),
          DeliveryDetailsScreen.routeName: (_) => const DeliveryDetailsScreen(),
          PaymentScreen.routeName: (_) => const PaymentScreen(),
          OrderConfirmationScreen.routeName: (_) => const OrderConfirmationScreen(),
        },
      ),
    );
  }
}

class _RootScaffold extends StatefulWidget {
  const _RootScaffold();
  @override
  State<_RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<_RootScaffold> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    // Keep existing pages unchanged; only the root scaffolding/wrapping changes.
    final pages = [
      // Restaurants tab uses the existing RestaurantListScreen which already contains its own Scaffold
      const RestaurantListScreen(),
      // Search tab
      const SearchScreen(),
      // Cart tab uses existing CartScreen
      const CartScreen(),
      // Profile placeholder uses existing ProfileScreen
      const ProfileScreen(),
    ];


    return Scaffold(
      // The IndexedStack preserves state for each tab's widget tree. Each page manages its own Scaffold.
      body: IndexedStack(
        index: _index,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        backgroundColor: const Color(0xFFF8F0E8),
        selectedItemColor: Colors.brown[700],
        unselectedItemColor: Colors.brown[300],
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu_outlined), label: 'Restaurants'),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
