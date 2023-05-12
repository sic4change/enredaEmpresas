import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class CustomPadding extends StatelessWidget {

  const CustomPadding({super.key,  required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
        child: child
    );
  }
}


