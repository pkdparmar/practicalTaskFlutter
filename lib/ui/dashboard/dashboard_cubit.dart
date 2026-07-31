import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practicletestone/data/network/models/category_model.dart';
import 'package:practicletestone/data/network/models/product_model.dart';
import 'package:practicletestone/data/network/repository/dashboard_repository.dart';
import 'package:practicletestone/data/local/pref_helper.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repository;
  Timer? _debounceTimer;

  DashboardCubit(this._repository) : super(DashboardState.initial()) {
    fetchCategories();
  }

  final int categoriesPerPage = 10;
  final int productsPerPage = 10;

  void updateScrollOffset(double offset) {
    if (offset > 400) {
      if (!state.showScrollToTop) {
        emit(state.copyWith(showScrollToTop: true));
      }
    } else {
      if (state.showScrollToTop) {
        emit(state.copyWith(showScrollToTop: false));
      }
    }
  }

  void selectCategory(int index) {
    emit(state.copyWith(selectedCategoryIndex: index));
    if (state.categories.isNotEmpty && index < state.categories.length) {
      fetchProducts(categoryId: state.categories[index].id);
    }
  }

  void searchQueryChanged(String query) {
    emit(state.copyWith(searchQuery: query));
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      log('DEBUG: Debounced search query triggered: "$query"');
      final categoryId = state.categories.isNotEmpty ? state.categories[state.selectedCategoryIndex].id : 0;
      fetchProducts(categoryId: categoryId);
    });
  }

  Future<void> fetchCategories() async {
    emit(state.copyWith(
      isCategoriesLoading: true,
      categoryPage: 1,
      hasMoreCategories: true,
    ));
    try {
      final result = await _repository.getCategories(
        page: 1,
        perPage: categoriesPerPage,
      );
      final hasMore = result.length >= categoriesPerPage;
      emit(state.copyWith(
        categories: result,
        hasMoreCategories: hasMore,
        isCategoriesLoading: false,
      ));
      fetchProducts(categoryId: 0);
    } catch (e) {
      log('DEBUG: Categories error details: $e');
      emit(state.copyWith(
        isCategoriesLoading: false,
        categoriesError: e.toString(),
      ));
    }
  }

  Future<void> loadMoreCategories() async {
    if (state.isCategoriesLoading || state.isCategoriesLoadMoreLoading || !state.hasMoreCategories) {
      return;
    }
    emit(state.copyWith(isCategoriesLoadMoreLoading: true));
    try {
      final nextPage = state.categoryPage + 1;
      final result = await _repository.getCategories(
        page: nextPage,
        perPage: categoriesPerPage,
      );
      final hasMore = result.length >= categoriesPerPage;
      
      final updatedCategories = List<CategoryModel>.from(state.categories);
      
      if (updatedCategories.isNotEmpty && updatedCategories[0].id == 0) {
        final currentAll = updatedCategories[0];
        final newSum = result.fold<int>(currentAll.count, (sum, cat) => sum + cat.count);
        updatedCategories[0] = CategoryModel(
          id: 0,
          name: 'All',
          slug: 'all',
          parent: 0,
          description: currentAll.description,
          display: currentAll.display,
          menuOrder: currentAll.menuOrder,
          count: newSum,
          image: null,
        );
      }
      
      updatedCategories.addAll(result);

      emit(state.copyWith(
        categories: updatedCategories,
        categoryPage: nextPage,
        hasMoreCategories: hasMore,
        isCategoriesLoadMoreLoading: false,
      ));
    } catch (e) {
      log('DEBUG: Load more categories error: $e');
      emit(state.copyWith(isCategoriesLoadMoreLoading: false));
    }
  }

  Future<void> fetchProducts({int? categoryId}) async {
    emit(state.copyWith(
      isProductsLoading: true,
      productPage: 1,
      hasMoreProducts: true,
    ));
    try {
      final catId = categoryId ?? (state.categories.isNotEmpty ? state.categories[state.selectedCategoryIndex].id : 0);
      log('DEBUG: Fetching products for category ID $catId with search query: "${state.searchQuery}"');
      final result = await _repository.getProducts(
        categoryId: catId,
        page: 1,
        perPage: productsPerPage,
        search: state.searchQuery,
      );
      final hasMore = result.length >= productsPerPage;
      emit(state.copyWith(
        products: result,
        hasMoreProducts: hasMore,
        isProductsLoading: false,
      ));
    } catch (e) {
      log('DEBUG: Products error details: $e');
      emit(state.copyWith(
        isProductsLoading: false,
        productsError: e.toString(),
      ));
    }
  }

  Future<void> loadMoreProducts() async {
    if (state.isProductsLoading || state.isLoadMoreLoading || !state.hasMoreProducts) {
      return;
    }
    emit(state.copyWith(isLoadMoreLoading: true));
    try {
      final nextPage = state.productPage + 1;
      final categoryId = state.categories.isNotEmpty ? state.categories[state.selectedCategoryIndex].id : 0;
      log('DEBUG: Loading more products (page $nextPage) for category ID $categoryId with search query: "${state.searchQuery}"');
      
      final result = await _repository.getProducts(
        categoryId: categoryId,
        page: nextPage,
        perPage: productsPerPage,
        search: state.searchQuery,
      );
      
      final hasMore = result.length >= productsPerPage;
      final updatedProducts = List<ProductModel>.from(state.products)..addAll(result);

      emit(state.copyWith(
        products: updatedProducts,
        productPage: nextPage,
        hasMoreProducts: hasMore,
        isLoadMoreLoading: false,
      ));
    } catch (e) {
      log('DEBUG: Load more products error: $e');
      emit(state.copyWith(isLoadMoreLoading: false));
    }
  }

  Future<void> logout() async {
    await PrefHelper.setLoggedIn(false);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
