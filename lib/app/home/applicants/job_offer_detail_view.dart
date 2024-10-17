import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/home/resources/resource_detail/resource_detail_page.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'applicants_list_page.dart';

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