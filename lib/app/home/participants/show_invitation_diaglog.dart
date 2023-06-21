import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/participants/resource_participants_list.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';


class ShowInvitationDialog extends StatefulWidget {
  final UserEnreda user;
  final String organizerId;

  const ShowInvitationDialog({super.key,
    required this.user,
    required this.organizerId
  });

  @override
  State<ShowInvitationDialog> createState() => _ShowInvitationDialogState();
}

class _ShowInvitationDialogState extends State<ShowInvitationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      content: dialogContent(context, widget.user, widget.organizerId),
      contentPadding: const EdgeInsets.all(0.0),
    );
  }
}

dialogContent(BuildContext context, UserEnreda user, String organizerId) {
  final isSmallScreen = widthOfScreen(context) < 1200;
  final dialogWidth = Responsive.isMobile(context) || isSmallScreen
      ? widthOfScreen(context)
      : widthOfScreen(context) * 0.55;
  final dialogHeight = Responsive.isMobile(context)
      ? heightOfScreen(context)
      : heightOfScreen(context) * 0.80;
  TextTheme textTheme = Theme.of(context).textTheme;
  return Stack(
    children: <Widget>[
      Container(
        width: dialogWidth,
        height: dialogHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(Sizes.mainPadding),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop((false)),
                        child: Icon(
                          Icons.close,
                          color: AppColors.greyTxtAlt,
                          size: widthOfScreen(context) >= 1024 ? 25 : 20,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Responsive.isMobile(context) ? SpaceH20() : SpaceH60(),
                    const Text('Invitar a:'),
                    const SizedBox(width: 10.0,),
                    Text(
                      '${user.firstName!} ${user.lastName!}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.penBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
              color: AppColors.grey150,
              thickness: 1,
            ),
            ParticipantResourcesList(participant: user, organizerId: organizerId,),
          ],
        ),
      ),

    ],
  );
}
