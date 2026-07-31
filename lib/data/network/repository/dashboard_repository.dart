import 'package:practicletestone/data/network/client/api_client.dart';
import 'package:practicletestone/data/network/client/api_provider.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';


class DashboardRepository {
  final ApiProvider _apiProvider;

  DashboardRepository(this._apiProvider);

  Future<List<CategoryModel>> getCategories({int? page, int? perPage}) async {
    final queryParams = <String, dynamic>{};
    if (page != null) {
      queryParams['page'] = page;
    }
    if (perPage != null) {
      queryParams['per_page'] = perPage;
    }
    final response = await _apiProvider.get(
      ApiClient.category,
      queryParameters: queryParams,
    );
    if (response.data is List) {
      final list = response.data as List;
      return list.map((json) => CategoryModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<List<ProductModel>> getProducts({int? categoryId, int? page, int? perPage, String? search}) async {
    final queryParams = <String, dynamic>{};
    if (categoryId != null && categoryId != 0) {
      queryParams['category'] = categoryId;
    }
    if (page != null) {
      queryParams['page'] = page;
    }
    if (perPage != null) {
      queryParams['per_page'] = perPage;
    }
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }
    final response = await _apiProvider.get(
      ApiClient.products,
      queryParameters: queryParams,
    );
    if (response.data is List) {
      final list = response.data as List;
      return list.map((json) => ProductModel.fromJson(json as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
