
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enreda_empresas/app/common_widgets/custom_sidebar_button.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/home/resources/my_resources_list_page.dart';
import 'package:enreda_empresas/app/home/web_home.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

import '../common_widgets/precached_avatar.dart';
import '../common_widgets/spaces.dart';
import '../utils/responsive.dart';
import '../values/strings.dart';

class SideBarWidget extends StatefulWidget {
  const SideBarWidget({
    Key? key,
    required SidebarXController controller,
    required this.profilePic,
    required this.userName,
    required this.keyWebHome}) : _controller = controller, super(key: key);
  final SidebarXController _controller;
  final String profilePic;
  final String userName;
  final GlobalKey<ScaffoldState> keyWebHome;

  @override
  State<SideBarWidget> createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {
  void _setSelectedIndexToOne() {
    setState(() {
      WebHome.selectedIndex.value = 2; // Select empty Container
      MyResourcesListPage.selectedIndex.value = 0;
    });
  }

  void _setSelectedIndexParticipants() {
    setState(() {
      WebHome.goToParticipants();
      MyResourcesListPage.selectedIndex.value = 0;
    });
  }

  void _setSelectedIndexEntities() {
    setState(() {
      WebHome.goToEntities();
      MyResourcesListPage.selectedIndex.value = 0;
    });
  }

  void _setSelectedIndexResources() {
    setState(() {
      WebHome.goResources();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    TextTheme textTheme = Theme.of(context).textTheme;
    return SidebarX(
      controller: widget._controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: AppColors.primary050,
        hoverTextStyle: const TextStyle(color: AppColors.turquoiseBlue, fontWeight: FontWeight.w600),
        textStyle: textTheme.bodySmall?.copyWith(
              color: AppColors.turquoiseBlue,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
        selectedTextStyle: textTheme.bodySmall?.copyWith(
          color: AppColors.turquoiseBlue,
          fontSize: 15,
          fontWeight: WebHome.selectedIndex.value == 1 ? FontWeight.w500 : FontWeight.w900,
        ),
        itemTextPadding: const EdgeInsets.only(left: 10),
        selectedItemTextPadding: const EdgeInsets.only(left: 10),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: MyResourcesListPage.selectedIndex.value == 1 ?
            Colors.transparent : AppColors.primary100,
          ),
          color: MyResourcesListPage.selectedIndex.value == 1 ?
          Colors.transparent : AppColors.primary100,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.turquoiseBlue,
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: AppColors.turquoiseBlue,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 210,
        decoration: BoxDecoration(
          color: AppColors.white,
        ),
      ),
      footerDivider: Divider(color: Colors.grey.withOpacity(0.5), height: 1),
      showToggleButton: false,
      headerBuilder: (context, extended) {
        return Container(
          height: isSmallScreen ? 342 : 342,
          child: Padding(
            padding: isSmallScreen ? EdgeInsets.only(top: 10.0, left: 0, right: 0) : EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isSmallScreen ? SpaceH20() : Container(),
                isSmallScreen ? Image.asset(
                  ImagePath.LOGO,
                  height: Responsive.isMobile(context) ? 35 : 20,
                ) : Container(),
                SpaceH30(),
                Column(
                  children: [
                    _buildMyUserPhoto(context, widget.profilePic),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CustomTextBoldCenter(title: widget.userName),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 0.0, bottom: 20),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8), // optional for spacing
                        height: 6, // Thickness of the 'divider'
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primary100, // Color for the 'divider'
                          borderRadius: BorderRadius.all(Radius.circular(10)), // The border radius
                        ),
                      ),
                    ),
                    CustomSideBarButton(
                      buttonTitle: StringConst.CREATE_JOB_OFFER,
                      onPressed: () {
                        widget.keyWebHome.currentState?.closeDrawer();
                        WebHome.goCreateResource();
                      },
                      widget: Icon(Icons.add_circle_outlined, size: 20, color: AppColors.turquoiseBlue,),),
                    SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      items: [
        SidebarXItem(iconWidget: Container(child: Image.asset(ImagePath.ICON_PANEL), width: 20,), label: StringConst.DRAWER_CONTROL_PANEL, onTap: _setSelectedIndexToOne),
        //SidebarXItem(iconWidget: Container(child: Image.asset(ImagePath.ICON_PARTICIPANTS), width: 20,), label: StringConst.DRAWER_PARTICIPANTS, onTap: _setSelectedIndexParticipants),
        SidebarXItem(iconWidget: Container(child: Image.asset(ImagePath.ICON_RESOURCES), width: 20,), label: StringConst.DRAWER_MY_RESOURCES , onTap: _setSelectedIndexResources),
        SidebarXItem(iconWidget: Container(child: Image.asset(ImagePath.ICON_TOOLS), width: 20,), label: StringConst.DRAWER_TOOLS , onTap: _setSelectedIndexToOne),
        SidebarXItem(iconWidget: Container(child: Image.asset(ImagePath.ICON_ENTITY), width: 20,), label: StringConst.DRAWER_ENTITIES, onTap: _setSelectedIndexEntities)
      ],
    );
  }

  Widget _buildMyUserPhoto(BuildContext context, String profilePic) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return InkWell(
      onTap: () {
        setState(() {
          widget.keyWebHome.currentState?.closeDrawer();
          WebHome.selectedIndex.value = 0;
        });
      },
      child: Column(
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
                    height: isSmallScreen ? 80 : 100,
                    width: isSmallScreen ? 80 : 100,
                    child: Image.asset(ImagePath.USER_DEFAULT),
                  ):
                  CachedNetworkImage(
                      width: isSmallScreen ? 80 : 100,
                      height: isSmallScreen ? 80 : 100,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      imageUrl: profilePic),
                ),
              ) :
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(60)),
                child:
                profilePic == "" ?
                Container(
                  color:  Colors.transparent,
                  height: isSmallScreen ? 80 : 100,
                  width: isSmallScreen ? 80 : 100,
                  child: Image.asset(ImagePath.USER_DEFAULT),
                ):
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.turquoiseUltraLight,
                    )
                  ),
                  child: PrecacheAvatarCard(
                    imageUrl: profilePic,
                    width: isSmallScreen ? 80 : 100,
                    height: isSmallScreen ? 80 : 100,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}