import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class CustomTextTitle extends StatelessWidget {

  const CustomTextTitle({super.key,  required this.title, this.color = AppColors.greyViolet});
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 14, 18, md: 16);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        title,
        style: textTheme.bodySmall?.copyWith(
          color: color,
          height: 1.5,
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class CustomTextBoldTitle extends StatelessWidget {

  const CustomTextBoldTitle({super.key,  required this.title });
  final String title;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 15, 30, md: 25);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        title,
        style: textTheme.bodyLarge?.copyWith(
          color: AppColors.turquoiseBlue,
          height: 1.5,
          //fontWeight: FontWeight.w600,
          fontSize: fontSize,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class CustomTextBody extends StatelessWidget {

  const CustomTextBody({super.key,  required this.text });
  final String text;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 14, 15, md: 14);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.bodySmall?.copyWith(
        color: AppColors.greyAlt,
        height: 1.5,
        fontSize: fontSize,
      ),
    );
  }
}

class CustomText extends StatelessWidget {

  const CustomText({super.key,  required this.title });
  final String title;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text(
      title,
      style: textTheme.bodySmall?.copyWith(
        color: AppColors.greyAlt,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class CustomTextBold extends StatelessWidget {

  const CustomTextBold({super.key,  required this.title, this.color = AppColors.greyAlt, this.height = 1.5});
  final String title;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 14, 15, md: 14);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text(
      title,
      style: textTheme.bodySmall?.copyWith(
          color: color,
          height: height,
          fontSize: fontSize,
          fontWeight: FontWeight.bold
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class CustomTextSmall extends StatelessWidget {

  const CustomTextSmall({super.key,  required this.text });
  final String text;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 14, 15, md: 14);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.bodySmall?.copyWith(
        color: AppColors.greyAlt,
        height: 1.5,
        fontSize: fontSize,
      ),
    );
  }
}

class CustomTextChip extends StatelessWidget {
  const CustomTextChip({super.key,  required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 14, 18, md: 15);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text(text,
      style: textTheme.bodySmall?.copyWith(
        color: color,
        height: 1.5,
        fontWeight: FontWeight.w800,
        fontSize: fontSize,
      ),
    );
  }
}

class CustomTextMedium extends StatelessWidget {

  const CustomTextMedium({super.key,  required this.text });
  final String text;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 15, 18, md: 16);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.bodyMedium?.copyWith(
        color: AppColors.turquoiseBlue,
        height: 1.5,
        fontSize: fontSize,
      ),
    );
  }
}

class CustomTextMediumBold extends StatelessWidget {

  const CustomTextMediumBold({super.key,  required this.text });
  final String text;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 15, 18, md: 16);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.bodyMedium?.copyWith(
        color: AppColors.turquoiseBlue,
        height: 1.5,
        fontSize: fontSize,
        fontWeight: FontWeight.bold
      ),
    );
  }
}