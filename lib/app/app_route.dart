import 'package:flutter/material.dart';
import 'package:practicletestone/ui/splash/splash_view.dart';
import 'package:practicletestone/ui/login/login_view.dart';
import 'package:practicletestone/ui/no_internet/no_internet_view.dart';
import 'package:practicletestone/ui/product_details/product_details_view.dart';
import 'package:practicletestone/ui/saved_items/saved_items_view.dart';
import 'package:practicletestone/ui/dashboard/dashboard_view.dart';

class AppRoute {
  static const splash = "/splash";
  static const login = "/login";
  static const dashboard = "/dashboard";
  static const noInternet = "/no-internet";
  static const productDetails = "/product-details";
  static const savedItems = "/saved-items";

  static const initialRoute = splash;

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashView(),
        );
      case login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginView(),
        );
      case dashboard:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const DashboardView(),
        );
      case noInternet:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const NoInternetView(),
        );
      case productDetails:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProductDetailsView(),
        );
      case savedItems:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SavedItemsView(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}