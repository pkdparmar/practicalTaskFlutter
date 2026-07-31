import 'package:practicletestone/data/network/models/product_model.dart';

class SavedItemsState {
  final List<ProductModel> savedProducts;
  final Set<int> savedProductIds;

  SavedItemsState({
    required this.savedProducts,
    required this.savedProductIds,
  });

  factory SavedItemsState.initial() => SavedItemsState(
        savedProducts: [],
        savedProductIds: {},
      );

  SavedItemsState copyWith({
    List<ProductModel>? savedProducts,
    Set<int>? savedProductIds,
  }) {
    return SavedItemsState(
      savedProducts: savedProducts ?? this.savedProducts,
      savedProductIds: savedProductIds ?? this.savedProductIds,
    );
  }
}
