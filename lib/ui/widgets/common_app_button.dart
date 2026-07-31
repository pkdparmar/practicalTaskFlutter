import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:practicletestone/app/app_colour.dart';
import 'package:practicletestone/ui/widgets/common_text_widget.dart';

class CommonAppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;

  const CommonAppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColour.primaryAccent,
          disabledBackgroundColor:  AppColour.primaryAccent,
          foregroundColor: AppColour.darkBackground1,
          disabledForegroundColor:  AppColour.darkBackground1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation:  5,
          shadowColor: AppColour.primaryAccent.withValues(alpha: 0.3),
        ),
        onPressed: onPressed,
        child: CommonTextWidget(
          text: text,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
