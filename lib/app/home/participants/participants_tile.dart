import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/precached_avatar.dart';
import 'package:enreda_empresas/app/common_widgets/show_exception_alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/resources/build_share_button.dart';
import 'package:enreda_empresas/app/home/resources/resource_actions.dart';
import 'package:enreda_empresas/app/models/contact.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ParticipantsListTile extends StatefulWidget {
  const ParticipantsListTile({Key? key, required this.user, this.onTap})
      : super(key: key);
  final UserEnreda user;
  final VoidCallback? onTap;

  @override
  State<ParticipantsListTile> createState() => _ParticipantsListTileState();
}

class _ParticipantsListTileState extends State<ParticipantsListTile> {
  String? codeDialog;
  String? valueText;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 15, 15, md: 13);
    double sidePadding = responsiveSize(context, 15, 20, md: 17);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.greyLight2.withOpacity(0.3), width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        margin: const EdgeInsets.all(5.0),
        child: InkWell(
          mouseCursor: MaterialStateMouseCursor.clickable,
          onTap: widget.onTap,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 150,
                  child: !kIsWeb
                      ? Expanded(
                    child: widget.user.photo == null ||
                        widget.user.photo == ""
                        ? Container()
                        : CachedNetworkImage(
                        width: double.infinity,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url,
                            downloadProgress) =>
                            Container(
                              child:
                              Image.asset(ImagePath.IMAGE_DEFAULT),
                            ),
                        alignment: Alignment.center,
                        imageUrl: widget.user.photo!),
                  )
                      : Expanded(
                      child:
                      widget.user.photo == null || widget.user.photo == ""
                          ? Container()
                          : PrecacheResourceCard(
                        imageUrl: widget.user.photo!,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: sidePadding, right: sidePadding),
                          child: Text(
                            '${widget.user.firstName!} ${widget.user.lastName!}'
                                .toUpperCase(),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.greyTxtAlt,
                                fontSize: 16.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: sidePadding, right: sidePadding),
                          child: Text(
                            widget.user.educationName?.toUpperCase() ?? '',
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.greyTxtAlt,
                                fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getLocationText(Resource resource) {
    switch (resource.modality) {
      case StringConst.FACE_TO_FACE:
      case StringConst.BLENDED:
        {
          if (resource.cityName != null) {
            return '${resource.cityName}, ${resource.provinceName}, ${resource.countryName}';
          }

          if (resource.cityName == null && resource.provinceName != null) {
            return '${resource.provinceName}, ${resource.countryName}';
          }

          if (resource.provinceName == null && resource.countryName != null) {
            return resource.countryName!;
          }

          if (resource.provinceName != null) {
            return resource.provinceName!;
          } else if (resource.countryName != null) {
            return resource.countryName!;
          }
          return resource.modality;
        }

      case StringConst.ONLINE_FOR_COUNTRY:
      /*return StringConst.ONLINE_FOR_COUNTRY
            .replaceAll('país', resource.countryName!);*/

      case StringConst.ONLINE_FOR_PROVINCE:
      /*return StringConst.ONLINE_FOR_PROVINCE.replaceAll(
            'provincia', '${resource.provinceName!}, ${resource.countryName!}');*/

      case StringConst.ONLINE_FOR_CITY:
      /*return StringConst.ONLINE_FOR_CITY.replaceAll('ciudad',
            '${resource.cityName!}, ${resource.provinceName!}, ${resource.countryName!}');*/

      case StringConst.ONLINE:
        return StringConst.ONLINE;

      default:
        return resource.modality;
    }
  }
}
