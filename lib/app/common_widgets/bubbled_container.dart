import 'package:flutter/material.dart';
import '../values/values.dart';
import 'custom_text.dart';

class BubbledContainer extends StatelessWidget {

  const BubbledContainer(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: AppColors.primary050,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
          child: CustomTextSmall(text: text, color: AppColors.primary900,),
        ));
  }
}
