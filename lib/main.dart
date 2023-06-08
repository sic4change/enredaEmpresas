import 'package:enreda_empresas/app/app_theme.dart';
import 'package:enreda_empresas/app/common_widgets/error_page.dart';
import 'package:enreda_empresas/app/home/home_page.dart';
import 'package:enreda_empresas/app/home/resources/resource_detail_web.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/services/firebase_options.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _router = GoRouter(
    initialLocation: StringConst.PATH_HOME,
    urlPathStrategy: UrlPathStrategy.path,
    routes: [
      GoRoute(
        path: StringConst.PATH_HOME,
        builder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const HomePage(),
        ),
      ),
      // GoRoute(
      //   path: '${StringConst.PATH_RESOURCES}/:rid',
      //   builder: (context, state) => MaterialPage<void>(
      //     fullscreenDialog: false,
      //     child: Responsive.isMobile(context) || Responsive.isTablet(context)
      //         ? ResourceDetailPageWeb(resourceId: state.params['rid']!)
      //         : ResourceDetailPageWeb(resourceId: state.params['rid']!),
      //   ),
      // ),
    ],
    error: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: ErrorPage(state.error),
    ),
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBase>(create: (context) => Auth()),
        Provider<Database>(create: (_) => FirestoreDatabase()),
      ],
      child: Layout(
        child: MaterialApp.router(
          //routeInformationProvider: _router.routeInformationProvider,
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
          debugShowCheckedModeBanner: false,
          title: 'enREDa-empresas',
          theme: AppTheme.lightThemeData,
          localizationsDelegates: const [
            //CountryLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es'),
          ],
          //scrollBehavior: MyCustomScrollBehavior(),
        ),
      ),
    );
  }
}


