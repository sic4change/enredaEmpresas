import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  const CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
    required this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: color, backgroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: color),
          ),
        ),
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextSmall(text: text, color: color,),
        ),
      ),
    );
  }
}