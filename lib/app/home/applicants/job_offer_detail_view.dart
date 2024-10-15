import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/rounded_container.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/resources/list_item_builder.dart';
import 'package:enreda_empresas/app/home/resources/resource_detail/resource_detail_page.dart';
import 'package:enreda_empresas/app/models/jobOffer.dart';
import 'package:enreda_empresas/app/models/jobOfferApplication.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;

import '../../common_widgets/circle_widget.dart';
import '../../models/city.dart';
import '../../models/country.dart';
import '../../models/province.dart';
import 'applicants_list_page.dart';
import 'header_job_offer.dart';

class JobOfferDetailView extends StatefulWidget {
  const JobOfferDetailView({Key? key}) : super(key: key);

  @override
  State<JobOfferDetailView> createState() => _JobOfferDetailViewState();
}

class _JobOfferDetailViewState extends State<JobOfferDetailView> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizes.mainPadding),
          child: IconButton(
            color: AppColors.primary900,
            onPressed: () {
              ApplicantsListPage.selectedIndex.value = 0;
            },
            icon: Container(
              width: 100,
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: AppColors.primary900,),
                  SizedBox(width: 10,),
                  CustomTextBold(title: 'Volver', color: AppColors.primary900,),
                ],
              ),
            ),),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: Sizes.mainPadding),
            child: ResourceDetailPage()),
      ],
    );

  }

}