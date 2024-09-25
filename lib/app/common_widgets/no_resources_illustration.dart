import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/cupertino_scaffold.dart';
import 'package:enreda_empresas/app/home/web_home.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class NoResourcesIllustration extends StatelessWidget {
  const NoResourcesIllustration(
      {Key? key, required this.title, required this.subtitle, required this.imagePath})
      : super(key: key);
  final String title;
  final String subtitle;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width : 500,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                    fontSize: Responsive.isMobile(context) ? 12.0 : 18.0,
                    color: AppColors.primary900),
              ),
            ),
            SpaceH12(),
            Container(
              width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width : 500,
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                    fontSize: Responsive.isMobile(context) ? 15.0 : 22.0,
                    color: AppColors.primary900),
              ),
            ),
            SpaceH20(),
            Image.asset(
              imagePath,
              width: Responsive.isMobile(context) ? 100 : 200.0,
            ),
            SpaceH20(),
            TextButton(
              onPressed: () {
                Responsive.isMobile(context)
                    ? CupertinoScaffold.controller.index = 0
                    : WebHome.goCreateJobOffer();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                child: Text(
                  'Empieza ahora',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(AppColors.turquoise),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}
