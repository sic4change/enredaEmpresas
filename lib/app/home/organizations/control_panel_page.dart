import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ControlPanelPage extends StatefulWidget {
  const ControlPanelPage({super.key});

  @override
  State<ControlPanelPage> createState() => _ControlPanelPageState();
}

class _ControlPanelPageState extends State<ControlPanelPage> {
  UserEnreda? user;
  String? myLocation;
  String? city;
  String? province;
  String? country;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    return Stack(
      children: [
        StreamBuilder<List<UserEnreda>>(
            stream: database.userStream(auth.currentUser?.email ?? ''),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.active) {
                user = snapshot.data!.isNotEmpty ? snapshot.data!.first : null;
                var profilePic = user?.profilePic?.src ?? "";
                return _myWelcomePage(context, user, profilePic);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ],
    );
  }

  Widget _myWelcomePage(BuildContext context, UserEnreda? user, String profilePic){
    final textTheme = Theme.of(context).textTheme;
    String locale = Localizations.localeOf(context).languageCode;
    DateTime now = new DateTime.now();
    String dayOfNow = DateFormat.d(locale).format(now);
    String dayOfWeek = DateFormat.EEEE(locale).format(now);
    String dayMonth = DateFormat.MMMM(locale).format(now);

    return Column(
      children: [
        Flex(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Container(
                height: 230,
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppColors.greyLight2.withOpacity(0.3), width: 1),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(StringConst.WELCOME_COMPANY,
                            style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 35.0,
                            color: AppColors.greyDark2),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('${user?.firstName} ${user?.lastName}',
                            style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 35.0,
                            color: AppColors.penBlue),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(StringConst.WELCOME_TEXT,
                            style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                            color: AppColors.greyDark2),),
                        )
                      ],
                    ),
                  )),
            ),
            Expanded(
              flex: 2,
                child: Container(
                  height: 230,
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: AppColors.white,
                    border: Border.all(color: AppColors.greyLight2.withOpacity(0.3), width: 1),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                    child: Stack(
                      children: [
                        Text('Hoy', style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            color: AppColors.penBlue),),
                        Text(dayOfNow, style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 150.0,
                            color: AppColors.violet),),
                        Positioned(
                          top: 120,
                          child: Text(dayMonth, style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 40.0,
                              color: AppColors.penBlue),),
                        ),
                        Positioned(
                            top: 170,
                            child: Text(dayOfWeek.toUpperCase(), style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.normal,
                                fontSize: 15.0,
                                color: AppColors.penBlue)),)
                      ],
                    ),
                  ),
                ))

          ],
        ),
      ],
    );
  }
}
