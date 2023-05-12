import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/organizations/control_panel_page.dart';
import 'package:enreda_empresas/app/home/organizations/my_company_resources.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/sign_in/access/access_page.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({Key? key}) : super(key: key);

  @override
  _CompanyPageState createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  BuildContext? myContext;
  String codeDialog = '';
  String valueText = '';
  Widget? _currentPage = const ControlPanelPage();

  String _currentPageTitle = StringConst.CONTROL_PANEL;
  String _selectedPageName = StringConst.CONTROL_PANEL;

  late UserEnreda _userEnreda;
  late TextTheme textTheme;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);
    textTheme = Theme.of(context).textTheme;

    return StreamBuilder<User?>(
        stream: Provider.of<AuthBase>(context).authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder<UserEnreda>(
              stream: database.userEnredaStreamByUserId(auth.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _userEnreda = snapshot.data!;
                  return Responsive.isDesktop(context) ||
                          Responsive.isDesktopS(context)
                      ? _buildDesktopLayout(_userEnreda)
                      : _buildMobileLayout(_userEnreda, context);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          } else if (!snapshot.hasData) {
            return const AccessPage();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildDesktopLayout(UserEnreda userEnreda) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Flex(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMyControlPanel(userEnreda),
                  ],
                ),
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
                    border: Border.all(color: AppColors.greyLight, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                    color: AppColors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentPageTitle,
                        style: textTheme.bodyText1?.copyWith(
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
            _buildMyControlPanel(userEnreda),
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

  Widget _buildMyControlPanel(UserEnreda? userEnreda) {
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
              _currentPage = const ControlPanelPage();
              _currentPageTitle = StringConst.CONTROL_PANEL;
              _selectedPageName = StringConst.CONTROL_PANEL;
            }),
          ),
          _buildMyControlPanelRow(
            text: StringConst.PARTICIPANTS,
            imagePath: ImagePath.ICON_PROFILE_BLUE,
            onTap: () => setState(() {
              _currentPage = Container();
              _currentPageTitle = StringConst.PARTICIPANTS;
              _selectedPageName = StringConst.PARTICIPANTS;
            }),
          ),
          _buildMyControlPanelRow(
            text: StringConst.RESOURCES,
            imagePath: ImagePath.ICON_COMPETENCIES,
            onTap: () => setState(() {
              _currentPage = const CompanyResourcesPage();
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
      color: text == _selectedPageName
          ? AppColors.violet
          : AppColors.white,
      child: InkWell(
        splashColor: AppColors.lightLilac,
        highlightColor: AppColors.violet,
        hoverColor: text == _selectedPageName
            ? AppColors.violet
            : AppColors.lightLilac,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
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
