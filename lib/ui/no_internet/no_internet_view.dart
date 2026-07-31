import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practicletestone/app/app_colour.dart';
import 'package:practicletestone/ui/widgets/common_app_button.dart';
import 'package:practicletestone/ui/widgets/common_text_widget.dart';
import 'no_internet_cubit.dart';
import 'no_internet_state.dart';

class NoInternetView extends StatelessWidget {
  const NoInternetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColour.darkBackground2,
      body: BlocProvider(
        create: (_) => NoInternetCubit(),
        child: BlocConsumer<NoInternetCubit, NoInternetState>(
          listener: (context, state) {
            if (state.isSuccess) {
              Navigator.of(context).pop(true);
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: CommonTextWidget(
                    text: state.errorMessage!,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  backgroundColor: Colors.redAccent,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<NoInternetCubit>();
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(flex: 2),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(32.r),
                        decoration: BoxDecoration(
                          color: AppColour.primaryAccent.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.wifi_off_rounded,
                          size: 80.r,
                          color: AppColour.primaryAccent,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    const CommonTextWidget(
                      text: 'Connection Lost',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                      color: AppColour.white,
                    ),
                    SizedBox(height: 16.h),
                    const CommonTextWidget(
                      text: 'Please check your internet connection and try again to restore your Paws & Care session.',
                      fontSize: 14,
                      textAlign: TextAlign.center,
                      color: AppColour.white70,
                      height: 1.5,
                    ),
                    const Spacer(flex: 2),
                    CommonAppButton(
                      text: state.isChecking ? 'Checking...' : 'Try Again',
                      onPressed: state.isChecking ? null : cubit.checkConnection,
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
