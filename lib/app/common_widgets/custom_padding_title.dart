import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class CustomPaddingTitle extends StatelessWidget {

  const CustomPaddingTitle({super.key,  required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Sizes.kDefaultPaddingDouble, bottom: Sizes.kDefaultPaddingDouble),
      child: child
    );
  }
}


