import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';


class EnredaButton extends StatelessWidget {
  const EnredaButton({
    super.key,
    required this.buttonTitle,
    this.width = Sizes.WIDTH_150,
    this.height = Sizes.HEIGHT_60,
    this.titleStyle,
    this.titleColor = AppColors.white,
    this.buttonColor = AppColors.primaryColor,
    this.onPressed,
    this.padding = const EdgeInsets.all(Sizes.PADDING_8),
    this.borderRadius = const BorderRadius.all(
      Radius.circular(Sizes.RADIUS_25),
    ),
    this.opensUrl = false,
    this.url = "",
    this.linkTarget = LinkTarget.blank,
    this.borderColor = Colors.transparent,
    this.borderWidth = 1,
  });

  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final String buttonTitle;
  final TextStyle? titleStyle;
  final Color titleColor;
  final Color buttonColor;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final String url;
  final LinkTarget linkTarget;
  final bool opensUrl;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor, // Cambia el color del borde aquí
            width: borderWidth, // Define el ancho del borde
          ),
          borderRadius: borderRadius, // Asegúrate de que coincida con ClipRRect
        ),
        child: Material(
          color: buttonColor, // Color del fondo del botón
          borderRadius: borderRadius,
          child: InkWell(
            onTap: opensUrl ? () {} : onPressed,
            borderRadius: borderRadius,
            hoverColor: Colors.transparent, // Desactiva el color de hover
            highlightColor: Colors.transparent, // Desactiva el color al presionar
            splashColor: Colors.transparent, // Desactiva el efecto de salpicadura
            child: Container(
              width: width,
              height: height,
              alignment: Alignment.center, // Asegura el contenido centrado
              padding: padding,
              child: buildChild(context),
            ),
          ),
        ),
      ),
    );

  }

  Widget buildChild(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double? textSize = responsiveSize(
      context,
      Sizes.TEXT_SIZE_14,
      Sizes.TEXT_SIZE_16,
      md: Sizes.TEXT_SIZE_15,
    );
      return Text(
        buttonTitle,
        style: titleStyle ??
            textTheme.bodySmall?.copyWith(
              color: titleColor,
              fontSize: textSize,
              letterSpacing: 1.1,
              fontWeight: FontWeight.bold,
            ),
      );
    // }
  }
}


class EnredaButtonIcon extends StatelessWidget {
  const EnredaButtonIcon({
    super.key,
    this.buttonTitle = "",
    this.width = Sizes.WIDTH_150,
    this.height = Sizes.HEIGHT_60,
    this.titleStyle,
    this.titleColor = AppColors.white,
    this.buttonColor = AppColors.primaryColor,
    this.onPressed,
    this.padding = const EdgeInsets.only(top: Sizes.PADDING_8, bottom: Sizes.PADDING_8, left: Sizes.PADDING_16, right: 0),
    this.borderRadius = const BorderRadius.all(
      Radius.circular(Sizes.RADIUS_45),
    ),
    this.opensUrl = false,
    this.url = "",
    this.linkTarget = LinkTarget.blank,
    this.widget,
  });

  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final String buttonTitle;
  final TextStyle? titleStyle;
  final Color titleColor;
  final Color buttonColor;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;
  final String url;
  final LinkTarget linkTarget;
  final bool opensUrl;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: MaterialButton(
        minWidth: width,
        height: height,
        onPressed: opensUrl ? () {} : onPressed,
        color: buttonColor,
        child: Padding(
          padding: padding,
          child: buildChild(context),
        ),
      ),
    );
  }

  Widget buildChild(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double? textSize = responsiveSize(
      context,
      Sizes.TEXT_SIZE_14,
      Sizes.TEXT_SIZE_16,
      md: Sizes.TEXT_SIZE_15,
    );
    return Row(
      children: [
        Text(
          buttonTitle,
          style: titleStyle ??
              textTheme.bodySmall?.copyWith(
                color: titleColor,
                fontSize: textSize,
                letterSpacing: 1.1,
                fontWeight: FontWeight.bold,
              ),
        ),
        if(buttonTitle != "") SizedBox(width: 10,),
        Container(
            height: 30,
            child: widget ?? Container()),
      ],
    );
    // }
  }
}

class EnredaButtonIconSmall extends StatelessWidget {
  const EnredaButtonIconSmall({
    super.key,
    this.buttonTitle = "",
    this.width = Sizes.WIDTH_150,
    this.height = Sizes.HEIGHT_30,
    this.titleStyle,
    this.titleColor = AppColors.white,
    this.buttonColor = AppColors.primaryColor,
    this.onPressed,
    this.padding = const EdgeInsets.only(top: Sizes.PADDING_6, bottom: Sizes.PADDING_6, left: Sizes.PADDING_8, right: Sizes.PADDING_8),
    this.borderRadius = const BorderRadius.all(
      Radius.circular(Sizes.RADIUS_45),
    ),
    this.opensUrl = false,
    this.url = "",
    this.linkTarget = LinkTarget.blank,
    this.widget,
  });

  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final String buttonTitle;
  final TextStyle? titleStyle;
  final Color titleColor;
  final Color buttonColor;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;
  final String url;
  final LinkTarget linkTarget;
  final bool opensUrl;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: MaterialButton(
        minWidth: width,
        height: height,
        onPressed: opensUrl ? () {} : onPressed,
        color: buttonColor,
        child: Padding(
          padding: padding,
          child: buildChild(context),
        ),
      ),
    );
  }

  Widget buildChild(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double? textSize = responsiveSize(
      context,
      Sizes.TEXT_SIZE_12,
      Sizes.TEXT_SIZE_14,
      md: Sizes.TEXT_SIZE_14,
    );
    return Row(
      children: [
        Container(
            height: 30,
            child: widget ?? Container()),
        if(buttonTitle != "") SizedBox(width: 10,),
        Text(
          buttonTitle,
          style: titleStyle ??
              textTheme.bodySmall?.copyWith(
                color: titleColor,
                fontSize: textSize,
                fontWeight: FontWeight.normal,
              ),
        ),
      ],
    );
    // }
  }
}