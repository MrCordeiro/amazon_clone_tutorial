import 'package:amazon_clone_tutorial/common/widgets/bottom_bar.dart';
import 'package:amazon_clone_tutorial/features/address/screens/address_screen.dart';
import 'package:amazon_clone_tutorial/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone_tutorial/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone_tutorial/features/cart/screens/cart_screen.dart';
import 'package:amazon_clone_tutorial/features/home/screens/category_deals_screen.dart';
import 'package:amazon_clone_tutorial/features/home/screens/home_screen.dart';
import 'package:amazon_clone_tutorial/features/order_detail/screens/order_detail_screen.dart';
import 'package:amazon_clone_tutorial/features/product_detail/screens/product_detail_screen.dart';
import 'package:amazon_clone_tutorial/features/search/screens/search_screen.dart';
import 'package:amazon_clone_tutorial/models/order.dart';
import 'package:amazon_clone_tutorial/models/product.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const AuthScreen(),
        settings: settings,
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const HomeScreen(),
        settings: settings,
      );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const AddProductScreen(),
        settings: settings,
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        builder: (_) => const BottomBar(),
        settings: settings,
      );
    case CategoryDealsScreen.routeName:
      var category = settings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => CategoryDealsScreen(category: category),
        settings: settings,
      );
    case SearchScreen.routeName:
      var searchQuery = settings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => SearchScreen(searchQuery: searchQuery),
        settings: settings,
      );
    case ProductDetailScreen.routeName:
      var product = settings.arguments as Product;
      return MaterialPageRoute(
        builder: (_) => ProductDetailScreen(product: product),
        settings: settings,
      );
    case CartScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const CartScreen(),
        settings: settings,
      );
    case AddressScreen.routeName:
      var totalAmount = settings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => AddressScreen(totalAmount: totalAmount),
        settings: settings,
      );
    case OrderDetailScreen.routeName:
      var order = settings.arguments as Order;
      return MaterialPageRoute(
        builder: (_) => OrderDetailScreen(order: order),
        settings: settings,
      );
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('404 Page not found'),
          ),
        ),
      );
  }
}
