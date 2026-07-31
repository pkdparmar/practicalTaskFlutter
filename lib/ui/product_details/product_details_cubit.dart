import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practicletestone/data/network/client/api_provider.dart';
import 'package:practicletestone/data/network/models/product_details_response_model.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ApiProvider _apiProvider;
  final int productId;

  ProductDetailsCubit(this._apiProvider, this.productId)
      : super(ProductDetailsState.initial()) {
    fetchProductDetails();
  }

  void updateActiveImageIndex(int index) {
    emit(state.copyWith(activeImageIndex: index));
  }

  Future<void> fetchProductDetails() async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await _apiProvider.get('/products/$productId');
      if (response.data != null) {
        final details = ProductDetailsResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        emit(state.copyWith(
          isLoading: false,
          productDetails: details,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'No data returned from details API.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
