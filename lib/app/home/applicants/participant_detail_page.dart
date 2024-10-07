import 'package:enreda_empresas/app/common_widgets/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;

import '../../common_widgets/custom_my_location.dart';
import '../../common_widgets/custom_text.dart';
import '../../common_widgets/spaces.dart';
import '../../models/jobOfferApplication.dart';
import '../../models/userEnreda.dart';
import '../../utils/responsive.dart';
import '../../values/strings.dart';
import '../../values/values.dart';
import 'applicants_list_page.dart';

class ParticipantDetailPage extends StatefulWidget {
  const ParticipantDetailPage({Key? key}) : super(key: key);

  @override
  State<ParticipantDetailPage> createState() => _ParticipantDetailPageState();
}

class _ParticipantDetailPageState extends State<ParticipantDetailPage> {
late UserEnreda currentParticipant;
late JobOfferApplication currentApplication;

  @override
  void initState() {
    currentParticipant = globals.currentParticipant!;
    currentApplication = globals.currentApplication!;
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return _buildParticipant(context);
  }

  Widget _buildParticipant(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
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
              SizedBox(height: 10,),
              _buildHeader(context),
            ],
          ),
        ),);
  }


  Widget _buildHeader(BuildContext context) {
    int _getTypeIndex(String type) {
      switch (type) {
        case 'academic':
          return 0;
        case 'experience':
          return 1;
        case 'languages':
          return 2;
        case 'competencies':
          return 3;
        default:
          return -1; // indicate an invalid type
      }
    }
    String _getDisplayText(String type) {
      List<String> textValues = [
        'Formación académica',
        'Nivel de experiencia',
        'Idiomas',
        'Competencias',
      ];

      int index = _getTypeIndex(type);

      if (index >= 0 && index < textValues.length) {
        return textValues[index];
      } else {
        return '';
      }
    }
    return RoundedContainer(
      margin: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.mainPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20, bottom: 0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child:
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(160)),
                      child:
                      Center(
                        child:
                        currentParticipant.photo == "" ?
                        Container(
                          color:  Colors.transparent,
                          height: 90,
                          width: 90,
                          child: Image.asset(ImagePath.USER_DEFAULT),
                        ):
                        FadeInImage.assetNetwork(
                          placeholder: ImagePath.USER_DEFAULT,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          image: currentParticipant.photo ?? "",
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top:20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomTextBoldTitle(
                                title: '${currentParticipant.firstName} ${currentParticipant.lastName}',),
                            ),
                            SpaceW40(),
                          ],
                        ),
                        SpaceH8(),
                        Row(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.mail,
                                  color: AppColors.darkGray,
                                  size: 22.0,
                                ),
                                const SpaceW4(),
                                CustomTextSmall(text: currentParticipant.email,),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.phone,
                                    color: AppColors.darkGray,
                                    size: 22.0,
                                  ),
                                  const SpaceW4(),
                                  CustomTextSmall(text: currentParticipant.phone ?? '',)
                                ],
                              ),
                            ),
                            MyCustomLocation(context, currentParticipant),
                          ],
                        )

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: Sizes.mainPadding),
              child: Flex(
                direction: Responsive.isMobile(context) ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildEvaluationWeight(_getDisplayText(currentApplication.criteria![0].type), currentApplication.criteria![0].weight.toString()),
                  _buildEvaluationWeight(_getDisplayText(currentApplication.criteria![1].type), currentApplication.criteria![1].weight.toString()),
                  _buildEvaluationWeight(_getDisplayText(currentApplication.criteria![2].type), currentApplication.criteria![2].weight.toString()),
                  _buildEvaluationWeight(_getDisplayText(currentApplication.criteria![3].type), currentApplication.criteria![3].weight.toString()),
                ],
              ),
            ),
          ),
          Divider(
            indent: 0,
            endIndent: 0,
            color: AppColors.greyBorder,
            thickness: 1,
            height: 1,
          ),
        ],
      ),
    );
  }

Widget _buildEvaluationWeight(String title, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppColors.white,
        border: Border.all(color: AppColors.primaryColor),
      ),
      width: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTextBold(title: title, color: AppColors.primary900,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextSmallBold(title: label, color: AppColors.primaryColor,),
              CustomTextSmall(text: '/10', color: AppColors.primaryColor,),
            ],
          ),
        ],
      ),
    ),
  );
}

}