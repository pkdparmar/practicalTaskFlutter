import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practicletestone/app/app_colour.dart';
import 'package:practicletestone/ui/widgets/common_text_widget.dart';
import 'package:practicletestone/ui/widgets/common_html_widget.dart';
import 'package:practicletestone/ui/widgets/common_cache_image.dart';
import 'package:practicletestone/ui/widgets/shimmer_layouts.dart';
import 'package:practicletestone/data/network/models/product_model.dart';
import 'package:practicletestone/data/network/client/api_provider.dart';
import 'package:practicletestone/ui/saved_items/saved_items_cubit.dart';
import 'package:practicletestone/ui/saved_items/saved_items_state.dart';
import 'product_details_cubit.dart';
import 'product_details_state.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final initialProduct = ModalRoute.of(context)!.settings.arguments as ProductModel;
    final apiProvider = RepositoryProvider.of<ApiProvider>(context);

    return BlocProvider(
      create: (context) => ProductDetailsCubit(apiProvider, initialProduct.id),
      child: Scaffold(
        backgroundColor: AppColour.darkBackground2,
        extendBodyBehindAppBar: true,
        body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {
            final cubit = context.read<ProductDetailsCubit>();
            
            if (state.isLoading) {
              return Stack(
                children: [
                  Positioned.fill(child: const ProductDetailsShimmer()),
                  _buildFloatingBackButton(context),
                ],
              );
            }

            final product = state.productDetails;
            if (product == null) {
              return Stack(
                children: [
                  const Center(
                    child: CommonTextWidget(
                      text: 'Product details not available.',
                      color: AppColour.white,
                      fontSize: 16,
                    ),
                  ),
                  _buildFloatingBackButton(context),
                ],
              );
            }

            final hasImages = product.images.isNotEmpty;
            final hasSale = product.onSale && product.salePrice.isNotEmpty && product.regularPrice.isNotEmpty;
            final isOutOfStock = product.stockStatus == 'outofstock';

            return Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ─── Image Gallery ───────────────────────────────────
                        Stack(
                          children: [
                            SizedBox(
                              height: 380.h,
                              child: hasImages
                                  ? PageView.builder(
                                      onPageChanged: cubit.updateActiveImageIndex,
                                      itemCount: product.images.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () => _showImageViewerDialog(
                                            context,
                                            product.images.map((e) => e.src).toList(),
                                            state.activeImageIndex,
                                          ),
                                          child: CommonCacheImage(
                                            imageUrl: product.images[index].src,
                                            fit: BoxFit.cover,
                                            errorWidget: _buildPlaceholder(),
                                          ),
                                        );
                                      },
                                    )
                                  : _buildPlaceholder(),
                            ),
                            // Dot indicators
                            if (hasImages && product.images.length > 1)
                              Positioned(
                                bottom: 16.h,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    product.images.length,
                                    (index) {
                                      final isSelected = state.activeImageIndex == index;
                                      return AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                                        width: isSelected ? 18.w : 6.w,
                                        height: 6.h,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColour.primaryAccent
                                              : AppColour.white38,
                                          borderRadius: BorderRadius.circular(3.r),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),

                        // ─── Main Info ───────────────────────────────────────
                        Padding(
                          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Brand
                              if (product.brands.isNotEmpty) ...[
                                CommonTextWidget(
                                  text: product.brands[0].name.toUpperCase(),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColour.primaryAccent,
                                ),
                                SizedBox(height: 8.h),
                              ],
                              // Title
                              CommonTextWidget(
                                text: product.name,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColour.white,
                                height: 1.3,
                              ),
                              SizedBox(height: 16.h),

                              // Price
                              Row(
                                children: [
                                  if (hasSale) ...[
                                    CommonTextWidget(
                                      text: '₹${product.salePrice}',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColour.primaryAccent,
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      '₹${product.regularPrice}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColour.white38,
                                        decoration: TextDecoration.lineThrough,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6.r),
                                      ),
                                      child: const CommonTextWidget(
                                        text: 'ON SALE',
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ] else ...[
                                    CommonTextWidget(
                                      text:
                                          '₹${product.price.isNotEmpty ? product.price : '0'}',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColour.white,
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(height: 24.h),

                              // Categories
                              if (product.categories.isNotEmpty) ...[
                                const CommonTextWidget(
                                  text: 'Categories',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColour.white,
                                ),
                                SizedBox(height: 10.h),
                                Wrap(
                                  spacing: 8.w,
                                  runSpacing: 8.h,
                                  children: product.categories.map((cat) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 6.h),
                                      decoration: BoxDecoration(
                                        color: AppColour.white.withValues(alpha: 0.05),
                                        borderRadius: BorderRadius.circular(20.r),
                                        border: Border.all(
                                            color: AppColour.white.withValues(alpha: 0.08)),
                                      ),
                                      child: CommonTextWidget(
                                        text: cat.name,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColour.white70,
                                      ),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 24.h),
                              ],

                              // SKU & Stock grid
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(16.r),
                                      decoration: BoxDecoration(
                                        color: AppColour.white.withValues(alpha: 0.03),
                                        borderRadius: BorderRadius.circular(16.r),
                                        border: Border.all(
                                            color: AppColour.white.withValues(alpha: 0.06)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const CommonTextWidget(
                                            text: 'SKU Reference',
                                            fontSize: 11,
                                            color: AppColour.white38,
                                          ),
                                          SizedBox(height: 4.h),
                                          CommonTextWidget(
                                            text: product.sku.isNotEmpty
                                                ? product.sku
                                                : 'N/A',
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: AppColour.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(16.r),
                                      decoration: BoxDecoration(
                                        color: AppColour.white.withValues(alpha: 0.03),
                                        borderRadius: BorderRadius.circular(16.r),
                                        border: Border.all(
                                            color: AppColour.white.withValues(alpha: 0.06)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const CommonTextWidget(
                                            text: 'Availability',
                                            fontSize: 11,
                                            color: AppColour.white38,
                                          ),
                                          SizedBox(height: 4.h),
                                          Row(
                                            children: [
                                              Container(
                                                width: 8.r,
                                                height: 8.r,
                                                decoration: BoxDecoration(
                                                  color: isOutOfStock
                                                      ? Colors.red
                                                      : Colors.green,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              SizedBox(width: 6.w),
                                              CommonTextWidget(
                                                text: isOutOfStock
                                                    ? 'Out of Stock'
                                                    : 'In Stock',
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: isOutOfStock
                                                    ? Colors.red
                                                    : Colors.green,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),

                              // Description
                              if (product.description.isNotEmpty) ...[
                                const CommonTextWidget(
                                  text: 'About Product',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColour.white,
                                ),
                                SizedBox(height: 4.h),
                                CommonHtmlWidget(
                                  data: product.description,
                                ),
                                SizedBox(height: 24.h),
                              ],

                              // Attributes
                              if (product.attributes.isNotEmpty) ...[
                                const CommonTextWidget(
                                  text: 'Product Specifications',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColour.white,
                                ),
                                SizedBox(height: 16.h),
                                ...product.attributes.map((attr) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CommonTextWidget(
                                          text: attr.name,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColour.white70,
                                        ),
                                        SizedBox(height: 8.h),
                                        Wrap(
                                          spacing: 8.w,
                                          runSpacing: 8.h,
                                          children: attr.options.map((opt) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w, vertical: 6.h),
                                              decoration: BoxDecoration(
                                                color: AppColour.white
                                                    .withValues(alpha: 0.05),
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                border: Border.all(
                                                    color: AppColour.white
                                                        .withValues(alpha: 0.08)),
                                              ),
                                              child: CommonTextWidget(
                                                text: opt,
                                                fontSize: 12,
                                                color: AppColour.white70,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],

                              // Bottom breathing room
                              SizedBox(height: 16.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildFloatingBackButton(context),
                _buildFloatingSaveButton(context, initialProduct),
              ],
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {
            if (state.isLoading || state.productDetails == null) {
              return const SizedBox.shrink();
            }
            return _buildBottomNavigationBar(context);
          },
        ),
      ),
    );
  }

  Widget _buildFloatingBackButton(BuildContext context) {
    return Positioned(
      top: 0,
      left: 16.w,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: EdgeInsets.only(top: 8.h),
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColour.darkBackground1.withValues(alpha: 0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColour.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingSaveButton(BuildContext context, ProductModel initialProduct) {
    return Positioned(
      top: 0,
      right: 16.w,
      child: SafeArea(
        child: BlocBuilder<SavedItemsCubit, SavedItemsState>(
          builder: (context, savedState) {
            final isSaved = savedState.savedProductIds.contains(initialProduct.id);
            return GestureDetector(
              onTap: () => context.read<SavedItemsCubit>().toggleProductSave(initialProduct),
              child: Container(
                margin: EdgeInsets.only(top: 8.h),
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppColour.darkBackground1.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Icon(
                  isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isSaved ? Colors.red : AppColour.white,
                  size: 20,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColour.darkBackground1,
        border: Border(
          top: BorderSide(
            color: AppColour.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Add to Cart Button
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: CommonTextWidget(
                      text: 'Added to cart successfully!',
                      color: AppColour.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    backgroundColor: AppColour.white,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                side: const BorderSide(color: AppColour.primaryAccent, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, color: AppColour.primaryAccent, size: 20.r),
                  SizedBox(width: 8.w),
                  const CommonTextWidget(
                    text: 'Add to Cart',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColour.primaryAccent,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16.w),
          // Buy Now Button
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: CommonTextWidget(
                      text: 'Proceeding to checkout...',
                      color: AppColour.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    backgroundColor: AppColour.white,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColour.primaryAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: const CommonTextWidget(
                text: 'Buy Now',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageViewerDialog(
    BuildContext context,
    List<String> imageUrls,
    int initialIndex,
  ) {
    final dialogPage = ValueNotifier<int>(initialIndex);
    final pageController = PageController(initialPage: initialIndex);

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.95),
      builder: (context) {
        return Dialog.fullscreen(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              // Swipeable zoomable images
              PageView.builder(
                controller: pageController,
                onPageChanged: (i) => dialogPage.value = i,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 4.0,
                    clipBehavior: Clip.none,
                    child: Center(
                      child: CommonCacheImage(
                        imageUrl: imageUrls[index],
                        fit: BoxFit.contain,
                        errorWidget: _buildPlaceholder(),
                      ),
                    ),
                  );
                },
              ),

              // Dot indicators
              if (imageUrls.length > 1)
                Positioned(
                  bottom: 32,
                  left: 0,
                  right: 0,
                  child: ValueListenableBuilder<int>(
                    valueListenable: dialogPage,
                    builder: (context, activePage, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(imageUrls.length, (i) {
                          final isActive = i == activePage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isActive ? 18 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColour.primaryAccent
                                  : Colors.white38,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),

              // Image counter badge
              if (imageUrls.length > 1)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  right: 16,
                  child: ValueListenableBuilder<int>(
                    valueListenable: dialogPage,
                    builder: (context, activePage, _) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${activePage + 1} / ${imageUrls.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // Close button
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColour.white.withValues(alpha: 0.05),
      child: const Center(
        child: Icon(
          Icons.pets_rounded,
          color: AppColour.primaryAccent,
          size: 40,
        ),
      ),
    );
  }
}
