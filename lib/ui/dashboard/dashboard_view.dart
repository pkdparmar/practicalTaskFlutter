import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practicletestone/app/app_colour.dart';
import 'package:practicletestone/app/app_route.dart';
import 'package:practicletestone/ui/widgets/shimmer_layouts.dart';
import 'package:practicletestone/ui/widgets/common_text_widget.dart';
import 'package:practicletestone/ui/widgets/product_card.dart';
import 'package:practicletestone/ui/widgets/common_cache_image.dart';
import 'package:practicletestone/ui/widgets/search_field_widget.dart';
import 'package:practicletestone/ui/saved_items/saved_items_cubit.dart';
import 'package:practicletestone/ui/saved_items/saved_items_state.dart';
import 'package:practicletestone/data/network/repository/dashboard_repository.dart';
import 'dashboard_cubit.dart';
import 'dashboard_state.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late final ScrollController _scrollController;
  late final ScrollController _categoryScrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _categoryScrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  void _setupScrollListeners(BuildContext context, DashboardCubit cubit) {
    _scrollController.addListener(() {
      cubit.updateScrollOffset(_scrollController.offset);
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        cubit.loadMoreProducts();
      }
    });

    _categoryScrollController.addListener(() {
      if (_categoryScrollController.position.pixels >= _categoryScrollController.position.maxScrollExtent - 100) {
        cubit.loadMoreCategories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(
        RepositoryProvider.of<DashboardRepository>(context),
      ),
      child: Builder(
        builder: (context) {
          final cubit = context.read<DashboardCubit>();
          _setupScrollListeners(context, cubit);

          return Scaffold(
            backgroundColor: AppColour.darkBackground2,
            appBar: AppBar(
              title: const CommonTextWidget(
                text: 'Paws & Care',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColour.white,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu_rounded, color: AppColour.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
            drawer: _buildDrawer(context, cubit),
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColour.darkBackground1, AppColour.darkBackground2],
                    ),
                  ),
                ),
                Positioned(
                  top: -20.h,
                  left: -20.w,
                  child: Container(
                    width: 200.w,
                    height: 200.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColour.primaryAccent.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50.h,
                  right: -50.w,
                  child: Container(
                    width: 250.w,
                    height: 250.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColour.secondaryAccent.withValues(alpha: 0.04),
                    ),
                  ),
                ),
                SafeArea(
                  child: BlocBuilder<DashboardCubit, DashboardState>(
                    builder: (context, state) {
                      if (state.isCategoriesLoading && state.categories.isEmpty) {
                        return const DashboardShimmer();
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          await cubit.fetchCategories();
                        },
                        color: AppColour.primaryAccent,
                        backgroundColor: AppColour.darkBackground1,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 16.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Padding(
                        padding: EdgeInsets.only(bottom: 24.h),
                        child: SearchFieldWidget(),
                      ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const CommonTextWidget(
                                    text: 'Product Categories',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColour.white,
                                  ),
                                  CommonTextWidget(
                                    text: '${state.categories.length} Categories',
                                    fontSize: 13,
                                    color: AppColour.primaryAccent,
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              if (state.categories.isEmpty)
                                const Center(
                                  child: CommonTextWidget(
                                    text: 'No categories available.',
                                    color: AppColour.white70,
                                  ),
                                )
                              else ...[
                                SizedBox(
                                  height: 100.h,
                                  child: ListView.builder(
                                    controller: _categoryScrollController,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.categories.length + (state.isCategoriesLoadMoreLoading ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index >= state.categories.length) {
                                        return Container(
                                          width: 75.w,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(right: 12.w),
                                          child: Center(
                                            child: SizedBox(
                                              width: 20.h,
                                              height: 20.h,
                                              child: const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  AppColour.primaryAccent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      final category = state.categories[index];
                                      final hasImage = category.image != null && category.image!.src.isNotEmpty;
                                      final isSelected = state.selectedCategoryIndex == index;

                                      return GestureDetector(
                                        onTap: () => cubit.selectCategory(index),
                                        child: Container(
                                          width: 75.w,
                                          margin: EdgeInsets.only(right: 8.w),
                                          child: Column(
                                            children: [
                                              AnimatedContainer(
                                                duration: const Duration(milliseconds: 200),
                                                width: 58.r,
                                                height: 58.r,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? AppColour.primaryAccent
                                                        : AppColour.white.withValues(alpha: 0.1),
                                                    width: isSelected ? 3 : 1,
                                                  ),
                                                  boxShadow: isSelected
                                                      ? [
                                                          BoxShadow(
                                                            color: AppColour.primaryAccent.withValues(alpha: 0.3),
                                                            blurRadius: 8,
                                                            spreadRadius: 1,
                                                          ),
                                                        ]
                                                      : null,
                                                ),
                                                child: ClipOval(
                                                  child: hasImage
                                                      ? CommonCacheImage(
                                                          imageUrl: category.image!.src,
                                                          fit: BoxFit.cover,
                                                          errorWidget: _buildCirclePlaceholder(),
                                                        )
                                                      : _buildCirclePlaceholder(),
                                                ),
                                              ),
                                              SizedBox(height: 8.h),
                                              CommonTextWidget(
                                                text: category.name,
                                                fontSize: 11,
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                color: isSelected ? AppColour.primaryAccent : AppColour.white70,
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonTextWidget(
                                      text: (state.categories.isNotEmpty && state.selectedCategoryIndex < state.categories.length)
                                          ? state.categories[state.selectedCategoryIndex].name
                                          : 'Products',
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColour.white,
                                    ),
                                    CommonTextWidget(
                                      text: '${state.products.length} Products',
                                      fontSize: 13,
                                      color: AppColour.primaryAccent,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                Builder(
                                  builder: (context) {
                                    if (state.isProductsLoading) {
                                      return const ProductGridShimmer();
                                    }
                                    if (state.products.isEmpty) {
                                      return Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(vertical: 40.h),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.shopping_bag_outlined,
                                              size: 48.r,
                                              color: AppColour.white38,
                                            ),
                                            SizedBox(height: 12.h),
                                            const CommonTextWidget(
                                              text: 'No products found in this category.',
                                              fontSize: 14,
                                              color: AppColour.white70,
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: state.products.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 16.w,
                                        mainAxisSpacing: 16.h,
                                        childAspectRatio: 0.70,
                                      ),
                                      itemBuilder: (context, index) {
                                        final product = state.products[index];
                                        return ProductCard(product: product);
                                      },
                                    );
                                  },
                                ),
                                SizedBox(height: 16.h),
                                Builder(
                                  builder: (context) {
                                    if (state.isLoadMoreLoading) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(vertical: 16.h),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              AppColour.primaryAccent,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    if (!state.hasMoreProducts && state.products.isNotEmpty) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(vertical: 16.h),
                                        child: const Center(
                                          child: CommonTextWidget(
                                            text: 'No more products to show.',
                                            fontSize: 12,
                                            color: AppColour.white38,
                                          ),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                if (!state.showScrollToTop) {
                  return const SizedBox.shrink();
                }
                return FloatingActionButton(
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  backgroundColor: AppColour.primaryAccent,
                  mini: true,
                  elevation: 4,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.arrow_upward_rounded, color: Colors.white),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCirclePlaceholder() {
    return Container(
      color: AppColour.white.withValues(alpha: 0.05),
      child: const Center(
        child: Icon(
          Icons.pets_rounded,
          color: AppColour.primaryAccent,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, DashboardCubit cubit) {
    return Drawer(
      backgroundColor: AppColour.darkBackground2,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Section
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: AppColour.darkBackground1,
                border: Border(
                  bottom: BorderSide(
                    color: AppColour.white.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50.r,
                    height: 50.r,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColour.primaryAccent,
                          AppColour.secondaryAccent,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: CommonTextWidget(
                        text: 'JD',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CommonTextWidget(
                          text: 'John Doe',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColour.white,
                        ),
                        SizedBox(height: 4.h),
                        const CommonTextWidget(
                          text: 'john.doe@example.com',
                          fontSize: 12,
                          color: AppColour.white70,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColour.white.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColour.white.withValues(alpha: 0.06),
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 4.h,
                  ),
                  leading: const Icon(
                    Icons.favorite_rounded,
                    color: AppColour.primaryAccent,
                  ),
                  title: const CommonTextWidget(
                    text: 'Saved Items',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColour.white,
                  ),
                  trailing: BlocBuilder<SavedItemsCubit, SavedItemsState>(
                    builder: (context, savedState) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColour.primaryAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: CommonTextWidget(
                          text: '${savedState.savedProductIds.length}',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColour.primaryAccent,
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).pop(); // Close drawer
                    Navigator.of(context).pushNamed(AppRoute.savedItems);
                  },
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColour.darkBackground1,
                border: Border(
                  top: BorderSide(
                    color: AppColour.white.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close drawer
                  cubit.logout().then((_) {
                    Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.login, (route) => false);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColour.redAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const CommonTextWidget(
                  text: 'Logout',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
