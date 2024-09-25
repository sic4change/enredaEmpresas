import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class CustomStepperButton extends StatelessWidget {
  const CustomStepperButton({super.key, required this.child, required this.color});
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Sizes.kDefaultPaddingDouble / 2, horizontal: Sizes.kDefaultPaddingDouble),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Sizes.kDefaultPaddingDouble * 2),
        border: Border.all(color: AppColors.greyLight, width: 2.0,),
      ),
      child: child,
    );
  }
}

