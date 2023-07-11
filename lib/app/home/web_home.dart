import 'package:cached_network_image/cached_network_image.dart';
import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/enreda_button.dart';
import 'package:enreda_empresas/app/common_widgets/precached_avatar.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/account/personal_data.dart';
import 'package:enreda_empresas/app/home/organization/control_panel_page.dart';
import 'package:enreda_empresas/app/home/participants/participants_page.dart';
import 'package:enreda_empresas/app/home/resources/my_resources_list_page.dart';
import 'package:enreda_empresas/app/models/organization.dart';
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


class WebHome extends StatefulWidget {
  const WebHome({Key? key})
      : super(key: key);

  static ValueNotifier<int> selectedIndex = ValueNotifier(0);

  static goToResources() {
    selectedIndex.value = 1;
  }

  @override
  State<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
  var bodyWidget = [];
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    bodyWidget = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);
    return ValueListenableBuilder<int>(
        valueListenable: WebHome.selectedIndex,
        builder: (context, selectedIndex, child) {
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
                          var profilePic = user.photo ?? "";
                          if (user.role != 'Organización') {
                            _unemployedSignOut(context);
                            return Container();
                          }
                          return StreamBuilder<Organization>(
                              stream: database.organizationStreamById(user.organization!),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                                if (snapshot.hasData) {
                                  var organization = snapshot.data!;
                                  return _buildContent(context, organization, user, profilePic);
                                }
                                return const Center(child: CircularProgressIndicator());
                              });
                        }
                        return const Center(child: CircularProgressIndicator());
                      }
                  );
                } return const Center(child: CircularProgressIndicator());
              });
        });
  }

  Widget _buildContent(BuildContext context, Organization organization, UserEnreda user, String profilePic){
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Builder(
      builder: (context) {
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
                    height: 24,
                  ),
                  !isSmallScreen ? _buildMyCompanyName(context, organization) : Container(),
                ],
              ),
            ),
            actions: <Widget>[
              InkWell(
                  onTap: () {
                  },
                  child: _buildMyUserFoto(context, profilePic)
              ),
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
          drawer: SideBarWidget(controller: _controller,),
          body: Padding(
            padding: Responsive.isMobile(context) ? const EdgeInsets.all(0.0) : const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                if(!isSmallScreen) SideBarWidget(controller: _controller),
                Expanded(child: Center(child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context,child){
                    switch(_controller.selectedIndex){
                      case 0: _key.currentState?.closeDrawer();
                      return ControlPanelPage(organization: organization, user: user,);
                      case 1: _key.currentState?.closeDrawer();
                      return const ParticipantsListPage();
                      case 2: _key.currentState?.closeDrawer();
                      return const MyResourcesListPage();
                      case 3: _key.currentState?.closeDrawer();
                      return const PersonalData();
                      default:
                        return const MyResourcesListPage();
                    }
                  },
                ),))
              ],
            ),
          ),

        );
      }
    );

  }

  Widget _buildMyUserFoto(BuildContext context, String profilePic) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !kIsWeb ?
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(60)),
              child:
              Center(
                child:
                profilePic == "" ?
                Container(
                  color:  Colors.transparent,
                  height: 40,
                  width: 40,
                  child: Image.asset(ImagePath.USER_DEFAULT),
                ):
                CachedNetworkImage(
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    imageUrl: profilePic),
              ),
            ):
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(60)),
              child:
              profilePic == "" ?
              Container(
                color:  Colors.transparent,
                height: 40,
                width: 40,
                child: Image.asset(ImagePath.USER_DEFAULT),
              ):
              PrecacheAvatarCard(
                imageUrl: profilePic,
                width: 35,
                height: 35,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildMyCompanyName(BuildContext context, Organization organization) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(' &  ${organization.name}',
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.penBlue,
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


class SideBarWidget extends StatelessWidget {
  const SideBarWidget({Key? key, required SidebarXController controller}) : _controller = controller, super(key: key);
  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: AppColors.lightLilac,
        hoverTextStyle: const TextStyle(color: AppColors.greyDark, fontWeight: FontWeight.w600),
        textStyle: const TextStyle(color: AppColors.penBlue, fontWeight: FontWeight.w800),
        selectedTextStyle: const TextStyle(color: AppColors.penBlue, fontWeight: FontWeight.w800),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.violet,
          ),
          color: AppColors.violet,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.penBlue,
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: AppColors.penBlue,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: AppColors.white,
        ),
      ),
      footerDivider: Divider(color: Colors.grey.withOpacity(0.5), height: 1),
      headerBuilder: (context, extended) {
        return isSmallScreen ? SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Image.asset(
                  ImagePath.LOGO,
                  height: 20,
                ),
              ],
            ),
          ),
        ) : const SizedBox(height: 10,);
      },
      items: const [
        SidebarXItem(icon: Icons.view_quilt, label: 'Panel de control'),
        SidebarXItem(icon: Icons.supervisor_account, label: 'Participantes'),
        SidebarXItem(icon: Icons.card_travel, label: 'Mis recursos'),
        SidebarXItem(icon: Icons.account_circle_sharp, label: 'Mi perfil'),
      ],
    );
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
                  Text(StringConst.ARENT_YOU_ORGANIZATION,
                      style: textTheme.bodyText1?.copyWith(
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