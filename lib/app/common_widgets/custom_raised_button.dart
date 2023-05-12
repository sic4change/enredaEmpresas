import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

import '../utils/responsive.dart';

class CustomRaisedButton extends StatelessWidget {

  CustomRaisedButton({
    required this.child,
    required this.color,
    this.borderRadius: 2.0,
    this.borderColor ,
    this.height: 50.0,
    this.onPressed
  }) : assert(borderRadius != null);

  final Widget child;
  final Color color;
  final double borderRadius;
  final Color? borderColor;
  final double height;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: color,
          shadowColor: Colors.greenAccent,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius,),),
            side: BorderSide(color: borderColor?? color)
        ),
      ),
        child: child,
    )
    );
  }
}


class CustomButton extends StatelessWidget {

  CustomButton({
    required this.text,
    required this.color,
    this.onPressed
  });

  final String text;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 14, 18, md: 15);
    return Container(
      margin: EdgeInsets.all(Sizes.mainPadding),
      child: Column(
        crossAxisAlignment: Responsive.isMobile(context) ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(color),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: Responsive.isDesktop(context)? 96.0 : 18.0),
              child: Text(
                text.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.3,
                  color: AppColors.white,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}





