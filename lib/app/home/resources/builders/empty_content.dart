import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
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
  final MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Sizes.mainPadding, right: Sizes.mainPadding, bottom: Sizes.mainPadding),
      child: Center(
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          children: <Widget>[
            CustomTextSmallBold(title: title, color: AppColors.primary900,),
            CustomTextSmall(text: message, color: AppColors.primary900,)
          ],
        ),
      ),
    );
  }
}
