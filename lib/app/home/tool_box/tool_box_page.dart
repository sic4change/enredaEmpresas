import 'package:enreda_empresas/app/common_widgets/custom_stepper_button.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/rounded_container.dart';
import 'package:enreda_empresas/app/home/tool_box/enreda_methodology.dart';
import 'package:enreda_empresas/app/home/tool_box/workflow_page.dart';
import 'package:enreda_empresas/app/models/company.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';


class ToolBoxPage extends StatefulWidget {
  const ToolBoxPage({super.key});

  static ValueNotifier<int> selectedIndex = ValueNotifier(1);

  @override
  State<ToolBoxPage> createState() => _ToolBoxPageState();
}

class _ToolBoxPageState extends State<ToolBoxPage> {
  bool? isVisible = true;
  List<UserEnreda>? myParticipantsList = [];
  List<String>? interestsIdsList = [];
  Company? organizer;
  List<String> interestSelectedName = [];
  var bodyWidget = [];

  @override
  void initState() {
    bodyWidget = [
      Container(child: Column(
        children: [
          Text('Pagina principal'),
          Spacer(),
        ],
      ),),
      EnredaMethodologyPage(),
      WorkflowPage()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: ToolBoxPage.selectedIndex,
        builder: (context, selectedIndex, child) {
          return RoundedContainer(
            borderColor: Responsive.isMobile(context) ? Colors.transparent : AppColors.greyLight,
            margin: Responsive.isMobile(context) ? EdgeInsets.all(0) : EdgeInsets.all(Sizes.kDefaultPaddingDouble),
            contentPadding: EdgeInsets.all(Responsive.isDesktop(context)? Sizes.kDefaultPaddingDouble*2: Sizes.kDefaultPaddingDouble,) ,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 60,
                          child: Flex(
                            direction: Responsive.isMobile(context) ? Axis.vertical : Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                  onTap: () => {
                                    setState(() {
                                      ToolBoxPage.selectedIndex.value = 1;
                                    })
                                  },
                                  child: selectedIndex != 0 ? CustomTextMedium(text: StringConst.TOOL_BOX) :
                                  CustomTextMediumBold(text: StringConst.TOOL_BOX) ),
                              selectedIndex == 1 ? CustomTextMediumBold(text: '> ${StringConst.ENREDA_METHODOLOGY}',) :
                              selectedIndex == 2 ? CustomTextMediumBold(text:'> ${StringConst.WORKFLOW}') : Container()
                            ],
                          ),
                        ),
                      ],
                    ),
                    Flex(
                      direction: Responsive.isMobile(context) ? Axis.vertical : Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => {
                            setState(() {
                              ToolBoxPage.selectedIndex.value = 1;
                            })
                          },
                          child: CustomStepperButton(
                            child: CustomTextBold(title: StringConst.ENREDA_METHODOLOGY, color: AppColors.turquoiseBlue,),
                            color: ToolBoxPage.selectedIndex.value == 1 ? AppColors.yellow : AppColors.white,
                          ),
                        ),
                        // Responsive.isMobile(context) ? SizedBox(height: Sizes.mainPadding,) : SizedBox(width: Sizes.mainPadding,),
                        // InkWell(
                        //   onTap: () => {
                        //     setState(() {
                        //       ToolBoxPage.selectedIndex.value = 2;
                        //     })
                        //   },
                        //   child: CustomStepperButton(
                        //     child: CustomTextBold(title: StringConst.WORKFLOW, color: AppColors.turquoiseBlue,),
                        //     color: ToolBoxPage.selectedIndex.value == 2 ? AppColors.yellow : AppColors.white,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
                Container(
                    //margin: Responsive.isMobile(context) ? EdgeInsets.only(top: Sizes.mainPadding * 9) : EdgeInsets.only(top: Sizes.mainPadding * 6),
                    margin: Responsive.isMobile(context) ? EdgeInsets.only(top: Sizes.mainPadding * 6) : EdgeInsets.only(top: Sizes.mainPadding * 6),
                    child: bodyWidget[selectedIndex]),
              ],
            ),
          );
        });

  }



}
