import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practicletestone/app/app_colour.dart';
import 'package:practicletestone/app/app_route.dart';
import 'package:practicletestone/ui/widgets/common_text_widget.dart';
import 'splash_cubit.dart';
import 'splash_state.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is NavigateToDashboard) {
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.dashboard, (route) => false);
          } else if (state is NavigateToLogin) {
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.login, (route) => false);
          }
        },
        child: Scaffold(
          backgroundColor: AppColour.darkBackground2,
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColour.darkBackground1,
                      AppColour.darkBackground2,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -50.h,
                right: -50.w,
                child: Container(
                  width: 250.w,
                  height: 250.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColour.primaryAccent.withValues(alpha: 0.12),
                  ),
                ),
              ),
              Positioned(
                bottom: -80.h,
                left: -80.w,
                child: Container(
                  width: 300.w,
                  height: 300.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColour.secondaryAccent.withValues(alpha: 0.12),
                  ),
                ),
              ),
              // Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pets_rounded,
                      size: 100.r,
                      color: AppColour.primaryAccent,
                    ),
                    SizedBox(height: 24.h),
                    const CommonTextWidget(
                      text: "Paws & Care Portal",
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColour.white,
                      letterSpacing: 0.8,
                    ),
                    SizedBox(height: 12.h),
                    const CommonTextWidget(
                      text: 'Dog Supplements, Grooming & Wellness',
                      fontSize: 14,
                      color: AppColour.white70,
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
}
