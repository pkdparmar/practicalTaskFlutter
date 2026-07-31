import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practicletestone/data/network/models/product_model.dart';
import 'package:practicletestone/data/local/pref_helper.dart';
import 'saved_items_state.dart';

class SavedItemsCubit extends Cubit<SavedItemsState> {
  SavedItemsCubit() : super(SavedItemsState.initial()) {
    loadSavedProducts();
  }

  Future<void> loadSavedProducts() async {
    final list = await PrefHelper.getSavedProducts();
    final ids = list.map((e) => e.id).toSet();
    emit(SavedItemsState(savedProducts: list, savedProductIds: ids));
  }

  Future<void> toggleProductSave(ProductModel product) async {
    final updatedList = List<ProductModel>.from(state.savedProducts);
    final updatedIds = Set<int>.from(state.savedProductIds);

    if (updatedIds.contains(product.id)) {
      updatedIds.remove(product.id);
      updatedList.removeWhere((e) => e.id == product.id);
    } else {
      updatedIds.add(product.id);
      updatedList.add(product);
    }

    emit(state.copyWith(
      savedProducts: updatedList,
      savedProductIds: updatedIds,
    ));

    await PrefHelper.saveProducts(updatedList);
  }
}
