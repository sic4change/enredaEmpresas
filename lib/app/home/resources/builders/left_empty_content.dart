import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class LeftEmptyContent extends StatelessWidget {
  const LeftEmptyContent({
    Key? key,
    this.title = 'Nada por ahora',
    this.message = 'Sin elementos que mostrar aún'
  }) : super(key: key);
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.greyTxtAlt,
            fontWeight: FontWeight.w800,
            height: 1.5,
          ),
        ),
        Text(
          message,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.penBlue,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
