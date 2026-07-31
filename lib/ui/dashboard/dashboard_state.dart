import 'package:practicletestone/data/network/models/category_model.dart';
import 'package:practicletestone/data/network/models/product_model.dart';

class DashboardState {
  final List<CategoryModel> categories;
  final int selectedCategoryIndex;
  final List<ProductModel> products;

  final bool isCategoriesLoading;
  final bool isCategoriesLoadMoreLoading;
  final bool hasMoreCategories;
  final int categoryPage;

  final bool isProductsLoading;
  final bool isLoadMoreLoading;
  final bool hasMoreProducts;
  final int productPage;

  final String searchQuery;
  final bool showScrollToTop;

  final String? categoriesError;
  final String? productsError;

  DashboardState({
    required this.categories,
    required this.selectedCategoryIndex,
    required this.products,
    required this.isCategoriesLoading,
    required this.isCategoriesLoadMoreLoading,
    required this.hasMoreCategories,
    required this.categoryPage,
    required this.isProductsLoading,
    required this.isLoadMoreLoading,
    required this.hasMoreProducts,
    required this.productPage,
    required this.searchQuery,
    required this.showScrollToTop,
    this.categoriesError,
    this.productsError,
  });

  factory DashboardState.initial() => DashboardState(
        categories: [],
        selectedCategoryIndex: 0,
        products: [],
        isCategoriesLoading: false,
        isCategoriesLoadMoreLoading: false,
        hasMoreCategories: true,
        categoryPage: 1,
        isProductsLoading: false,
        isLoadMoreLoading: false,
        hasMoreProducts: true,
        productPage: 1,
        searchQuery: '',
        showScrollToTop: false,
      );

  DashboardState copyWith({
    List<CategoryModel>? categories,
    int? selectedCategoryIndex,
    List<ProductModel>? products,
    bool? isCategoriesLoading,
    bool? isCategoriesLoadMoreLoading,
    bool? hasMoreCategories,
    int? categoryPage,
    bool? isProductsLoading,
    bool? isLoadMoreLoading,
    bool? hasMoreProducts,
    int? productPage,
    String? searchQuery,
    bool? showScrollToTop,
    String? categoriesError,
    String? productsError,
  }) {
    return DashboardState(
      categories: categories ?? this.categories,
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      products: products ?? this.products,
      isCategoriesLoading: isCategoriesLoading ?? this.isCategoriesLoading,
      isCategoriesLoadMoreLoading: isCategoriesLoadMoreLoading ?? this.isCategoriesLoadMoreLoading,
      hasMoreCategories: hasMoreCategories ?? this.hasMoreCategories,
      categoryPage: categoryPage ?? this.categoryPage,
      isProductsLoading: isProductsLoading ?? this.isProductsLoading,
      isLoadMoreLoading: isLoadMoreLoading ?? this.isLoadMoreLoading,
      hasMoreProducts: hasMoreProducts ?? this.hasMoreProducts,
      productPage: productPage ?? this.productPage,
      searchQuery: searchQuery ?? this.searchQuery,
      showScrollToTop: showScrollToTop ?? this.showScrollToTop,
      categoriesError: categoriesError,
      productsError: productsError,
    );
  }
}
