import 'package:enreda_empresas/app/home/applicants/participant_detail_page.dart';
import 'package:enreda_empresas/app/home/applicants/registered_applicants.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;
import 'package:provider/provider.dart';

import '../../models/jobOfferApplication.dart';
import '../../models/resource.dart';
import '../../services/database.dart';
import '../../utils/adaptative.dart';
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
    double fontSize = responsiveSize(context, 12, 14, md: 13);
    final database = Provider.of<Database>(context, listen: false);
    TextTheme textTheme = Theme.of(context).textTheme;
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
        label: Row(
          children: [
            Text(label),
            StreamBuilder<List<JobOfferApplication>>(
              stream: database.applicantsStreamByJobOffer(
                  globals.currentResource!.jobOfferId!, status == '' ? null : status),
              builder: (context, snapshot) {
                int count = 0;
                if (snapshot.hasData) {
                  count = snapshot.data!.length;
                }
                return Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.only(left: 8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.greyUltraLight, width: 1.0),
                    color: Colors.white,
                  ),
                  child: Text(
                    '$count',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.greyTxtAlt,
                      height: 1.2,
                      fontSize: fontSize,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        selected: ApplicantsListPage.selectedIndex.value == index,
        onSelected: (bool selected) {
          if (selected) {
            setState(() {
              ApplicantsListPage.selectedIndex.value = index;
            });
          }
        },
        padding: const EdgeInsets.all(8.0),
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
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 12, 14, md: 13);
    final database = Provider.of<Database>(context, listen: false);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.mainPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextMediumBold(text: '${resource.title}'),
          Container(
            height: 30,
            child: RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: StreamBuilder<List<JobOfferApplication>>(
                      stream: database.applicantsStreamByJobOffer(
                          resource.jobOfferId!, null),
                      builder: (context, snapshot) {
                        int count = 0;
                        if (snapshot.hasData) {
                          count = snapshot.data!.length;
                        }
                        return Text(
                          '$count ', // The number of applications or 0
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.greyTxtAlt,
                            height: 1.2,
                            fontSize: fontSize,
                          ),
                        );
                      },
                    ),
                  ),
                  TextSpan(
                    text: StringConst.JOB_OFFER_REGISTERED_TITLE,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.greyTxtAlt,
                      height: 1.5,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: StringConst.JOB_OFFER,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.greyTxtAlt,
                      height: 1.5,
                      fontSize: fontSize,
                      decoration: TextDecoration.underline,  // Add underline decoration
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        ManageOffersPage.selectedIndex.value = 1;
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}

