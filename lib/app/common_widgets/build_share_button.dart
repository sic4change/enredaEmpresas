import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/resources/resource_actions.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildShareButton(BuildContext context, Resource resource, Color color) {
  showToast() {
    FToast fToast = FToast().init(context);

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: AppColors.blueDark.withOpacity(0.8),
      ),
      child: const Text(
        "Enlace copiado en el portapapeles",
        style: TextStyle(color: AppColors.white),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: widthOfScreen(context) >= 1024
          ? ToastGravity.BOTTOM_LEFT
          : ToastGravity.SNACKBAR,
      toastDuration: const Duration(seconds: 2),
    );
  }
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 15, 15, md: 13);

  return PopupMenuButton<int>(
    tooltip: '',
    onSelected: (int value) {
      switch (value) {
        case 1:
          Clipboard.setData(ClipboardData(
              text: StringConst.RESOURCE_LINK(resource.resourceId!)));
          showToast();
          break;
        case 2:
          shareResource(resource);
          break;
      }
    },
    itemBuilder: (context) {
      return [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              const Icon(
                Icons.copy,
                color: AppColors.greyTxtAlt,
              ),
              const SpaceW16(),
              Text('Copiar enlace',
                  style: TextStyle(
                    color: AppColors.greyTxtAlt,
                    fontSize: widthOfScreen(context) >= 1024 ? 16 : 12,
                  )),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              const Icon(
                Icons.share,
                color: AppColors.greyDark,
              ),
              const SpaceW16(),
              Text('Compartir',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.greyDark,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize,
                ),),
            ],
          ),
        )
      ];
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          FontAwesomeIcons.share,
          color: color,
          size: widthOfScreen(context) >= 1024 ? 15.0 : 15.0,
        ),
        const SizedBox(width: 10),
        Text('Compartir',
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.greyDark,
            height: 1.5,
            fontWeight: FontWeight.w400,
            fontSize: fontSize,
          ),),
      ],
    ),
  );
}