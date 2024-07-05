import 'package:flutter/material.dart';
import '../utils/adaptative.dart';
import '../utils/responsive.dart';
import '../values/values.dart';

Future showAlertDialog(
    BuildContext context, {
      required String title,
      required String content,
      required String defaultActionText,
      String? cancelActionText,
    }) {
  final textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 13, 20, md: 16);
  double fontSizeSubTitle = responsiveSize(context, 14, 18, md: 15);
  double fontSizeButton = responsiveSize(context, 12, 15, md: 13);
  try {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primary050,
        titlePadding:
        Responsive.isMobile(context) ? const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 10.0) :
        const EdgeInsets.only(top: 50.0, left: 50.0, right: 50.0, bottom: 10.0),
        contentPadding:
        Responsive.isMobile(context) ? const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0) :
        const EdgeInsets.only(left: 50.0, right: 50.0, bottom: 30.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: textTheme.titleLarge?.copyWith(
                  color: AppColors.primary900,
                  fontSize: fontSize,
                  height: 1.5,
                )),
          ],
        ),
        content: Text(content,
            style: textTheme.headlineLarge?.copyWith(
                color: AppColors.primary900,
                height: 1.5,
                fontSize: fontSizeSubTitle)),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                cancelActionText != null ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    onPressed: () => Navigator.of(context).pop((false)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(cancelActionText,
                          style: textTheme.bodySmall?.copyWith(
                              color: AppColors.white,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                              fontSize: fontSizeButton
                          )),
                    )) : SizedBox(),
                Responsive.isMobile(context) ? SizedBox(width: 10,) : SizedBox(width: 30,),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    onPressed: () => Navigator.of(context).pop((true)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(defaultActionText,
                          style: textTheme.bodySmall?.copyWith(
                              color: AppColors.white,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                              fontSize: fontSizeButton)),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  } catch (e) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title,
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.primary900,
              fontSize: fontSize,
              height: 1.5,
            )),
        content: Text(content,
            style: textTheme.headlineLarge?.copyWith(
                color: AppColors.primary900,
                height: 1.5,
                fontSize: fontSizeSubTitle)),
        actions: <Widget>[
          cancelActionText != null ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              onPressed: () => Navigator.of(context).pop((false)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(cancelActionText,
                    style: textTheme.bodySmall?.copyWith(
                        color: AppColors.white,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                        fontSize: fontSizeButton)),
              )) : SizedBox(),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              onPressed: () => Navigator.of(context).pop((true)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(defaultActionText,
                    style: textTheme.bodySmall?.copyWith(
                        color: AppColors.greyDark,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                        fontSize: fontSizeButton)),
              )),
        ],
      ),
    );
  }
}