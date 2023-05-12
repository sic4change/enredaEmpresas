import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/common_widgets/stores_buttons.dart';
import 'package:enreda_empresas/app/sign_in/email_sign_in_form_change_notifier.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccessPageWeb extends StatefulWidget {
  const AccessPageWeb({super.key});

  @override
  State<AccessPageWeb> createState() => _AccessPageWebState();
}

class _AccessPageWebState extends State<AccessPageWeb> {
  @override
  Widget build(BuildContext context) {
    const double largeHeight = 800;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxHeight > largeHeight
              ? _buildLargeBody(context)
              : _buildSmallBody(context);
        }
      )
    );
  }

  Widget _buildLargeBody(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double widthSize = MediaQuery.of(context).size.width;
    final double heightSize = MediaQuery.of(context).size.height;
    final double fontSize = responsiveSize(context, 15, 25, md: 20);
    return Stack(
      children: [
        Center(
          child: SizedBox(
            height: heightSize * 0.70,
            width: widthSize * 0.80,
            child: Card(
              elevation: 5,
              child: Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.all(Sizes.mainPadding),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    ImagePath.LOGO,
                                    height: Sizes.HEIGHT_32,
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    StringConst.LOOKING_FOR_OPPORTUNITIES,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SpaceH12(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                  child: EmailSignInFormChangeNotifier.create(context),
                                ),
                                const SpaceH4(),
                                kIsWeb ? buildStoresButtons(context) : Container(),
                                const SpaceH4(),
                                kIsWeb ? Text(
                                  StringConst.BETTER_FROM_APPS,
                                  style: textTheme.bodyText2,
                                ) : Container(),
                              ],
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 5,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.turquoise,
                        ),
                        child: Image.asset(
                          ImagePath.YOUNGS,
                          fit: BoxFit.cover,
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallBody(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double widthSize = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Center(
          child: Container(
            height: 680,
            width: widthSize * 0.85,
            child: Card(
              elevation: 5,
              child: Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.all(Sizes.mainPadding),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () => GoRouter.of(context).go(StringConst.PATH_HOME),
                                    child: Image.asset(
                                      ImagePath.LOGO,
                                      height: Sizes.HEIGHT_32,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    StringConst.LOOKING_FOR_OPPORTUNITIES,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SpaceH12(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                  child: EmailSignInFormChangeNotifier.create(context),
                                ),
                                const SpaceH4(),
                                kIsWeb ? buildStoresButtons(context) : Container(),
                                const SpaceH4(),
                                kIsWeb ? Text(
                                  StringConst.BETTER_FROM_APPS,
                                  style: textTheme.bodyText2,
                                ) : Container(),
                              ],
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: AppColors.turquoise,
                      child: Image.asset(
                        ImagePath.YOUNGS,
                        height: 600.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

