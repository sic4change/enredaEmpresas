import 'package:enreda_empresas/app/home/applicants/participant_detail_page.dart';
import 'package:enreda_empresas/app/home/applicants/registered_applicants.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
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
      RegisteredApplicantsListPage(status: 'pre-selected'),
      RegisteredApplicantsListPage(status: 'selected'),
      ParticipantDetailPage(),
    ];
    super.initState();
  }

  Widget _buildChoiceChip(int index, String label, String status) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ChoiceChip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          side: BorderSide(color: ApplicantsListPage.selectedIndex.value == index ? Colors.transparent : AppColors.violet),
        ),
        disabledColor: Colors.white,
        selectedColor: AppColors.yellow,
        labelStyle: TextStyle(
          fontSize: Responsive.isMobile(context) ? 12.0 : 16.0,
          fontWeight: ApplicantsListPage.selectedIndex.value == index ? FontWeight.w700 : FontWeight.w400,
          color: ApplicantsListPage.selectedIndex.value == index ? AppColors.turquoiseBlue : AppColors.greyTxtAlt,
        ),
        label: Text(label),
        selected: ApplicantsListPage.selectedIndex.value == index,
        onSelected: (bool selected) {
          if (selected) {
            setState(() {
              ApplicantsListPage.selectedIndex.value = index;
            });
          }
        },
        padding: const EdgeInsets.all(10.0),
        showCheckmark: false,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: ApplicantsListPage.selectedIndex,
        builder: (context, selectedIndex, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
                      _buildChoiceChip(0, StringConst.JOB_OFFER_REGISTERED, ''),
                      _buildChoiceChip(1, StringConst.JOB_OFFER_PRE_SELECTED, 'pre-selected'),
                      _buildChoiceChip(2, StringConst.JOB_OFFER_FINALIST, 'selected'),
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
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: Sizes.mainPadding),
                    child: bodyWidget[selectedIndex]),
              ],
            ),
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

