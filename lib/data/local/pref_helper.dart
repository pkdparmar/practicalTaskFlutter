import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/models/product_model.dart';

class PrefHelper {
  static const String _keyIsLoggedIn = "is_logged_in";
  static const String _keySavedProducts = "saved_products_json_list";

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, value);
  }

  // Get saved products list from SharedPreferences
  static Future<List<ProductModel>> getSavedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_keySavedProducts) ?? [];
    try {
      return jsonList
          .map((item) => ProductModel.fromJson(json.decode(item) as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('DEBUG: Error parsing saved products from preferences: $e');
      return [];
    }
  }

  // Save/overwrite the saved products list in SharedPreferences
  static Future<void> saveProducts(List<ProductModel> products) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = products.map((p) => json.encode(p.toJson())).toList();
    await prefs.setStringList(_keySavedProducts, jsonList);
  }
}
