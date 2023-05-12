import 'package:enreda_empresas/app/account/account_page.dart';
import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:enreda_empresas/app/home/organizations/company_page.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../common_widgets/custom_icons.dart';

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
  final Color _underlineColor = AppColors.lilac;
  var bodyWidget = [];
  late UserEnreda _userEnreda;
  String _userName = "";
  late TextTheme textTheme;

  @override
  void initState() {
    bodyWidget = [
      const CompanyPage(),
      const AccountPage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return ValueListenableBuilder<int>(
        valueListenable: WebHome.selectedIndex,
        builder: (context, selectedIndex, child) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: AppColors.white,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  ImagePath.LOGO,
                  height: 20,
                ),
              ),
              actions: <Widget>[
                if (!auth.isNullUser)
                  const VerticalDivider(
                    color: AppColors.grey100,
                    thickness: 1,
                  ),
                IconButton(
                  icon: const Icon(
                    CustomIcons.cuenta,
                    color: AppColors.blueDark,
                    size: 30,
                  ),
                  tooltip: 'Cuenta',
                  onPressed: () {
                    setState(() {
                      WebHome.selectedIndex.value = 0;
                    });
                  },
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        WebHome.selectedIndex.value = 0;
                      });
                    },
                    child: _buildMyUserName(context)
                ),
                if (!auth.isNullUser)
                  const VerticalDivider(
                    color: AppColors.grey100,
                    thickness: 1,
                  ),
                const SizedBox(width: 10),
                if (!auth.isNullUser)
                  SizedBox(
                    width: 30,
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
            body: const CompanyPage(),
          );
        });
  }

  Widget _buildMyUserName(BuildContext context) {
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
                  _userName = '${_userEnreda.firstName} ${_userEnreda.lastName}';
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(_userName,
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.penBlue,
                              fontSize: 16.0,)
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      height: 20.0,
                      width: 20.0,
                      child: CircularProgressIndicator(),
                    ),
                  ),);
                }
              },
            );
          } else if (!snapshot.hasData) {
            return Container();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
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
