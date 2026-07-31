import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practicletestone/app/app_colour.dart';
import 'package:practicletestone/app/app_route.dart';
import 'package:practicletestone/ui/widgets/common_text_widget.dart';
import 'package:practicletestone/ui/widgets/common_cache_image.dart';
import 'package:practicletestone/ui/saved_items/saved_items_cubit.dart';
import 'package:practicletestone/ui/saved_items/saved_items_state.dart';
import '../../data/network/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final hasImage = product.images.isNotEmpty && product.images[0].src.isNotEmpty;
    final hasCategory = product.categories.isNotEmpty;
    final hasBrand = product.brands.isNotEmpty;
    final isOutOfStock = product.stockStatus == 'outofstock';
    final hasSale = product.onSale && product.salePrice.isNotEmpty && product.regularPrice.isNotEmpty;

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AppRoute.productDetails, arguments: product),
      child: Container(
        decoration: BoxDecoration(
          color: AppColour.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColour.white.withValues(alpha: 0.08)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Area
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: hasImage
                          ? CommonCacheImage(
                              imageUrl: product.images[0].src,
                              fit: BoxFit.cover,
                              errorWidget: _buildPlaceholder(),
                            )
                          : _buildPlaceholder(),
                    ),
                    if (isOutOfStock)
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: const CommonTextWidget(
                            text: 'OUT OF STOCK',
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )
                    else if (product.onSale)
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: const CommonTextWidget(
                            text: 'SALE',
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    // Floating Save Button
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: GestureDetector(
                        onTap: () {
                          context.read<SavedItemsCubit>().toggleProductSave(product).then((_) {
                            final isNowSaved = context.read<SavedItemsCubit>().state.savedProductIds.contains(product.id);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: CommonTextWidget(
                                  text: isNowSaved ? 'Product saved successfully!' : 'Product removed from saved items',
                                  color: AppColour.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                backgroundColor: AppColour.white,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: AppColour.darkBackground1.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: BlocBuilder<SavedItemsCubit, SavedItemsState>(
                            builder: (context, savedState) {
                              final isSaved = savedState.savedProductIds.contains(product.id);
                              return Icon(
                                isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                color: isSaved ? Colors.red : AppColour.white,
                                size: 16.r,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Details Area
              Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Header
                    if (hasCategory) ...[
                      CommonTextWidget(
                        text: product.categories[0].name.toUpperCase(),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColour.white70,
                      ),
                      SizedBox(height: 2.h),
                    ],
                    // Brand Indicator
                    if (hasBrand) ...[
                      CommonTextWidget(
                        text: product.brands[0].name.toUpperCase(),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColour.primaryAccent,
                      ),
                      SizedBox(height: 4.h),
                    ],
                    // Title
                    CommonTextWidget(
                      text: product.name,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColour.white,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      height: 1.3,
                    ),
                    SizedBox(height: 12.h),
                    // Price Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (hasSale) ...[
                              Text(
                                '₹${product.regularPrice}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColour.white38,
                                  decoration: TextDecoration.lineThrough,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 2.h),
                              CommonTextWidget(
                                text: '₹${product.salePrice}',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColour.primaryAccent,
                              ),
                            ] else ...[
                              CommonTextWidget(
                                text: '₹${product.price.isNotEmpty ? product.price : '0'}',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColour.white,
                              ),
                            ],
                          ],
                        ),
                        // Mini Rating Badge
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColour.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star_rounded, color: Colors.amber, size: 10.r),
                              SizedBox(width: 2.w),
                              CommonTextWidget(
                                text: product.averageRating.isNotEmpty ? product.averageRating : '0.0',
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: AppColour.white70,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColour.white.withValues(alpha: 0.05),
      child: const Center(
        child: Icon(
          Icons.pets_rounded,
          color: AppColour.primaryAccent,
          size: 28,
        ),
      ),
    );
  }
}
