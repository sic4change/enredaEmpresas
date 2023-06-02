import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class CustomExpandedRow extends StatelessWidget {

  const CustomExpandedRow({super.key,  required this.title, required this.text, });
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 18, md: 15);
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Text(
              title,
              maxLines: 3,
              style: textTheme.bodySmall?.copyWith(
              height: 1.5,
              color: AppColors.greyDark,
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ),)),
        const SizedBox(width: 50),
        Expanded(
            flex: 2,
            child: Text(
              text,
              textAlign: TextAlign.left,
              maxLines: 4,
              style: textTheme.bodySmall?.copyWith(
                height: 1.5,
                color: AppColors.greyDark,
                fontWeight: FontWeight.w400,
                fontSize: fontSize,
              ),
            )),
      ],
    );
  }
}

class CustomExpandedRowMultiline extends StatelessWidget {

  const CustomExpandedRowMultiline({super.key,  required this.title, required this.text, });
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 18, md: 15);
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Text(
              title,
              maxLines: 3,
              style: textTheme.bodySmall?.copyWith(
                height: 1.5,
                color: AppColors.greyDark,
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
              ),)),
        const SizedBox(width: 50),
        Expanded(
            flex: 2,
            child: Text(
              text,
              textAlign: TextAlign.left,
              maxLines: null,
              style: textTheme.bodySmall?.copyWith(
                height: 1.5,
                color: AppColors.greyDark,
                fontWeight: FontWeight.w400,
                fontSize: fontSize,
              ),
            )),
      ],
    );
  }
}


