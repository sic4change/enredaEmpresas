import 'package:enreda_empresas/app/home/web_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';


class HomePage extends StatelessWidget {

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: Provider.of<AuthBase>(context).authStateChanges(),
        builder: (context, snapshot) {
          return LayoutBuilder(builder: (context, constraints) {
            final isBigScreen = constraints.maxWidth >= 900;
            return const WebHome();
            // return Stack(
            //   children: [snapshot.hasData && kIsWeb && isBigScreen ? const WebHome() : Container()],
            // );
          });
        });
  }
}
