import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({
    super.key,
    this.child,
    this.contentPadding = const EdgeInsets.all(Sizes.kDefaultPaddingDouble),
    this.margin = const EdgeInsets.all(Sizes.kDefaultPaddingDouble),
    this.width,
    this.height,
    this.borderColor = AppColors.greyLight,
    this.color = AppColors.white,
    this.borderWith = 2.0,
  });

  final Widget? child;
  final EdgeInsets? contentPadding, margin;
  final double? width, height, borderWith;
  final Color borderColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: contentPadding,
        margin: margin,
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(Sizes.kDefaultPaddingDouble),
          border: Border.all(color: borderColor, width: borderWith!,),
        ),
        child: child);
  }
}
