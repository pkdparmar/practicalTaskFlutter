import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:practicletestone/app/app_colour.dart';
import 'package:practicletestone/ui/widgets/common_shimmer.dart';
import 'package:practicletestone/ui/widgets/search_field_widget.dart';

class CategoryListShimmer extends StatelessWidget {
  const CategoryListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonShimmer.rectangular(height: 24.h, width: 180.w),
          SizedBox(height: 16.h),
          SizedBox(
            height: 96.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 75.w,
                  margin: EdgeInsets.only(right: 12.w),
                  child: Column(
                    children: [
                      CommonShimmer.circular(width: 58.r, height: 58.r),
                      SizedBox(height: 10.h),
                      CommonShimmer.rectangular(height: 12.h, width: 50.w),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductGridShimmer extends StatelessWidget {
  const ProductGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.70,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColour.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColour.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CommonShimmer.rectangular(height: double.infinity),
              ),
              Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonShimmer.rectangular(height: 10.h, width: 60.w),
                    SizedBox(height: 6.h),
                    CommonShimmer.rectangular(
                      height: 14.h,
                      width: double.infinity,
                    ),
                    SizedBox(height: 4.h),
                    CommonShimmer.rectangular(height: 14.h, width: 100.w),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonShimmer.rectangular(height: 16.h, width: 50.w),
                        CommonShimmer.rectangular(height: 12.h, width: 30.w),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Area Shimmer
          CommonShimmer.rectangular(height: 380.h),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand Shimmer
                CommonShimmer.rectangular(height: 12.h, width: 80.w),
                SizedBox(height: 8.h),
                // Title Shimmer
                CommonShimmer.rectangular(height: 28.h, width: 220.w),
                SizedBox(height: 8.h),
                CommonShimmer.rectangular(height: 28.h, width: 140.w),
                SizedBox(height: 24.h),
                // Price Shimmer
                CommonShimmer.rectangular(height: 32.h, width: 100.w),
                SizedBox(height: 24.h),
                // Categories Title Shimmer
                CommonShimmer.rectangular(height: 16.h, width: 80.w),
                SizedBox(height: 12.h),
                // Categories Row Shimmer
                Row(
                  children: [
                    CommonShimmer.rectangular(height: 32.h, width: 90.w),
                    SizedBox(width: 8.w),
                    CommonShimmer.rectangular(height: 32.h, width: 110.w),
                  ],
                ),
                SizedBox(height: 24.h),
                // SKU / Stock grid Shimmer
                Row(
                  children: [
                    Expanded(child: CommonShimmer.rectangular(height: 70.h)),
                    SizedBox(width: 16.w),
                    Expanded(child: CommonShimmer.rectangular(height: 70.h)),
                  ],
                ),
                SizedBox(height: 24.h),
                // About Product Shimmer
                CommonShimmer.rectangular(height: 18.h, width: 120.w),
                SizedBox(height: 12.h),
                CommonShimmer.rectangular(height: 14.h, width: double.infinity),
                SizedBox(height: 8.h),
                CommonShimmer.rectangular(height: 14.h, width: double.infinity),
                SizedBox(height: 8.h),
                CommonShimmer.rectangular(height: 14.h, width: 180.w),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar (not shimmered)
          const SearchFieldWidget(),
          SizedBox(height: 24.h),
          
          // Category title shimmer
          CommonShimmer.rectangular(height: 18.h, width: 140.w),
          SizedBox(height: 16.h),
          
          // Category horizontal items
          SizedBox(
            height: 96.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 75.w,
                  margin: EdgeInsets.only(right: 12.w),
                  child: Column(
                    children: [
                      CommonShimmer.circular(width: 58.r, height: 58.r),
                      SizedBox(height: 10.h),
                      CommonShimmer.rectangular(height: 12.h, width: 50.w),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 15.h),
          
          // Products header shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonShimmer.rectangular(height: 18.h, width: 100.w),
              CommonShimmer.rectangular(height: 14.h, width: 80.w),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Products grid shimmer
          const ProductGridShimmer(),
        ],
      ),
    );
  }
}
