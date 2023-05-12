import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/web_home.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class NoResourcesIlustration extends StatelessWidget {
  const NoResourcesIlustration(
      {Key? key, required this.title, required this.imagePath})
      : super(key: key);
  final String title;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(48.0),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 400.0,
          ),
          SpaceH20(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.bodyText1
                ?.copyWith(fontSize: 22.0, color: AppColors.red),
          ),
          const SpaceH40(),
          TextButton(
            onPressed: () {
              Responsive.isDesktop(context)
                  ? WebHome.selectedIndex.value = 0
                  //: CupertinoScaffold.controller.index = 0;
              : Container();
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppColors.lilac),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ))),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: Responsive.isDesktop(context)? 64.0:18.0),
              child: Text(
                'VER RECURSOS',
                style: textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
