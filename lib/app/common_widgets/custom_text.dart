import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/cupertino.dart';
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

  CustomText({super.key,  required this.title });
  final String title;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 15, md: 14);
    return Text(
      title,
      style: textTheme.bodySmall?.copyWith(
        color: AppColors.greyAlt,
        fontSize: fontSize,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class CustomTextBold extends StatelessWidget {

  const CustomTextBold({super.key,  required this.title, this.color = AppColors.greyAlt, this.height = 1.5, this.padding = EdgeInsets.zero});
  final String title;
  final Color color;
  final double height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 14, 15, md: 14);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: padding,
      child: Text(
        title,
        style: textTheme.bodySmall?.copyWith(
            color: color,
            height: height,
            fontSize: fontSize,
            fontWeight: FontWeight.bold
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class CustomTextSmall extends StatelessWidget {

  const CustomTextSmall({super.key,  required this.text, this.height = 1.5, this.color = AppColors.greyAlt, this.maxLines = 2});
  final String text;
  final double height;
  final Color color;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 14, 15, md: 14);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: textTheme.bodySmall?.copyWith(
        color: color,
        height: height,
        fontSize: fontSize,
      ),
    );
  }
}

class CustomTextSmallBold extends StatelessWidget {

  CustomTextSmallBold({ required this.title, this.color = AppColors.greyTxtAlt,  this.height = 1.5 });
  final String title;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 13, 15, md: 14);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text(
      title,
      style: textTheme.titleSmall?.copyWith(
          height: height,
          color: color,
          fontSize: fontSize
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
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
    double fontSize = responsiveSize(context, 14, 20, md: 16);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.bodyMedium?.copyWith(
        color: AppColors.primary900,
        height: 1.5,
        fontSize: fontSize,
      ),
    );
  }
}

class CustomTextMediumForm extends StatelessWidget {

  const CustomTextMediumForm({super.key,  required this.text });
  final String text;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 14, 18, md: 16);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.kDefaultPaddingDouble / 2, vertical: 0),
      child: Text(
        text,
        style: textTheme.bodyMedium?.copyWith(
          color: AppColors.primary900,
          height: 1.5,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

class CustomTextMediumBold extends StatelessWidget {

  const CustomTextMediumBold({super.key,  required this.text });
  final String text;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 15, 20, md: 16);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.bodyLarge?.copyWith(
        color: AppColors.primary900,
        height: 1.5,
        fontSize: fontSize,
      ),
    );
  }
}

class CustomTextSubTitle extends StatelessWidget {

  CustomTextSubTitle({ required this.title });
  final String title;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        title,
        style: textTheme.bodySmall?.copyWith(
          color: AppColors.greyViolet,
          height: 1.5,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}


class CustomTextBoldCenter extends StatelessWidget {

  const CustomTextBoldCenter({super.key,  required this.title, this.color = AppColors.greyTxtAlt, this.height = 1.5});
  final String title;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 16, 20, md: 18);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: textTheme.titleSmall?.copyWith(
            color: color,
            height: height,
            fontSize: fontSize,
            fontWeight: FontWeight.normal
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class CustomTextSmallColor extends StatelessWidget {

  const CustomTextSmallColor({super.key,  required this.text, this.color = AppColors.greyTxtAlt, this.height = 1.5, this.padding = const EdgeInsets.only(bottom: 20.0)});
  final String text;
  final Color color;
  final double height;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 13, 15, md: 14);
    return Padding(
    padding: padding,
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: textTheme.bodyMedium?.copyWith(
            color: color,
            height: height,
            fontSize: fontSize
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}


class CustomTextXSmall extends StatelessWidget {

  const CustomTextXSmall({super.key,  required this.text, this.height = 1.5, this.color = AppColors.greyAlt});
  final String text;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 10, 12, md: 11);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: textTheme.bodySmall?.copyWith(
          color: color,
          height: height,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

class CustomTextSmallOverflow extends StatelessWidget {

  const CustomTextSmallOverflow({super.key,  required this.text, this.height = 1.5, this.color = AppColors.greyAlt});
  final String text;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 14, 15, md: 14);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
      style: textTheme.bodySmall?.copyWith(
        color: color,
        height: height,
        fontSize: fontSize,
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {

  const CustomTextButton({super.key,  required this.text, this.color = AppColors.white});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 14, 16, md: 15);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.bodySmall?.copyWith(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w500
      ),
    );
  }
}

class CustomTextSpan extends StatelessWidget {

  const CustomTextSpan({super.key,  required this.text, this.color = AppColors.white});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 14, 16, md: 15);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.bodySmall?.copyWith(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w500
      ),
    );
  }
}

class CustomTextSmallIcon extends StatelessWidget {

  const CustomTextSmallIcon({super.key,  required this.text, this.height = 1.5, this.color = AppColors.primary900});
  final String text;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    double fontSize = responsiveSize(context, 12, 15, md: 14);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(
          text,
          style: textTheme.bodySmall?.copyWith(
            color: color,
            height: height,
            fontSize: fontSize,
          ),
        ),
        SizedBox(width: 5,),
        Container(
            padding: const EdgeInsets.only(top: 3),
            alignment: Alignment.center,
            child: Image.asset(ImagePath.ARROW_DOWN_2, height: 8, width: 8,)),
      ],
    );
  }
}