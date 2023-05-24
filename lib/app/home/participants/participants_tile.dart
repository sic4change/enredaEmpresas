// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:enreda_empresas/app/common_widgets/precached_avatar.dart';
// import 'package:enreda_empresas/app/models/userEnreda.dart';
// import 'package:enreda_empresas/app/services/auth.dart';
// import 'package:enreda_empresas/app/utils/adaptative.dart';
// import 'package:enreda_empresas/app/utils/responsive.dart';
// import 'package:enreda_empresas/app/values/values.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class ParticipantsListTile extends StatefulWidget {
//   const ParticipantsListTile({Key? key, required this.user, this.onTap})
//       : super(key: key);
//   final UserEnreda user;
//   final VoidCallback? onTap;
//
//   @override
//   State<ParticipantsListTile> createState() => _ParticipantsListTileState();
// }
//
// class _ParticipantsListTileState extends State<ParticipantsListTile> {
//   String? codeDialog;
//   String? valueText;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthBase>(context, listen: false);
//
//     TextTheme textTheme = Theme.of(context).textTheme;
//     double fontSize = responsiveSize(context, 15, 15, md: 13);
//     double sidePadding = responsiveSize(context, 15, 20, md: 17);
//
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Container(
//         height: Responsive.isMobile(context) ? 450 : 373,
//         width: Responsive.isMobile(context) ? double.infinity : 240,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: AppColors.greyLight2.withOpacity(0.3), width: 1),
//           borderRadius: const BorderRadius.all(Radius.circular(10)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.15),
//               spreadRadius: 3,
//               blurRadius: 3,
//               offset: Offset(1, 1), // changes position of shadow
//             ),
//           ],
//         ),
//         margin: const EdgeInsets.all(5.0),
//         child: InkWell(
//           mouseCursor: MaterialStateMouseCursor.clickable,
//           onTap: widget.onTap,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: !kIsWeb
//                     ? ClipRRect(
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(10),
//                           topRight: Radius.circular(10),
//                         ),
//                       child: Expanded(
//                           child: widget.user.photo == null ||
//                                   widget.user.photo == ""
//                               ? Container(
//                                   color: Colors.transparent,
//                                   height: 120,
//                                   width: 120,
//                                   child: Image.asset(ImagePath.USER_DEFAULT),
//                                 )
//                               : CachedNetworkImage(
//                                   width: double.infinity,
//                                   fit: BoxFit.cover,
//                                   progressIndicatorBuilder:
//                                       (context, url, downloadProgress) =>
//                                           Container(
//                                             child: Image.asset(
//                                                 ImagePath.IMAGE_DEFAULT),
//                                           ),
//                                   alignment: Alignment.center,
//                                   imageUrl: widget.user.photo!),
//                         ),
//                     )
//                     : ClipRRect(
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(10),
//                           topRight: Radius.circular(10),
//                         ),
//                       child: Expanded(
//                           child: widget.user.photo == null ||
//                                   widget.user.photo == ""
//                               ? Container(
//                                   color: Colors.transparent,
//                                   height: 120,
//                                   width: 120,
//                                   child: Image.asset(ImagePath.USER_DEFAULT),
//                                 )
//                               : PrecacheResourceCard(
//                                   imageUrl: widget.user.photo!,
//                                 )),
//                     ),
//               ),
//               Expanded(
//                 flex: Responsive.isMobile(context) ? 1 : 2,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: <Widget>[
//                     const SizedBox(height: 20),
//                     Padding(
//                       padding: EdgeInsets.only(
//                           left: sidePadding, right: sidePadding),
//                       child: Text(
//                         '${widget.user.firstName!} ${widget.user.lastName!}'
//                             .toUpperCase(),
//                         textAlign: TextAlign.left,
//                         maxLines: 1,
//                         style: textTheme.bodyLarge?.copyWith(
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.greyTxtAlt,
//                             fontSize: 16.0),
//                       ),
//                     ),
//                     SizedBox(height: 5,),
//                     Padding(
//                       padding: EdgeInsets.only(
//                           left: sidePadding, right: sidePadding),
//                       child: Text(
//                         widget.user.educationName?.toUpperCase() ?? '',
//                         textAlign: TextAlign.left,
//                         maxLines: 1,
//                         style: textTheme.bodySmall?.copyWith(
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.penBlue,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:enreda_empresas/app/common_widgets/precached_avatar.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ParticipantsListTile extends StatefulWidget {
  const ParticipantsListTile({Key? key, required this.user, this.onTap})
      : super(key: key);
  final UserEnreda user;
  final VoidCallback? onTap;

  @override
  State<ParticipantsListTile> createState() => _ParticipantsListTileState();
}

class _ParticipantsListTileState extends State<ParticipantsListTile> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double sidePadding = responsiveSize(context, 15, 20, md: 17);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: const EdgeInsets.all(5.0),
        child: InkWell(
          mouseCursor: MaterialStateMouseCursor.clickable,
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyLight2.withOpacity(0.3), width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.greyAlt.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(1, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: Responsive.isMobile(context) ? 200: 150,
                  child: !kIsWeb
                      ? ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Expanded(
                            child: widget.user.photo == null ||
                                    widget.user.photo == ""
                                ? Container(
                                    color: Colors.transparent,
                                    height: 120,
                                    width: 120,
                                    child: Image.asset(ImagePath.USER_DEFAULT),
                                  )
                                : CachedNetworkImage(
                                    width: 400,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Container(
                                              child: Image.asset(
                                                  ImagePath.IMAGE_DEFAULT),
                                            ),
                                    alignment: Alignment.center,
                                    imageUrl: widget.user.photo!),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Expanded(
                              child: widget.user.photo == null ||
                                      widget.user.photo == ""
                                  ? Container(
                                      color: Colors.transparent,
                                      height: 120,
                                      width: 120,
                                      child:
                                          Image.asset(ImagePath.USER_DEFAULT),
                                    )
                                  : PrecacheResourceCard(
                                      imageUrl: widget.user.photo!,
                                    )),
                        ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    color: Colors.white,
                  ),
                  height: 115,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 45,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: sidePadding, right: sidePadding),
                              child: Text(
                                '${widget.user.firstName!} ${widget.user.lastName!}',
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.greyDark2),
                              ),
                            ),
                            const SpaceH4(),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: sidePadding, left: sidePadding),
                              child: Text(
                                widget.user.educationName?.toUpperCase() ?? '',
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                style: textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.penBlue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
