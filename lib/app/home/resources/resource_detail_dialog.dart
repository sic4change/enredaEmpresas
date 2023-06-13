import 'package:enreda_empresas/app/common_widgets/custom_text_title.dart';
import 'package:enreda_empresas/app/common_widgets/enreda_button.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/functions.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ShowResourceDetailDialog extends StatelessWidget {
  final Resource resource;

  const ShowResourceDetailDialog({
    super.key,
    required this.resource,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      content: dialogContent(context, resource),
      contentPadding: const EdgeInsets.all(0.0),
    );
  }
}

dialogContent(BuildContext context, Resource resource) {
  final isSmallScreen = widthOfScreen(context) < 1200;
  final dialogWidth = Responsive.isMobile(context) || isSmallScreen
      ? widthOfScreen(context)
      : widthOfScreen(context) * 0.55;
  final dialogHeight = Responsive.isMobile(context)
      ? heightOfScreen(context)
      : heightOfScreen(context) * 0.80;
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSizeTitle = responsiveSize(context, 14, 22, md: 18);
  double fontSizePromotor = responsiveSize(context, 12, 16, md: 14);
  return Stack(
    children: <Widget>[
      Container(
        width: dialogWidth,
        height: dialogHeight,
        padding: const EdgeInsets.only(
          top: Consts.avatarRadius / 2,
          bottom: Consts.padding,
          left: Consts.padding,
          right: Consts.padding,
        ),
        margin: EdgeInsets.only(
            top: Responsive.isMobile(context)
                ? Consts.avatarRadius / 2
                : Consts.avatarRadius),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(Consts.padding),
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
            Stack(
              children: [
                Container(
                  height: 90,
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Responsive.isMobile(context)
                          ? const SpaceH20()
                          : const SpaceH30(),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0, left: 30.0),
                        child: Text(
                          resource.title,
                          textAlign: TextAlign.center,
                          maxLines: Responsive.isMobile(context) ? 2 : 1,
                          style: textTheme.bodyText1?.copyWith(
                            letterSpacing: 1.2,
                            color: AppColors.greyTxtAlt,
                            height: 1.5,
                            fontWeight: FontWeight.w300,
                            fontSize: fontSizeTitle,
                          ),
                        ),
                      ),
                      const SpaceH4(),
                      Expanded(
                        flex: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              resource.promotor != null
                                  ? resource.promotor!
                                  : resource.organizerName ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                letterSpacing: 1.2,
                                fontSize: fontSizePromotor,
                                fontWeight: FontWeight.bold,
                                color: AppColors.penBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop((false)),
                      child: Icon(
                        Icons.close,
                        color: AppColors.greyTxtAlt,
                        size: widthOfScreen(context) >= 1024 ? 25 : 20,
                      ),
                    ),
                  ],
                ),
                Responsive.isMobile(context) ? Container() : const SpaceH12(),
              ],
            ),
            const Divider(
              color: AppColors.grey150,
              thickness: 1,
            ),
            Expanded(
                child:
                    Responsive.isMobile(context) || Responsive.isTablet(context)
                        ? _buildDetailsListViewMobile(context, resource)
                        : _buildDetailsListViewWeb(context, resource)),
          ],
        ),
      ),
      Positioned(
        left: Responsive.isMobile(context)
            ? (dialogWidth / 2) - 60
            : isSmallScreen
                ? (dialogWidth / 2) - 80
                : (dialogWidth / 2) - 80 * 0.55,
        width: Responsive.isMobile(context) ? 50 : 80,
        child: Container(
          color: Colors.transparent,
          width: Responsive.isMobile(context) ? 50 : 80,
          height: Responsive.isMobile(context) ? 50 : 80,
          child: resource.organizerImage == null ||
                  resource.organizerImage!.isEmpty
              ? Container()
              : CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  radius: Consts.avatarRadius,
                  backgroundImage: NetworkImage(resource.organizerImage!),
                ),
        ),
      ),
      Responsive.isTablet(context) || Responsive.isMobile(context)
          ? Container()
          : Positioned(
              bottom: 1,
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(20.0, 0.0, 20.0, Sizes.mainPadding),
                child: SizedBox(
                  height: 60,
                  width: dialogWidth,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: Responsive.isMobile(context)
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            resource.resourceLink != null
                                ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey, width: 1)
                                  ),
                                  child: InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                          child: Text(resource.resourceLink!,
                                            style: textTheme.bodySmall?.copyWith(
                                            color: AppColors.greyDark,
                                          ),),
                                        ),
                                      ),
                                      onTap: () => launchURL(resource.resourceLink!)),
                                )
                                : Container(),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
    ],
  );
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 40.0;
}

Widget _buildDetailsListViewWeb(BuildContext context, Resource resource) {
  double fontSize = responsiveSize(context, 12, 15, md: 14);
  TextTheme textTheme = Theme.of(context).textTheme;
  return Padding(
    padding: const EdgeInsets.only(bottom: 80.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: Responsive.isMobile(context) ? 2 : 4,
          child: Padding(
            padding: const EdgeInsets.only(top: 30, right: 30.0),
            child: SingleChildScrollView(
              child: Text(
                resource.description,
                textAlign: TextAlign.left,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.greyTxtAlt,
                  height: 1.5,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: Responsive.isMobile(context) ? 2 : 2,
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyDark, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextTitle(
                      title: StringConst.RESOURCE_TYPE.toUpperCase()),
                  CustomTextBody(text: '${resource.resourceTypeName}'),
                  const SpaceH16(),
                  CustomTextTitle(title: StringConst.LOCATION.toUpperCase()),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextBody(text: resource.modality!),
                      resource.modality == StringConst.ONLINE
                          ? Container()
                          : Row(
                              children: [
                                CustomTextBody(text: '${resource.countryName}'),
                                const CustomTextBody(text: ', '),
                                CustomTextBody(
                                    text: '${resource.provinceName}'),
                              ],
                            ),
                    ],
                  ),
                  const SpaceH16(),
                  CustomTextTitle(title: StringConst.CAPACITY.toUpperCase()),
                  CustomTextBody(text: '${resource.capacity}'),
                  const SpaceH16(),
                  CustomTextTitle(title: StringConst.DURATION.toUpperCase()),
                  CustomTextBody(text: resource.duration!),
                  const SpaceH16(),
                  (resource.contractType != null && resource.contractType != '')
                      ? CustomTextTitle(
                          title: StringConst.CONTRACT_TYPE.toUpperCase())
                      : Container(),
                  (resource.contractType != null && resource.contractType != '')
                      ? CustomTextBody(text: '${resource.contractType}')
                      : Container(),
                  const SpaceH4(),
                  (resource.contractType != null && resource.contractType != '')
                      ? const SpaceH16()
                      : Container(),
                  (resource.salary != null && resource.salary != '')
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextTitle(
                                title: StringConst.SALARY.toUpperCase()),
                            CustomTextBody(text: '${resource.salary}')
                          ],
                        )
                      : Container(),
                  const SpaceH4(),
                  (resource.salary != null && resource.salary != '')
                      ? const SpaceH16()
                      : Container(),
                  CustomTextTitle(title: StringConst.DATE.toUpperCase()),
                  DateFormat('dd/MM/yyyy').format(resource.start!) ==
                          '31/12/2050'
                      ? const CustomTextBody(
                          text: StringConst.ALWAYS_AVAILABLE,
                        )
                      : Row(
                          children: [
                            CustomTextBody(
                                text: DateFormat('dd/MM/yyyy')
                                    .format(resource.start!)),
                            const SpaceW4(),
                            const CustomTextBody(text: '-'),
                            const SpaceW4(),
                            CustomTextBody(
                                text: DateFormat('dd/MM/yyyy')
                                    .format(resource.end!))
                          ],
                        ),
                  resource.temporality == null
                      ? const SizedBox(
                          height: 0,
                        )
                      : CustomTextBody(text: '${resource.temporality}')
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildDetailsListViewMobile(BuildContext context, Resource resource) {
  double fontSize = responsiveSize(context, 12, 15, md: 14);
  TextTheme textTheme = Theme.of(context).textTheme;
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, right: 30.0),
          child: Text(
            resource.description,
            textAlign: TextAlign.left,
            style: textTheme.bodyText1?.copyWith(
              color: AppColors.greyTxtAlt,
              height: 1.5,
              fontWeight: FontWeight.w400,
              fontSize: fontSize,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyDark, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextTitle(title: StringConst.RESOURCE_TYPE.toUpperCase()),
              CustomTextBody(text: '${resource.resourceTypeName}'),
              const SpaceH16(),
              CustomTextTitle(title: StringConst.LOCATION.toUpperCase()),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextBody(text: resource.modality!),
                  resource.modality == StringConst.ONLINE
                      ? Container()
                      : Row(
                          children: [
                            CustomTextBody(text: '${resource.countryName}'),
                            const CustomTextBody(text: ', '),
                            CustomTextBody(text: '${resource.provinceName}'),
                          ],
                        ),
                ],
              ),
              const SpaceH16(),
              CustomTextTitle(title: StringConst.CAPACITY.toUpperCase()),
              CustomTextBody(text: '${resource.capacity}'),
              const SpaceH16(),
              CustomTextTitle(title: StringConst.DURATION.toUpperCase()),
              CustomTextBody(text: resource.duration!),
              const SpaceH16(),
              (resource.contractType != null && resource.contractType != '')
                  ? CustomTextTitle(
                      title: StringConst.CONTRACT_TYPE.toUpperCase())
                  : Container(),
              (resource.contractType != null && resource.contractType != '')
                  ? CustomTextBody(text: '${resource.contractType}')
                  : Container(),
              const SpaceH4(),
              (resource.contractType != null && resource.contractType != '')
                  ? const SpaceH16()
                  : Container(),
              (resource.salary != null && resource.salary != '')
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextTitle(
                            title: StringConst.SALARY.toUpperCase()),
                        CustomTextBody(text: '${resource.salary}')
                      ],
                    )
                  : Container(),
              const SpaceH4(),
              (resource.salary != null && resource.salary != '')
                  ? const SpaceH16()
                  : Container(),
              CustomTextTitle(title: StringConst.DATE.toUpperCase()),
              DateFormat('dd/MM/yyyy').format(resource.start!) == '31/12/2050'
                  ? const CustomTextBody(
                      text: StringConst.ALWAYS_AVAILABLE,
                    )
                  : Row(
                      children: [
                        CustomTextBody(
                            text: DateFormat('dd/MM/yyyy')
                                .format(resource.start!)),
                        const SpaceW4(),
                        const CustomTextBody(text: '-'),
                        const SpaceW4(),
                        CustomTextBody(
                            text: DateFormat('dd/MM/yyyy').format(resource.end!))
                      ],
                    ),
              resource.temporality == null
                  ? const SizedBox(
                      height: 0,
                    )
                  : CustomTextBody(text: '${resource.temporality}')
            ],
          ),
        ),
        const SpaceH20(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EnredaButton(
              buttonTitle: StringConst.JOIN_RESOURCE,
              onPressed: () => {},
            ),
          ],
        ),
        const SpaceH20(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //buildShareButton(context, resource, AppColors.darkBlue),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.heart),
              tooltip: 'Me gusta',
              color: AppColors.penBlue,
              iconSize: 24,
              onPressed: () => {},
            ),
          ],
        ),
      ],
    ),
  );
}
