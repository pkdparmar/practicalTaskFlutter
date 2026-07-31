import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:practicletestone/app/app_colour.dart';


/// Common app image which handles network, assets and local file paths
class CommonProgressIndicator extends StatelessWidget {
  final Color? color;
  final Color? backGroundColor;
  final double strokeWidth;
  final double? value;

  const CommonProgressIndicator({super.key, this.color, this.backGroundColor = Colors.transparent, this.strokeWidth= 3.0,this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 0.w,bottom: 0.w),
      child: Center(
        child: SizedBox(
          height: 30.w,
          width: 30.w,
          child: CircularProgressIndicator(
            color: color ?? AppColour.primaryAccent,
            value: value,
            backgroundColor: backGroundColor,
            strokeWidth: strokeWidth,
          ),
        ),
      ),
    );
  }
}