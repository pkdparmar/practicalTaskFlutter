import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practicletestone/app/app_colour.dart';
import 'package:practicletestone/ui/widgets/common_text_widget.dart';
import 'package:practicletestone/ui/widgets/product_card.dart';
import 'saved_items_cubit.dart';
import 'saved_items_state.dart';

class SavedItemsView extends StatelessWidget {
  const SavedItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColour.darkBackground2,
      appBar: AppBar(
        title: const CommonTextWidget(
          text: 'Saved Items',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColour.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColour.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Background gradients
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
          
          SafeArea(
            child: BlocBuilder<SavedItemsCubit, SavedItemsState>(
              builder: (context, state) {
                final savedProducts = state.savedProducts;

                if (savedProducts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border_rounded,
                            color: AppColour.white38,
                            size: 64.r,
                          ),
                          SizedBox(height: 16.h),
                          const CommonTextWidget(
                            text: 'No saved items yet',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColour.white,
                          ),
                          SizedBox(height: 8.h),
                          const CommonTextWidget(
                            text: 'Tap the heart icon on any product to save it here.',
                            fontSize: 13,
                            color: AppColour.white70,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  itemCount: savedProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.70,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(product: savedProducts[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
