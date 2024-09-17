import 'package:flutter/material.dart';
import '../../common_widgets/spaces.dart';
import '../../utils/responsive.dart';
import '../../values/strings.dart';
import '../../values/values.dart';
import '../email_sign_in_form_change_notifier.dart';

class AccessPageMobile extends StatefulWidget {
  @override
  _AccessPageMobileState createState() => _AccessPageMobileState();
}

class _AccessPageMobileState extends State<AccessPageMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        color: AppColors.yellow,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              SpaceW20(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    ImagePath.LOGO_DARK,
                    height: Responsive.isMobile(context) ? Sizes.HEIGHT_50 : Sizes.HEIGHT_60,
                  ),
                  SpaceH30(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      StringConst.LOOKING_FOR_OPPORTUNITIES,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary900,
                      ),
                    ),
                  ),
                  SpaceH30(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: EmailSignInFormChangeNotifier.create(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
