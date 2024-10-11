import 'package:enreda_empresas/app/common_widgets/add_yellow_button.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/rounded_container.dart';
import 'package:enreda_empresas/app/home/resources/edit_resource/edit_resource.dart';
import 'package:enreda_empresas/app/home/resources/resource_detail/resource_detail_page.dart';
import 'package:enreda_empresas/app/home/resources/resources_page.dart';
import 'package:enreda_empresas/app/models/company.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;
import '../../values/strings.dart';
import '../applicants/applicants_list_page.dart';
import '../web_home.dart';


class ManageOffersPage extends StatefulWidget {
  const ManageOffersPage({super.key});

  static ValueNotifier<int> selectedIndex = ValueNotifier(0);

  @override
  State<ManageOffersPage> createState() => _ManageOffersPageState();
}

class _ManageOffersPageState extends State<ManageOffersPage> {
  bool? isVisible = true;
  List<UserEnreda>? myParticipantsList = [];
  List<String>? interestsIdsList = [];
  Company? organizer;
  List<String> interestSelectedName = [];
  var bodyWidget = [];

  @override
  void initState() {
    bodyWidget = [
      ResourcesListPage(),
      ResourceDetailPage(),
      EditResource(),
      ApplicantsListPage()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: ManageOffersPage.selectedIndex,
        builder: (context, selectedIndex, child) {
          return RoundedContainer(
            borderColor: Responsive.isMobile(context) ? Colors.transparent : AppColors.greyLight,
            contentPadding: const EdgeInsets.only(left: 0, right: Sizes.kDefaultPaddingDouble,
                bottom: Sizes.kDefaultPaddingDouble, top: Sizes.kDefaultPaddingDouble),
            child: Stack(
              children: [
                Flex(
                  direction: Responsive.isMobile(context) ? Axis.vertical : Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      padding: Responsive.isMobile(context) ? EdgeInsets.only(left: Sizes.kDefaultPaddingDouble / 2) :
                      EdgeInsets.symmetric(vertical: Sizes.mainPadding, horizontal: Sizes.mainPadding * 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => {
                              setState(() {
                                ManageOffersPage.selectedIndex.value = 0;
                              })
                            },
                            child: selectedIndex != 0 ? CustomTextMedium(text: StringConst.MY_JOB_OFFERS) :
                              CustomTextMediumBold(text: StringConst.MY_JOB_OFFERS) ),
                              selectedIndex == 1 || selectedIndex == 3 ? CustomTextMediumBold(text:'> ${globals.currentResource?.title}') :
                              selectedIndex == 2 ? Row(
                            children: [
                              InkWell(
                                  onTap: () => {
                                    setState(() {
                                      ManageOffersPage.selectedIndex.value = 1;
                                    })
                                  },
                                  child: CustomTextMedium(text:'> ${globals.currentResource?.title} ')),
                              CustomTextMediumBold(text:'> Editar oferta de empleo'),
                            ],
                          ) : Container()
                        ],
                      ),
                    ),
                    Responsive.isMobile(context) ? Container() : Spacer(),
                    selectedIndex == 0 ?
                    Padding(
                      padding: Responsive.isMobile(context) ? EdgeInsets.zero : EdgeInsets.only(right: Sizes.mainPadding, top: Sizes.mainPadding),
                      child: Align(
                          alignment: Responsive.isMobile(context) ? Alignment.center : Alignment.topRight,
                          child: AddYellowButton(
                            text: 'Crear oferta de empleo',
                            onPressed: () => setState(() {
                              setState(() {
                                WebHome.selectedIndex.value = 1;
                              });
                            }),
                          )
                      ),
                    ) : Container(),
                  ],
                ),
                Container(
                    margin: selectedIndex != 0 && Responsive.isMobile(context) ? EdgeInsets.only(top: Sizes.mainPadding * 6) :
                    Responsive.isMobile(context) ? EdgeInsets.only(top: Sizes.mainPadding * 6, left: Sizes.mainPadding / 2) :
                      selectedIndex == 1 || selectedIndex == 2 ? EdgeInsets.symmetric(vertical: Sizes.mainPadding * 3, horizontal: Sizes.mainPadding * 2) :
                      EdgeInsets.only(top: Sizes.mainPadding * 3),
                    child: bodyWidget[selectedIndex]),
              ],
            ),
          );
        });

  }

}
