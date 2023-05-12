import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

Future<void> showExceptionAlertDialog(
  BuildContext context, {
    required String title,
    required Exception exception,
}) =>
    showAlertDialog(
        context,
        title: title,
        content: _message(exception),
        defaultActionText: 'OK'
    );

String _message(Exception exception) {
  if (exception is FirebaseException) {
    print('Code: ${exception.code} , Message: ${exception.message}');
    if (exception.code == 'wrong-password') {
      return 'Correo y/o contraseña incorrecta';
    } else if(exception.code == 'invalid-email') {
      return 'El correo electrónico no tiene un formato válido';
    } else if(exception.code == 'user-not-found') {
      return 'Correo y/o contraseña incorrecta';
    } else if (exception.code == 'permission-denied') {
      return 'Permiso denegado';
    }
    return 'Error de conexión';
  }
  return exception.toString();
}