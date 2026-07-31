import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practicletestone/app/app_class.dart';
import 'package:practicletestone/app/app_colour.dart';
import 'package:practicletestone/app/app_route.dart';
import 'package:practicletestone/ui/widgets/common_app_button.dart';
import 'package:practicletestone/ui/widgets/common_text_field.dart';
import 'package:practicletestone/ui/widgets/common_text_widget.dart';
import 'login_cubit.dart';
import 'login_state.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        body: BlocProvider(
          create: (_) => LoginCubit(),
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const CommonTextWidget(
                      text: 'Welcome back!',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    backgroundColor: Colors.green.withValues(alpha: 0.8),
                    duration: const Duration(seconds: 2),
                  ),
                );
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.dashboard, (route) => false);
              } else if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: CommonTextWidget(
                      text: state.errorMessage!,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    backgroundColor: Colors.red.withValues(alpha: 0.8),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<LoginCubit>();
              return Stack(
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
                  // Soft glowing background circles
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
                  SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Icon(
                              Icons.pets_rounded,
                              size: 80.r,
                              color: AppColour.primaryAccent,
                            ),
                            SizedBox(height: 16.h),
                            const CommonTextWidget(
                              text: 'Paws & Care Portal',
                              textAlign: TextAlign.center,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColour.white,
                              letterSpacing: 0.5,
                            ),
                            SizedBox(height: 8.h),
                            const CommonTextWidget(
                              text: 'Dog Supplements, Grooming & Wellness',
                              textAlign: TextAlign.center,
                              fontSize: 14,
                              color: AppColour.white70,
                            ),
                            SizedBox(height: 40.h),
                            Form(
                              key: cubit.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  CommonTextField(
                                    controller: cubit.emailController,
                                    validator: cubit.validateEmail,
                                    labelText: 'Email Address',
                                    hintText: 'Enter your email',
                                    keyboardType: TextInputType.emailAddress,
                                    prefixIcon: const Icon(Icons.email_outlined, color: AppColour.primaryAccent),
                                  ),
                                  SizedBox(height: 20.h),
                                  CommonTextField(
                                    controller: cubit.passwordController,
                                    validator: cubit.validatePassword,
                                    obscureText: !state.isPasswordVisible,
                                    labelText: 'Password',
                                    hintText: 'Enter your password',
                                    prefixIcon: const Icon(Icons.lock_outlined, color: AppColour.primaryAccent),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        state.isPasswordVisible
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: AppColour.white70,
                                      ),
                                      onPressed: cubit.togglePasswordVisibility,
                                    ),
                                  ),
                                  SizedBox(height: 30.h),
                                  ValueListenableBuilder<bool>(
                                    valueListenable: AppClass().isShowLoading,
                                    builder: (context, isLoading, child) {
                                      return CommonAppButton(
                                        text: 'Login',
                                        onPressed: isLoading ? null : cubit.login,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
