import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/common_widgets/stores_buttons.dart';
import 'package:enreda_empresas/app/sign_in/email_sign_in_form_change_notifier.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AccessPageMobile extends StatefulWidget {
  const AccessPageMobile({super.key});

  @override
  State<AccessPageMobile> createState() => _AccessPageMobileState();
}

class _AccessPageMobileState extends State<AccessPageMobile> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                StringConst.LOOKING_FOR_OPPORTUNITIES,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SpaceH30(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: EmailSignInFormChangeNotifier.create(context),
            ),
            const SpaceH20(),
            kIsWeb ? buildStoresButtons(context) : Container(),
            const SpaceH4(),
            kIsWeb ? Text(
              StringConst.BETTER_FROM_APPS,
              style: textTheme.bodyText2,
            ) : Container(),
          ],
        ),
    );
  }
}
