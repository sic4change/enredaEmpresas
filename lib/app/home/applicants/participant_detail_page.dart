import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;
import 'package:provider/provider.dart';

import '../../common_widgets/custom_button.dart';
import '../../common_widgets/custom_my_location.dart';
import '../../common_widgets/custom_text.dart';
import '../../common_widgets/gamification_item.dart';
import '../../common_widgets/gamification_slider.dart';
import '../../common_widgets/spaces.dart';
import '../../models/jobOfferApplication.dart';
import '../../models/jobOfferCriteria.dart';
import '../../models/userEnreda.dart';
import '../../services/database.dart';
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
    final database = Provider.of<Database>(context, listen: false);
    return SingleChildScrollView(
        child: RoundedContainer(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    Spacer(),
                    CustomButton(
                        text: 'Descartar',
                        onTap: () async {
                          currentApplication.status = 'not-selected';
                          await database.setJobOfferApplication(currentApplication);
                          showAlertDialog(context,
                              title: StringConst.SAVE_SUCCEED,
                              content: StringConst.JOB_OFFER_NOT_SELECTED,
                              defaultActionText: StringConst.FORM_CONFIRM,).then((value) {
                            ApplicantsListPage.selectedIndex.value = 0;
                          });
                        },
                        color: Colors.red),
                    SizedBox(width: 10,),
                    CustomButton(
                        text: 'Enviar a preseleccionados',
                        onTap: () async {
                          currentApplication.status = 'pre-selected';
                          await database.setJobOfferApplication(currentApplication);
                          showAlertDialog(context,
                            title: StringConst.SAVE_SUCCEED,
                            content: StringConst.JOB_OFFER_PRE_SELECTED_CONFIRMATION,
                            defaultActionText: StringConst.FORM_CONFIRM,).then((value) {
                            ApplicantsListPage.selectedIndex.value = 1;
                            });
                        },
                        color: AppColors.primaryColor),
                    SizedBox(width: 10,),
                  ],
                ),
                SizedBox(height: 10,),
                _buildHeader(context),
              ],
            ),
          ),
        ),);
  }


  Widget _buildHeader(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizes.mainPadding, vertical: Sizes.mainPadding ),
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
              GamificationItem(
                imagePath: ImagePath.GAMIFICATION_CHAT_ICON,
                progress: currentApplication.match!,
                title: StringConst.JOB_OFFER_MATCH.toUpperCase(),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: Sizes.mainPadding),
          child: Flex(
            direction: Responsive.isMobile(context) ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: currentApplication.evaluations.entries.map((entry) {
              Widget displayText = StreamBuilder<JobOfferCriteria>(
                stream: database.jobOfferCriteriaById(entry.key),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Text('No encontrado');
                  } else {
                    var jobOfferCriteria = snapshot.data!;
                    return CustomTextSmallBold(
                      title: '${StringConst.JOB_OFFER_EVALUATION.toUpperCase() +'  '+ jobOfferCriteria.name!.toUpperCase()}',
                      color: AppColors.primary900,
                    );
                  }
                },
              );
              int weight = entry.value;
              return _buildEvaluationResults(displayText, weight);
            }).toList(),
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
    );
  }

Widget _buildEvaluationResults(Widget title, int label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppColors.primary100,
        border: Border.all(color: AppColors.primary100),
      ),
      width: 280,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          title,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextMediumBold(text: label.toString()),
              CustomTextMedium(text: ' / 100'),
            ],
          ),
        ],
      ),
    ),
  );
}

}