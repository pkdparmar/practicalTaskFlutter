import 'package:practicletestone/data/network/models/product_details_response_model.dart';

class ProductDetailsState {
  final bool isLoading;
  final ProductDetailsResponseModel? productDetails;
  final int activeImageIndex;
  final String? errorMessage;

  ProductDetailsState({
    required this.isLoading,
    this.productDetails,
    required this.activeImageIndex,
    this.errorMessage,
  });

  factory ProductDetailsState.initial() => ProductDetailsState(
        isLoading: true,
        activeImageIndex: 0,
      );

  ProductDetailsState copyWith({
    bool? isLoading,
    ProductDetailsResponseModel? productDetails,
    int? activeImageIndex,
    String? errorMessage,
  }) {
    return ProductDetailsState(
      isLoading: isLoading ?? this.isLoading,
      productDetails: productDetails ?? this.productDetails,
      activeImageIndex: activeImageIndex ?? this.activeImageIndex,
      errorMessage: errorMessage,
    );
  }
}
