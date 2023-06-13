import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key? key,
    this.title = 'Nada por ahora',
    this.message = 'Sin elementos que mostrar aún'
  }) : super(key: key);
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(left: Sizes.mainPadding, right: Sizes.mainPadding),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
        ),
      ),
    );
  }
}
