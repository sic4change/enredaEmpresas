import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../common_widgets/alert_dialog.dart';
import '../../models/resource.dart';
import '../../values/strings.dart';


Future<void> shareResource(Resource resource) async {
  await Share.share(
    StringConst.SHARE_TEXT(resource.title, resource.resourceId!),
    subject: StringConst.APP_NAME,
  );
}

void showAlertNullUser(BuildContext context) async {
  final signIn = await showAlertDialog(context,
      title: '¿Te interesa el recurso?',
      content:
          'Solo los usuarios registrados pueden acceder a los recursos internos. ¿Deseas entrar como usuario registrado?',
      cancelActionText: 'Cancelar',
      defaultActionText: 'Entrar');
  if (signIn == true) {
    GoRouter.of(context).go(StringConst.PATH_LOGIN);
  }
}

