import 'package:enreda_empresas/app/common_widgets/custom_stepper_icon.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/resources/my_draft_resources_list.dart';
import 'package:enreda_empresas/app/home/resources/resource_detail/resource_detail_page.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

import '../web_home.dart';
import 'my_active_resources_list.dart';


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
      ResourceDetailPage(),
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
                height: 50,
                padding: Responsive.isMobile(context) ? EdgeInsets.only(left: 10, top: 0) : EdgeInsets.all(0),
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
                        child: selectedIndex == 1 || selectedIndex == 2 ? CustomTextMediumBold(text: StringConst.MY_RESOURCES) :
                        CustomTextMedium(text: StringConst.MY_RESOURCES) ),
                    selectedIndex == 3 ? CustomTextMediumBold(text: '> Detalle de la oferta',) : Container()
                  ],
                ),
              ),
              selectedIndex == 1 || selectedIndex == 2 ?
              Positioned(
                top: 60,
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: () => {
                        setState(() {
                          ResourcesListPage.selectedIndex.value = 1;
                        })
                      },
                      child: CustomStepperIconButton(
                        child: CustomTextBold(title: StringConst.ACTIVE_RESOURCES, color: ResourcesListPage.selectedIndex.value == 1 ? AppColors.white : AppColors.greyTxtAlt,),
                        icon: SizedBox(width: 21, child: Icon(Icons.check, color: ResourcesListPage.selectedIndex.value == 1 ? AppColors.white : AppColors.greyTxtAlt,)),
                        color: ResourcesListPage.selectedIndex.value == 1 ? AppColors.primaryColor : AppColors.greyUltraLight,
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
                        child: CustomTextBold(title: StringConst.DRAFT_RESOURCES, color: ResourcesListPage.selectedIndex.value == 2 ? AppColors.white : AppColors.greyTxtAlt,),
                        icon: SizedBox(width: 21, child: Icon(Icons.favorite, color: ResourcesListPage.selectedIndex.value == 2 ? AppColors.white : AppColors.greyTxtAlt, size: 21,)),
                        color: ResourcesListPage.selectedIndex.value == 2 ? AppColors.primaryColor : AppColors.greyUltraLight,
                      ),
                    ),
                  ],
                ),
              ) : Container(),
              Container(
                margin: selectedIndex == 1 || selectedIndex == 2 ? EdgeInsets.only(top: Sizes.mainPadding * 5) :
                EdgeInsets.only(top: Sizes.mainPadding * 2.5 , bottom: Sizes.mainPadding),
                child: bodyWidget[ResourcesListPage.selectedIndex.value],
              ),
            ],
          );
        });


  }
}
