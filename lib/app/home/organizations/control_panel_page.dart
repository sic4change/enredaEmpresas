import 'package:enreda_empresas/app/models/organization.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ControlPanelPage extends StatelessWidget {
  const ControlPanelPage({super.key, required this.organization, required this.user});

  final Organization? organization;
  final UserEnreda? user;

  @override
  Widget build(BuildContext context) {

    return _myWelcomePage(context);
  }

  Widget _myWelcomePage(BuildContext context){
    final textTheme = Theme.of(context).textTheme;
    String locale = Localizations.localeOf(context).languageCode;
    DateTime now = new DateTime.now();
    String dayOfNow = DateFormat.d(locale).format(now);
    String dayOfWeek = DateFormat.EEEE(locale).format(now);
    String dayMonth = DateFormat.MMMM(locale).format(now);

    return Column(
      children: [
        Flex(
          direction: Responsive.isMobile(context) ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: Responsive.isMobile(context) ? 0 : 6,
              child: Container(
                height: 260,
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
                          child: Text('${user?.firstName}',
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
              flex: Responsive.isMobile(context) ? 0 : 2,
                child: Container(
                  height: 260,
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: AppColors.white,
                    border: Border.all(color: AppColors.greyLight2.withOpacity(0.3), width: 1),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                    child: Center(
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
                              top: 165,
                              child: Text(dayOfWeek.toUpperCase(), style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15.0,
                                  color: AppColors.penBlue)),)
                        ],
                      ),
                    ),
                  ),
                ))

          ],
        ),
      ],
    );
  }
}
