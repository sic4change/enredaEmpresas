import 'package:enreda_empresas/app/sign_in/access/access_page_mobile.dart';
import 'package:enreda_empresas/app/sign_in/access/access_page_web.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:flutter/material.dart';

class AccessPage extends StatelessWidget {
  const AccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context) || Responsive.isTablet(context)
        ? const AccessPageMobile()
        : const AccessPageWeb();
  }
}
