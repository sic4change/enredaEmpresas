import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';

class GradientCircleWidget extends StatelessWidget {
  final String text;
  final double size;

  const GradientCircleWidget({
    Key? key,
    required this.text,
    this.size = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: const [0.0, 0.5, 1.0],
          colors: [
            const Color(0xFF054D5E).withOpacity(0.9),
            const Color(0xFF054D5E).withOpacity(0.9), // subtle transition
            const Color(0xFF76BFBB).withOpacity(0.9),
          ],
        ),
      ),
      child: Center(
        child: CustomTextSmallBold(title: text, color: Colors.white),
      ),
    );
  }
}