import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/enreda_button.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/account/personal_data.dart';
import 'package:enreda_empresas/app/home/resources/create_resource/create_resource.dart';
import 'package:enreda_empresas/app/home/side_bar_widget.dart';
import 'package:enreda_empresas/app/home/control_panel/control_panel_page.dart';
import 'package:enreda_empresas/app/home/participants/participants_page.dart';
import 'package:enreda_empresas/app/home/resources/resources_list_page.dart';
import 'package:enreda_empresas/app/home/tool_box/tool_box_page.dart';
import 'package:enreda_empresas/app/models/company.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/sign_in/access/access_page.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/functions.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;

import 'external_social_entity/entity_directory_page.dart';

class WebHome extends StatefulWidget {
  const WebHome({Key? key})
      : super(key: key);

  static final SidebarXController controller = SidebarXController(selectedIndex: 0, extended: true);
  static ValueNotifier<int> selectedIndex = ValueNotifier(2);

  static goCreateJobOffer() {
    WebHome.selectedIndex.value = 1; // WebHome init state
  }

  static goToMyProfile() {
    WebHome.selectedIndex.value = 0; // WebHome init state
  }

  static goToControlPanel() {
    WebHome.selectedIndex.value = 2; // Select empty Container
    WebHome.controller.selectIndex(0);
  }

  static goJobOffers() {
    WebHome.selectedIndex.value = 2; // Select empty Container
    WebHome.controller.selectIndex(1);
  }

  static goToParticipants() {
    WebHome.selectedIndex.value = 2; // Select empty Container
    WebHome.controller.selectIndex(1);
    ParticipantsListPage.selectedIndex.value = 0;
  }

  static goToEntities() {
    WebHome.selectedIndex.value = 2; // Select empty Container
    WebHome.controller.selectIndex(4);
    EntityDirectoryPage.selectedIndex.value = 0;
  }

  static goToolBox() {
    WebHome.selectedIndex.value = 2; // Select empty Container
    WebHome.controller.selectIndex(3);
  }

  @override
  State<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
  var bodyWidget = [];
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    bodyWidget = [
      const PersonalData(),
      const CreateJobOffer(),
      Container(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<User?>(
              stream: Provider.of<AuthBase>(context).authStateChanges(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const AccessPage();
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.active) {
                  return StreamBuilder<UserEnreda>(
                      stream: database.userEnredaStreamByUserId(auth.currentUser!.uid),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                        if (snapshot.hasData){
                          var user = snapshot.data!;
                          var userName = '${user.firstName ?? ""} ${user.lastName ?? ""}';
                          var profilePic = user.photo ?? "";
                          if (user.role != 'Empresa') {
                            _unemployedSignOut(context);
                            return Container();
                          }
                          return StreamBuilder<Company>(
                              stream: database.companyStreamById(user.companyId!),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                                if (snapshot.hasData) {
                                  var company = snapshot.data!;
                                  globals.currentUserCompany = company;
                                  return _buildContent(context, company, user, profilePic, userName);
                                }
                                return const Center(child: CircularProgressIndicator());
                              });
                        }
                        return const Center(child: CircularProgressIndicator());
                      }
                  );
                } return const Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildContent(BuildContext context, Company company, UserEnreda user, String profilePic, String userName){
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ValueListenableBuilder<int>(
        valueListenable: WebHome.selectedIndex,
        builder: (context, selectedIndex, child) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          return Scaffold(
            key: _key,
            appBar: AppBar(
              toolbarHeight: 80,
              elevation: 0.4,
              backgroundColor: AppColors.white,
              leading: isSmallScreen ? IconButton(
                onPressed: () {
                  _key.currentState?.openDrawer();
                },
                icon: const Icon(Icons.menu),
              ) : Container(),
              title: Transform(
                transform:  Responsive.isMobile(context) ? Matrix4.translationValues(0.0, 0.0, 0.0) : Matrix4.translationValues(-40.0, 0.0, 0.0),
                child: Row(
                  children: [
                    Image.asset(
                      ImagePath.LOGO,
                      height: Responsive.isMobile(context) ? 35 : 50,
                    ),
                    !isSmallScreen ? _buildMyCompanyName(context, company) : Container(),
                  ],
                ),
              ),
              actions: <Widget>[
                const SizedBox(width: 10),
                if (!auth.isNullUser)
                  SizedBox(
                    width: 35,
                    child: InkWell(
                      onTap: () => _confirmSignOut(context),
                      child: Image.asset(
                        ImagePath.LOGOUT,
                        height: Sizes.ICON_SIZE_30,
                      ),),
                  ),
                const SizedBox(width: 50,)
              ],
            ),
            drawer: SideBarWidget(controller: WebHome.controller, profilePic: profilePic, userName: userName, keyWebHome: _key,),
            body: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1600),
                child: Padding(
                  padding: Responsive.isMobile(context) ? const EdgeInsets.all(0.0) : const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      if(!isSmallScreen) SideBarWidget(controller: WebHome.controller, profilePic: profilePic, userName: userName, keyWebHome: _key,),
                      if (WebHome.selectedIndex.value == 0) Expanded(child: Center(child: bodyWidget[0]))
                      else if (WebHome.selectedIndex.value == 1) Expanded(child: Center(child: bodyWidget[1]))
                      else Expanded(child: Center(child: AnimatedBuilder(
                        animation: WebHome.controller,
                        builder: (context, child){
                          switch(WebHome.controller.selectedIndex){
                            case 0: _key.currentState?.closeDrawer();
                            return ControlPanelPage(company: company, user: user,);
                            case 1: _key.currentState?.closeDrawer();
                            return MyResourcesListPage();
                            case 2: _key.currentState?.closeDrawer();
                            return ToolBoxPage();
                            case 3: _key.currentState?.closeDrawer();
                            return EntityDirectoryPage(socialEntity: company);
                            default:
                              return MyResourcesListPage();
                          }
                        },
                      ),))
                    ],
                  ),
                ),
              ),
            ),

          );
        });

  }

  Widget _buildMyCompanyName(BuildContext context, Company socialEntity) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(' &  ${socialEntity.name}',
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary900,
                fontSize: 16.0,)
          ),
        ),
      ],
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Cerrar sesión',
        content: '¿Estás seguro que quieres cerrar sesión?',
        cancelActionText: 'Cancelar',
        defaultActionText: 'Cerrar');
    if (didRequestSignOut == true) {
      await auth.signOut();
      GoRouter.of(context).go(StringConst.PATH_HOME);
    }
  }
}


Future<void> _unemployedSignOut(BuildContext context) async {
  String targetWeb = "";
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 14, 18, md: 15);
    await showDialog(
      context: context,
      builder: (BuildContext context) => Center(
        child: AlertDialog(
          insetPadding: const EdgeInsets.all(20),
          contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 30),
          content: SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImagePath.LOGO,
                    height: 30,
                  ),
                  const SpaceH20(),
                  Text(StringConst.ARENT_YOU_SOCIAL_COMPANY,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.greyDark,
                        height: 1.5,
                        fontWeight: FontWeight.w800,
                        fontSize: fontSize,
                      )
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: EnredaButton(
                  width: 250.0,
                  buttonTitle: StringConst.GO_YOUNG_WEB,
                  onPressed: () {
                    targetWeb = StringConst.WEB_APP_URL_ACCESS;
                    auth.signOut();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
              child: Center(
                child: EnredaButton(
                  width: 250.0,
                  buttonTitle: StringConst.GO_MAIN_WEB,
                  onPressed: () {
                    targetWeb = StringConst.NEW_WEB_APP_URL;
                    auth.signOut();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ).then((exit) {
      if (exit == null) {
        auth.signOut();
        launchURL(targetWeb);
      }
    });
  });
}