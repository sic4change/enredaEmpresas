
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/rounded_container.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/participants/participants_page.dart';
import 'package:enreda_empresas/app/home/participants/participants_tile.dart';
import 'package:enreda_empresas/app/home/web_home.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/my_custom_scroll_behavior.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;

import '../../models/city.dart';
import '../../models/company.dart';
import '../../models/country.dart';
import '../../models/jobOffer.dart';
import '../../models/province.dart';
import '../../models/resource.dart';
import '../applicants/registered_applicants.dart';
import 'all_resources_list.dart';
import 'builders/list_item _horizontal_builder.dart';
import 'manage_offers_page.dart';
import 'resource_list_tile.dart';

class AllResourcesScrollPage extends StatefulWidget {
  const AllResourcesScrollPage({Key? key}) : super(key: key);

  @override
  State<AllResourcesScrollPage> createState() => _AllResourcesScrollPageState();
}

class _AllResourcesScrollPageState extends State<AllResourcesScrollPage> {
  @override
  Widget build(BuildContext context) {
    return buildResourcesList(context);
  }

  Widget buildResourcesList(BuildContext context) {
    final controller = ScrollController();
    var scrollJump = Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.96 :
    Responsive.isDesktopS(context) ? 350 : 410;
    return RoundedContainer(
      color: Colors.white,
      borderWith: 1,
      borderColor: AppColors.greyLight2.withOpacity(0.3),
      contentPadding: Responsive.isMobile(context) || Responsive.isDesktopS(context) ? EdgeInsets.all(10.0) : EdgeInsets.all(20.0),
      margin: Responsive.isMobile(context) || Responsive.isDesktopS(context) ? EdgeInsets.all(0) : EdgeInsets.only(left: 30, right: 10, bottom: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomTextBoldTitle(title: StringConst.MANAGE_OFFERS),
          SpaceH4(),
          Column(
            children: [
              Container(
                  constraints: BoxConstraints(
                    maxWidth: Responsive.isDesktopS(context) ? 350 * 3 : 430 * 3,
                  ),
                  height: 270,
                  child: AllResourcesList(
                    controller: controller,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      if (controller.position.pixels >=
                          controller.position.minScrollExtent)
                        controller.animateTo(
                            controller.position.pixels - scrollJump,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                    },
                    child: Image.asset(
                      ImagePath.ARROW_BACK,
                      width: 36.0,
                    ),
                  ),
                  SpaceW12(),
                  InkWell(
                    onTap: () {
                      if (controller.position.pixels <=
                          controller.position.maxScrollExtent)
                        controller.animateTo(
                            controller.position.pixels + scrollJump,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                    },
                    child: Image.asset(
                      ImagePath.ARROW_FORWARD,
                      width: 36.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
