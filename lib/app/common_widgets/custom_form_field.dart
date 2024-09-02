import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomFormField extends StatelessWidget {

  CustomFormField({ required this.child, required this.label});
  final Widget child;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.kDefaultPaddingDouble / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextBold(title: label),
          SpaceH4(),
          child
        ],
      ),
    );
  }
}