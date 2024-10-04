import 'package:enreda_empresas/app/home/applicants/registered_applicants.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/applicants/pre_selected_applicants.dart';
import 'package:enreda_empresas/app/home/applicants/selected_list_page.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;

import '../../models/resource.dart';
import '../resources/manage_offers_page.dart';

class ApplicantsListPage extends StatefulWidget {
  const ApplicantsListPage({super.key,});

  @override
  State<ApplicantsListPage> createState() => _ApplicantsListPageState();
}

class _ApplicantsListPageState extends State<ApplicantsListPage> {
  List<String> _menuOptions = [
    StringConst.JOB_OFFER_REGISTERED,
    StringConst.JOB_OFFER_PRE_SELECTED,
    StringConst.JOB_OFFER_FINALIST];
  Widget? _currentPage;
  String? _value;

  @override
  void initState() {
    _value = _menuOptions[0];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    if (_currentPage == null) {
      _currentPage =  RegisteredApplicantsListPage();
    }
    return Responsive.isDesktop(context)? _buildParticipantWeb(context):
    _buildParticipantMobile(context);
  }

  Widget _buildParticipantWeb(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context, globals.currentResource!),
            Divider(
              indent: 0,
              endIndent: 0,
              color: AppColors.greyBorder,
              thickness: 1,
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 22.0,0.0,22.0),
              child: _buildMenuSelectorChips(context),
            ),
            Divider(
              indent: 0,
              endIndent: 0,
              color: AppColors.greyBorder,
              thickness: 1,
              height: 0,
            ),
            SpaceH12(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.mainPadding, vertical: 0.0),
              child: _currentPage!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantMobile(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, globals.currentResource!),
          SpaceH20(),
          _buildMenuSelectorChips(context),
          SpaceH20(),
          _currentPage!,
        ],
      ),
    );
  }

  Widget _buildMenuSelectorChips(BuildContext context){
    return Wrap(
      spacing: 20.0,
      runSpacing: 20.0,
      children: List<Widget>.generate(3,
            (int index) {
          return ChoiceChip(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                side: BorderSide(color: _value == _menuOptions[index] ? Colors.transparent : AppColors.violet)),
            disabledColor: Colors.white,
            selectedColor: AppColors.yellow,
            labelStyle: TextStyle(
              fontSize: Responsive.isMobile(context)? 12.0: 16.0,
              fontWeight: _value == _menuOptions[index] ? FontWeight.w700 : FontWeight.w400,
              color: _value == _menuOptions[index] ? AppColors.turquoiseBlue : AppColors.greyTxtAlt,

            ),
            label: Text(_menuOptions[index]),
            selected: _value == _menuOptions[index],
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            showCheckmark: false,
            onSelected: (bool selected) {
              setState(() {
                _value = _menuOptions[index];
                switch (index) {
                  case 0:
                    _currentPage = RegisteredApplicantsListPage();
                  case 1:
                    _currentPage = PreSelectedApplicantsListPage();
                    break;
                  case 2:
                    _currentPage = SelectedApplicantsListPage();
                    break;
                  default:
                    _currentPage = Container();
                    break;
                }

              });
            },
          );
        },
      ).toList(),
    );
  }

  Widget _buildHeader(BuildContext context, Resource resource) {
    return Padding(
      padding: const EdgeInsets.only(left: Sizes.kDefaultPaddingDouble*2),
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextMediumBold(text: '${resource.title}'),
            InkWell(
              onTap: (){
                setState(() {
                  ManageOffersPage.selectedIndex.value = 1;
                });
              },
              child: Row(
                children: [
                  CustomTextSmallColor(text: 'Inscritos en esta oferta: ', color: AppColors.primary900),
                  CustomTextSmallColor(text: 'Ver oferta' , color: AppColors.primary900)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

