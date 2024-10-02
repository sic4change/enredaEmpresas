import 'package:enreda_empresas/app/common_widgets/build_share_button.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class ResourceListTile extends StatefulWidget {
  const ResourceListTile({Key? key, required this.resource, this.onTap})
      : super(key: key);
  final Resource resource;
  final VoidCallback? onTap;

  @override
  State<ResourceListTile> createState() => _ResourceListTileState();
}

class _ResourceListTileState extends State<ResourceListTile> {
  String? codeDialog;
  String? valueText;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 12, 17, md: 15);
    double fontSizeS = responsiveSize(context, 12, 14, md: 13);
    double sidePadding = responsiveSize(context, 15, 20, md: 17);
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: Responsive.isMobile(context) ? const EdgeInsets.all(0) : const EdgeInsets.all(5.0),
          child: InkWell(
            mouseCursor: MaterialStateMouseCursor.clickable,
            onTap: widget.onTap,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.blue050, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.greyBorder,
                      spreadRadius: 0.2,
                      blurRadius: 1,
                      offset: Offset(0, 0),
                    )
                  ]
              ),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: sidePadding, right: 0, top: 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                widget.resource.organizerImage == null ||
                                        widget.resource.organizerImage!.isEmpty
                                    ? Container()
                                    : LayoutBuilder(
                                        builder: (context, constraints) {
                                        return CircleAvatar(
                                          radius: 15,
                                          backgroundColor: AppColors.white,
                                          backgroundImage: NetworkImage(
                                              widget.resource.organizerImage!),
                                        );
                                      }),
                                widget.resource.organizerImage == null ||
                                        widget.resource.organizerImage!.isEmpty
                                    ? Container()
                                    : const SizedBox(
                                        width: 5,
                                      ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.resource.promotor != null
                                        ? widget.resource.promotor != ""
                                            ? widget.resource.promotor!
                                            : widget.resource.organizerName!
                                        : widget.resource.organizerName!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: AppColors.greyDark,
                                        height: 1.5,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.place,
                                          color: AppColors.greyDark,
                                          size: 12,
                                        ),
                                        Container(
                                          width: Responsive.isDesktop(context) ? 300 : 250,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              getLocationText(widget.resource),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  textTheme.bodySmall?.copyWith(
                                                color: AppColors.greyDark,
                                                height: 1.5,
                                              ),
                                            ),
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
                        const SpaceH4(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SpaceH4(),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: sidePadding, right: sidePadding, top: sidePadding / 1.5),
                                  child: Text(
                                    widget.resource.resourceCategoryName!.toUpperCase(),
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    style: TextStyle(
                                        letterSpacing: 1,
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: sidePadding, left: sidePadding),
                              child: Text(
                                widget.resource.title,
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                style: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary900,
                                ),
                              ),
                            ),
                            const SpaceH8(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.greyLight2.withOpacity(0.2),
                                  width: 1),
                              borderRadius: BorderRadius.circular(Sizes.mainPadding),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                            margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 8,
                                  width: 8,
                                  decoration: BoxDecoration(
                                    color: widget.resource.status == "No disponible" ? Colors.green :
                                    widget.resource.status == 'edition'? Colors.orange : Colors.lightGreenAccent,
                                    borderRadius: BorderRadius.circular(Sizes.mainPadding),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                    widget.resource.status == 'edition' ? 'Borrador' : '${widget.resource.status}',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: AppColors.greyAlt,
                                      fontSize: fontSizeS,
                                    ),),
                              ],
                            )),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.greyLight2.withOpacity(0.2),
                                  width: 1),
                              borderRadius: BorderRadius.circular(Sizes.mainPadding),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15.0),
                            margin: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(ImagePath.ICON_PARTICIPANT, width: 20, height: 18),
                                SizedBox(width: 8),
                                Text(widget.resource.participants?.length.toString() ?? '0'),
                              ],
                            )),
                        Spacer(),
                        Container(
                            margin: const EdgeInsets.only(left: 15.0),
                            child: buildShare(
                                context, widget.resource, AppColors.darkGray, AppColors.greyTxtAlt, Colors.transparent),
                        ),
                        SizedBox(width: 15,)
                      ],
                    ),
                  )
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
          return resource.modality!;
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
        return resource.modality!;
    }
  }


}
