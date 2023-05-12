import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/functions.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import '../values/strings.dart';


Widget buildStoresButtons(BuildContext context) {
  double buttonWidth = responsiveSize(context, 150, 180, md: 150);
  double buttonHeight = responsiveSize(context, 62, 75, md: 62);
  return Wrap(
    children: [
      InkWell(
        onTap: () => launchURL(StringConst.URL_APPSTORE),
        child: Image.asset(
          ImagePath.APP_STORE_BUTTON,
          width: buttonWidth,
          height: buttonHeight,
          fit: BoxFit.fill,
        ),
      ),
      InkWell(
        onTap: () => launchURL(StringConst.URL_GOOGLE_PLAY),
        child: Image.asset(
          ImagePath.PLAY_STORE_BUTTON,
          width: buttonWidth,
          height: buttonHeight,
          fit: BoxFit.fill,
        ),
      ),
    ],
  );
}