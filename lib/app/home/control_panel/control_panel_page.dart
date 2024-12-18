import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/rounded_container.dart';
import 'package:enreda_empresas/app/home/resources/my_resources_list.dart';
import 'package:enreda_empresas/app/home/resources/manage_offers_page.dart';
import 'package:enreda_empresas/app/home/tool_box/tool_box_page.dart';
import 'package:enreda_empresas/app/home/web_home.dart';
import 'package:enreda_empresas/app/models/company.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class ControlPanelPage extends StatefulWidget {
  const ControlPanelPage({super.key, required this.company, required this.user});

  final Company? company;
  final UserEnreda? user;

  @override
  State<ControlPanelPage> createState() => _ControlPanelPageState();
}

class _ControlPanelPageState extends State<ControlPanelPage> {
  @override
  Widget build(BuildContext context) {

    return Responsive.isMobile(context) || Responsive.isDesktopS(context) ?
    myWelcomePageMobile(context) : myWelcomePageDesktop(context);
  }

  Widget myWelcomePageDesktop(BuildContext context){
    final textTheme = Theme.of(context).textTheme;
    return RoundedContainer(
        color: AppColors.altWhite,
        contentPadding: const EdgeInsets.only(left: 0, right: Sizes.kDefaultPaddingDouble,
            bottom: Sizes.kDefaultPaddingDouble, top: Sizes.kDefaultPaddingDouble),
        child: SingleChildScrollView(
          child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: CustomTextMediumBold(text: StringConst.CONTROL_PANEL),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50.0, right: 10.0, left: 30.0, bottom: 30.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppColors.greyLight2.withOpacity(0.3), width: 1),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 0, bottom: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  'Hola ${widget.user?.firstName},',
                                  style: textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.isMobile(context) ? 30 : 42.0,
                                    color: AppColors.turquoiseBlue,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  StringConst.WELCOME_COMPANY,
                                  style: textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.isMobile(context) ? 30 : 42.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 20.0),
                                child: Text(
                                  StringConst.WELCOME_TEXT,
                                  style: textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    fontSize: Responsive.isMobile(context) ? 15 : 18.0,
                                    color: AppColors.greyAlt,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: 220,
                          child: Image.asset(
                            ImagePath.CONTROL_ILLUSTRATION,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
            AllResourcesScrollPage(),
          ],
      ),
        ),
    );
  }

  Widget myWelcomePageMobile(BuildContext context){
    final textTheme = Theme.of(context).textTheme;
    return RoundedContainer(
      borderColor: Colors.transparent,
      margin: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                margin: const EdgeInsets.only(top: 10.0, right: 0, left: 0, bottom: 10.0,),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text('Hola ${widget.user?.firstName},',
                        style: textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.isMobile(context) ? 20 : 30.0,
                            color: AppColors.turquoiseBlue),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(StringConst.WELCOME_COMPANY,
                        style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.isMobile(context) ? 20 : 30.0,
                            color: Colors.black),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 20.0),
                      child: CustomTextSmall(text: StringConst.WELCOME_TEXT,),
                    ),
                  ],
                )
            ),
            SizedBox(height: 20,),
            RoundedContainer(
              color: AppColors.yellow,
              borderWith: 1,
              height: Responsive.isDesktopS(context) ? 170 : 150,
              borderColor: AppColors.greyLight2.withOpacity(0.3),
              contentPadding: EdgeInsets.all(0.0),
              margin: EdgeInsets.zero,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                        onTap: () {
                          WebHome.goToolBox();
                          ToolBoxPage.selectedIndex.value = 1;
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, top: 15.0, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextBoldTitle(title: StringConst.CALENDAR),
                              CustomTextMedium(text: StringConst.ENREDA_METHODOLOGY_TITLE),
                            ],
                          ),
                        )),
                  ),
                ],
              ),),
            SizedBox(height: 20,),
            InkWell(
              onTap: () {
                WebHome.goJobOffers();
                ManageOffersPage.selectedIndex.value = 0;
              },
              child: Container(
                height: Responsive.isDesktopS(context) ? 350 : 250,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                      child: CustomTextBoldTitle(title: StringConst.MY_RESOURCES),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: () {
                setState(() {
                  WebHome.goToEntities();
                });
              },
              child: Stack(
                children: [
                  Container(
                    height: Responsive.isDesktopS(context) ? 200 : 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary100,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0, top: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: Responsive.isDesktopS(context) ? 200 : 150,
                            child: Text(StringConst.DRAWER_ENTITIES,
                              style: textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.isMobile(context) ? 25 : 35.0,
                                  color: AppColors.white),),
                          ),
                          SizedBox(height: 20,),
                          CustomTextBold(title: StringConst.SEE_MORE),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          WebHome.goToEntities();
                        });
                      },
                      child: Container(
                          width: 150,
                          child: Image.asset(ImagePath.CONTROL_PANEL_CALENDAR)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40,),
            AllResourcesScrollPage(),
          ],
        ),
      ),
    );
  }

}
