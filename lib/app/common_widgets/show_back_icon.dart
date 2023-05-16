import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';

import '../values/strings.dart';

Widget showBackIconButton(BuildContext context, Color color) {
  try {
    if (kIsWeb) {
      return IconButton(
          icon: Icon(Icons.arrow_back, color: color,),
          onPressed: () {
            GoRouter.of(context).go(StringConst.PATH_HOME);
          });
    }
    if (Platform.isIOS) {
      return IconButton(
          icon: Icon(CupertinoIcons.back, color: color,),
          onPressed: () {
            GoRouter.of(context).go(StringConst.PATH_HOME);
          });
    }
    if (Platform.isAndroid) {
      return IconButton(
          icon: Icon(Icons.arrow_back, color: color,),
          onPressed: () {
            GoRouter.of(context).go(StringConst.PATH_HOME);
          });
    }
  } catch (e) {
    return IconButton(
        icon: Icon(Icons.arrow_back, color: color,),
        onPressed: () {
          GoRouter.of(context).go(StringConst.PATH_HOME);
        });
  }
  return const CircularProgressIndicator();
}