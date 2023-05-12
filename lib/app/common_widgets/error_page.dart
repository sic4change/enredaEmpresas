import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage(Exception? error, {super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context) || Responsive.isTablet(context)
        ? const Text('Error de navegación')
        : Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.lilac,
              elevation: 0.0,
              //leading: showBackIconButton(context, Colors.white),
            ),
            body: const Text('Error de navegación'),
          );
  }
}
