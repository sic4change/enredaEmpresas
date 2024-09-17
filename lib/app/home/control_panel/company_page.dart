import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/participants/participants_page.dart';
import 'package:enreda_empresas/app/home/resources/my_resources_list_page.dart';
import 'package:enreda_empresas/app/models/company.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

import 'control_panel_page.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({Key? key, required this.company, required this.user}) : super(key: key);
final Company company;
final UserEnreda user;
  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  BuildContext? myContext;
  String codeDialog = '';
  String valueText = '';

  String _currentPageTitle = StringConst.CONTROL_PANEL;
  String _selectedPageName = StringConst.CONTROL_PANEL;
  Widget? _currentPage;

  late TextTheme textTheme;

  @override
  void initState() {
    _currentPage = ControlPanelPage(company: widget.company, user: widget.user,);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return Responsive.isDesktop(context) ||
        Responsive.isDesktopS(context)
        ? _buildDesktopLayout(widget.company, widget.user)
        : Container();
  }

  Widget _buildDesktopLayout(Company company, UserEnreda user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Flex(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildMyControlPanel(company, user),
                ],
              ),
            ),
            const SpaceW20(),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  padding: EdgeInsets.all(Sizes.mainPadding),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.greyLight2.withOpacity(0.2), width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                    color: AppColors.altWhite,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentPageTitle,
                        style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.penBlue,
                            fontSize: 16.0),
                      ),
                      const SpaceH8(),
                      Expanded(child: _currentPage!),
                    ],
                  ),
                ),
              ),
            ),
          ]),
    );
  }

  Widget _buildMobileLayout(UserEnreda userEnreda, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: Colors.white,
        ),
        child: ListView(
          children: <Widget>[
            //_buildMyControlPanel(socialEntity),
            const SpaceH20(),
            _currentPageTitle == StringConst.PERSONAL_DATA.toUpperCase() ||
                    _currentPageTitle == StringConst.MY_CV.toUpperCase()
                ? Container()
                : Padding(
                    padding: EdgeInsets.all(Sizes.mainPadding),
                    child: Text(
                      _currentPageTitle,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.penBlue,
                          fontSize: 16.0),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.all(
                  _currentPageTitle == StringConst.PERSONAL_DATA.toUpperCase()
                      ? 0.0
                      : 0.0),
              child: _currentPage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyControlPanel(Company? company, UserEnreda? user) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Sizes.mainPadding),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMyControlPanelRow(
            text: StringConst.CONTROL_PANEL,
            imagePath: ImagePath.ICON_CV,
            onTap: () => setState(() {
              _currentPage = ControlPanelPage(company: company, user: user,);
              _currentPageTitle = StringConst.CONTROL_PANEL;
              _selectedPageName = StringConst.CONTROL_PANEL;
            }),
          ),
          const SpaceH8(),
          _buildMyControlPanelRow(
            text: StringConst.PARTICIPANTS,
            imagePath: ImagePath.ICON_PROFILE_BLUE,
            onTap: () => setState(() {
              _currentPage = const ParticipantsListPage();
              _currentPageTitle = StringConst.PARTICIPANTS;
              _selectedPageName = StringConst.PARTICIPANTS;
            }),
          ),
          const SpaceH8(),
          _buildMyControlPanelRow(
            text: StringConst.RESOURCES,
            imagePath: ImagePath.ICON_COMPETENCIES,
            onTap: () => setState(() {
              _currentPage = MyResourcesListPage(company: company);
              _currentPageTitle = StringConst.RESOURCES;
              _selectedPageName = StringConst.RESOURCES;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMyControlPanelRow(
      {required String text,
      TextStyle? textStyle,
      String? imagePath,
      void Function()? onTap}) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: text == _selectedPageName
          ? AppColors.violet
          : AppColors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: AppColors.lightLilac,
        highlightColor: AppColors.violet,
        hoverColor: text == _selectedPageName
            ? AppColors.violet
            : AppColors.lightLilac,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (imagePath != null)
                Container(
                  width: 30,
                  child: Image.asset(
                    imagePath,
                    height: Sizes.ICON_SIZE_30,
                  ),
                ),
              const SpaceW12(),
              Expanded(
                  child: Text(
                text,
                style: textStyle ??
                    textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.penBlue,
                        fontSize: 16.0),
              )),
            ],
          ),
        ),
      ),
    );
  }

}

