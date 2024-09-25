import 'package:enreda_empresas/app/home/web_home.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../home/resources/resources_list_page.dart';


class CustomSideBarButton extends StatelessWidget {
  const CustomSideBarButton({
    super.key,
    required this.buttonTitle,
    this.height = 45.0,
    this.titleStyle,
    this.titleColor = AppColors.turquoiseBlue,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0),
    this.borderRadius = const BorderRadius.all(
      Radius.circular(Sizes.RADIUS_25),
    ),
    this.opensUrl = false,
    this.url = "",
    this.linkTarget = LinkTarget.blank,
    this.widget,
  });

  final VoidCallback? onPressed;
  final double? height;
  final String buttonTitle;
  final TextStyle? titleStyle;
  final Color titleColor;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;
  final String url;
  final LinkTarget linkTarget;
  final bool opensUrl;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      child: OutlinedButton(
        onPressed: onPressed,
        child: buildChild(context),
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.only(left: 8, bottom: 10, top: 10)),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (WebHome.selectedIndex.value == 1) {
                return AppColors.primary100;
              }
              return AppColors.white;
            },
          ),
          side: WidgetStateProperty.resolveWith<BorderSide>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return BorderSide(
                  color: AppColors.primary100, // Color for pressed state
                  width: 1.0,
                );
              }
              return BorderSide(
                color: AppColors.turquoiseUltraLight, // Default color
                width: 1.0,
              );
            },
          ),
        ),
      )
      ,
    );
  }

  Widget buildChild(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double? textSize = responsiveSize(
      context,
      Sizes.TEXT_SIZE_15,
      Sizes.TEXT_SIZE_15,
      md: Sizes.TEXT_SIZE_15,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              child: widget ?? Container()),
          SizedBox(width: 4,),
          Text(
            buttonTitle,
            style: titleStyle ??
                textTheme.bodySmall?.copyWith(
                  color: titleColor,
                  fontSize: textSize,
                  fontWeight: MyResourcesListPage.selectedIndex.value == 1 ? FontWeight.w900 : FontWeight.w500,
                ),
          ),

        ],
      ),
    );
    // }
  }
}


