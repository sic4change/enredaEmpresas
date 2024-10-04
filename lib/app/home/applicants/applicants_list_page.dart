import 'package:enreda_empresas/app/home/applicants/participant_detail_page.dart';
import 'package:enreda_empresas/app/home/applicants/registered_applicants.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/applicants/pre_selected_applicants.dart';
import 'package:enreda_empresas/app/home/applicants/selected_list_page.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;

import '../../models/resource.dart';
import '../resources/manage_offers_page.dart';

class ApplicantsListPage extends StatefulWidget {
  const ApplicantsListPage({super.key,});
  static ValueNotifier<int> selectedIndex = ValueNotifier(0);

  @override
  State<ApplicantsListPage> createState() => _ApplicantsListPageState();
}

class _ApplicantsListPageState extends State<ApplicantsListPage> {
  var bodyWidget = [];

  @override
  void initState() {
    bodyWidget = [
      RegisteredApplicantsListPage(),
      PreSelectedApplicantsListPage(),
      SelectedApplicantsListPage(),
      ParticipantDetailPage(),
    ];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: ApplicantsListPage.selectedIndex,
        builder: (context, selectedIndex, child) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: Sizes.mainPadding),
                child: _buildHeader(context, globals.currentResource!),
              ),
              Divider(
                indent: 0,
                endIndent: 0,
                color: AppColors.greyBorder,
                thickness: 1,
                height: 1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: Sizes.mainPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ChoiceChip(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        side: BorderSide(color: selectedIndex == 0 ? Colors.transparent : AppColors.violet)),
                        disabledColor: Colors.white,
                        selectedColor: AppColors.yellow,
                        labelStyle: TextStyle(
                          fontSize: Responsive.isMobile(context)? 12.0: 16.0,
                          fontWeight: selectedIndex == 0 ? FontWeight.w700 : FontWeight.w400,
                          color: selectedIndex == 0 ? AppColors.turquoiseBlue : AppColors.greyTxtAlt,

                        ),
                        label: Text(StringConst.JOB_OFFER_REGISTERED),
                        selected: selectedIndex == 0 ? true : false,
                        onSelected: (bool selected) {
                          setState(() {
                            ApplicantsListPage.selectedIndex.value = 0;
                          });
                        },
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        showCheckmark: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ChoiceChip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            side: BorderSide(color: selectedIndex == 1 ? Colors.transparent : AppColors.violet)),
                        disabledColor: Colors.white,
                        selectedColor: AppColors.yellow,
                        labelStyle: TextStyle(
                          fontSize: Responsive.isMobile(context)? 12.0: 16.0,
                          fontWeight: selectedIndex == 1 ? FontWeight.w700 : FontWeight.w400,
                          color: selectedIndex == 1 ? AppColors.turquoiseBlue : AppColors.greyTxtAlt,

                        ),
                        label: Text(StringConst.JOB_OFFER_PRE_SELECTED),
                        selected: selectedIndex == 1 ? true : false,
                        onSelected: (bool selected) {
                          setState(() {
                            ApplicantsListPage.selectedIndex.value = 1;
                          });
                        },
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        showCheckmark: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ChoiceChip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            side: BorderSide(color: selectedIndex == 2 ? Colors.transparent : AppColors.violet)),
                        disabledColor: Colors.white,
                        selectedColor: AppColors.yellow,
                        labelStyle: TextStyle(
                          fontSize: Responsive.isMobile(context)? 12.0: 16.0,
                          fontWeight: selectedIndex == 2 ? FontWeight.w700 : FontWeight.w400,
                          color: selectedIndex == 2 ? AppColors.turquoiseBlue : AppColors.greyTxtAlt,

                        ),
                        label: Text(StringConst.JOB_OFFER_FINALIST),
                        selected: selectedIndex == 2 ? true : false,
                        onSelected: (bool selected) {
                          setState(() {
                            ApplicantsListPage.selectedIndex.value = 2;
                          });
                        },
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        showCheckmark: false,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                indent: 0,
                endIndent: 0,
                color: AppColors.greyBorder,
                thickness: 1,
                height: 1,
              ),
              Container(
                  margin: Responsive.isMobile(context) ? EdgeInsets.only(top: Sizes.mainPadding * 6, left: Sizes.mainPadding / 2) :
                  EdgeInsets.symmetric(vertical: 10, horizontal: Sizes.mainPadding),
                  child: bodyWidget[selectedIndex]),
            ],
          );
        });

  }

  Widget _buildHeader(BuildContext context, Resource resource) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.mainPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextMediumBold(text: '${resource.title}'),
          InkWell(
            onTap: (){
              setState(() {
                ManageOffersPage.selectedIndex.value = 1;
              });
            },
            child: Row(
              children: [
                CustomTextSmallColor(text: 'Inscritos en esta oferta: ', color: AppColors.primary900),
                CustomTextSmallColor(text: 'Ver oferta' , color: AppColors.primary900)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

