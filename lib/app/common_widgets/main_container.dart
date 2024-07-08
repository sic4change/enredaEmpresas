import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import '../values/values.dart';

class MainContainer extends StatelessWidget {
  const MainContainer({
    Key? key,
    required this.child,
    this.height,
    this.width,
    this.margin,
    this.padding = const EdgeInsets.all(Sizes.kDefaultPaddingDouble),
    this.shadowColor,
    this.color = AppColors.white,
  }) : super(key: key);

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final double? height, width;
  final Color? shadowColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: Responsive.isMobile(context) ? null : BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: shadowColor ?? Colors.black.withOpacity(0.15),
              offset: Offset(0, 1), //(x,y)
              blurRadius: 4.0,
              spreadRadius: 1.0),
        ],
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: color,
      ),
      child: child,
    );
  }
}
