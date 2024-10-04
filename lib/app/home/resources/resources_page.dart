import 'package:enreda_empresas/app/common_widgets/custom_stepper_icon.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/resources/draft_resources_list.dart';
import 'package:enreda_empresas/app/home/resources/resource_detail/resource_detail_page.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

import '../web_home.dart';
import 'active_resources_list.dart';
import 'finished_resources_list.dart';


class ResourcesListPage extends StatefulWidget {
  const ResourcesListPage({super.key});

  static ValueNotifier<int> selectedIndex = ValueNotifier(1);

  @override
  State<ResourcesListPage> createState() => _ResourcesListPageState();
}

class _ResourcesListPageState extends State<ResourcesListPage> {
  var bodyWidget = [];

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void initState() {
    bodyWidget = [
      Container(),
      ActiveResourcesPage(),
      DraftResourcesPage(),
      FinishedResourcesPage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContents(context);
  }

  Widget _buildContents(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: ResourcesListPage.selectedIndex,
        builder: (context, selectedIndex, child) {
          return Stack(
            alignment: Responsive.isMobile(context) ? Alignment.topCenter : Alignment.topLeft,
            children: [
              Container(
                height: 80,
                padding: Responsive.isMobile(context) ? EdgeInsets.only(left: 10, top: 0) : EdgeInsets.symmetric(horizontal: Sizes.mainPadding * 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Responsive.isMobile(context) ? InkWell(
                        onTap: () {
                          setStateIfMounted(() {
                            WebHome.controller.selectIndex(0);
                            ResourcesListPage.selectedIndex.value = 1;
                          });
                        },
                        child: Icon(Icons.arrow_back, color: AppColors.greyTxtAlt,)) : Container(),
                    Responsive.isMobile(context) ? SpaceW12() : Container(),
                    InkWell(
                        onTap: () => {
                          setState(() {
                            ResourcesListPage.selectedIndex.value = 1;
                          })
                        },
                        child: selectedIndex == 1 || selectedIndex == 2 || selectedIndex == 3 ? CustomTextMediumBold(text: StringConst.MY_RESOURCES) :
                        CustomTextMedium(text: StringConst.MY_RESOURCES) ),
                  ],
                ),
              ),
              selectedIndex == 1 || selectedIndex == 2 || selectedIndex == 3 ?
              Positioned(
                top: 80,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.mainPadding * 2),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => {
                          setState(() {
                            ResourcesListPage.selectedIndex.value = 1;
                          })
                        },
                        child: CustomStepperIconButton(
                          child: CustomTextBold(title: StringConst.ACTIVE_RESOURCES, color: ResourcesListPage.selectedIndex.value == 1 ? AppColors.primary500 : AppColors.greyTxtAlt,),
                          icon: SizedBox(width: 21, child: ResourcesListPage.selectedIndex.value == 1 ? Image.asset(ImagePath.ICON_INSCRIPTION) : Image.asset(ImagePath.ICON_INVITATION),),
                          color: ResourcesListPage.selectedIndex.value == 1 ? AppColors.primary050 : AppColors.offWhite,
                        ),
                      ),
                      SizedBox(width: 10,),
                      InkWell(
                        onTap: () => {
                          setState(() {
                            ResourcesListPage.selectedIndex.value = 2;
                          })
                        },
                        child: CustomStepperIconButton(
                          child: CustomTextBold(title: StringConst.DRAFT_RESOURCES, color: ResourcesListPage.selectedIndex.value == 2 ? AppColors.primary500 : AppColors.greyTxtAlt,),
                          icon: SizedBox(width: 21, child: ResourcesListPage.selectedIndex.value == 2 ? Image.asset(ImagePath.ICON_INSCRIPTION) : Image.asset(ImagePath.ICON_INVITATION),),
                          color: ResourcesListPage.selectedIndex.value == 2 ? AppColors.primary050 : AppColors.offWhite,
                        ),
                      ),
                      SizedBox(width: 10,),
                      InkWell(
                        onTap: () => {
                          setState(() {
                            ResourcesListPage.selectedIndex.value = 3;
                          })
                        },
                        child: CustomStepperIconButton(
                          child: CustomTextBold(title: StringConst.FINISHED_RESOURCES, color: ResourcesListPage.selectedIndex.value == 3 ? AppColors.primary500 : AppColors.greyTxtAlt,),
                          icon: SizedBox(width: 21, child: ResourcesListPage.selectedIndex.value == 3 ? Image.asset(ImagePath.ICON_INSCRIPTION) : Image.asset(ImagePath.ICON_INVITATION),),
                          color: ResourcesListPage.selectedIndex.value == 3 ? AppColors.primary050 : AppColors.offWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ) : Container(),
              Container(
                margin: selectedIndex == 1 || selectedIndex == 2 || selectedIndex == 3  ? EdgeInsets.only(top: Sizes.mainPadding * 6) :
                EdgeInsets.only(top: Sizes.mainPadding * 2.5 , bottom: Sizes.mainPadding),
                child: bodyWidget[ResourcesListPage.selectedIndex.value],
              ),
            ],
          );
        });


  }
}
