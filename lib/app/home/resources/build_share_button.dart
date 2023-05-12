// import 'package:enreda_app/app/home/models/resource.dart';
// import 'package:enreda_app/app/home/resources/resource_actions.dart';
// import 'package:enreda_app/common_widgets/spaces.dart';
// import 'package:enreda_app/utils/adaptive.dart';
// import 'package:enreda_app/utils/const.dart';
// import 'package:enreda_app/values/strings.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// Widget buildShareButton(BuildContext context, Resource resource, Color color) {
//   _showToast() {
//     FToast fToast = FToast().init(context);
//
//     Widget toast = Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(25.0),
//         color: Constants.blueMain.withOpacity(0.8),
//       ),
//       child: Text(
//         "Enlace copiado en el portapapeles",
//         style: TextStyle(color: Constants.white),
//       ),
//     );
//
//     fToast.showToast(
//       child: toast,
//       gravity: widthOfScreen(context) >= 1024
//           ? ToastGravity.BOTTOM_LEFT
//           : ToastGravity.SNACKBAR,
//       toastDuration: Duration(seconds: 2),
//     );
//   }
//   TextTheme textTheme = Theme.of(context).textTheme;
//   double fontSize = responsiveSize(context, 15, 15, md: 13);
//
//   return PopupMenuButton<int>(
//     tooltip: '',
//     onSelected: (int value) {
//       switch (value) {
//         case 1:
//           Clipboard.setData(ClipboardData(
//               text: StringConst.RESOURCE_LINK(resource.resourceId)));
//           _showToast();
//           break;
//         case 2:
//           shareResource(resource);
//           break;
//       }
//     },
//     itemBuilder: (context) {
//       return [
//         PopupMenuItem(
//           value: 1,
//           child: Row(
//             children: [
//               Icon(
//                 Icons.copy,
//                 color: Constants.textPrimary,
//               ),
//               SpaceW16(),
//               Text('Copiar enlace',
//                   style: TextStyle(
//                     color: Constants.textPrimary,
//                     fontSize: widthOfScreen(context) >= 1024 ? 16 : 12,
//                   )),
//             ],
//           ),
//         ),
//         PopupMenuItem(
//           value: 2,
//           child: Row(
//             children: [
//               Icon(
//                 Icons.share,
//                 color: Constants.grey,
//               ),
//               SpaceW16(),
//               Text('Compartir',
//                 style: textTheme.bodyText1?.copyWith(
//                   color: Constants.grey,
//                   height: 1.5,
//                   fontWeight: FontWeight.w400,
//                   fontSize: fontSize,
//                 ),),
//             ],
//           ),
//         )
//       ];
//     },
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(
//           FontAwesomeIcons.share,
//           color: color,
//           size: widthOfScreen(context) >= 1024 ? 15.0 : 15.0,
//         ),
//         SizedBox(width: 10),
//         Text('Compartir',
//           style: textTheme.bodyText1?.copyWith(
//             color: Constants.grey,
//             height: 1.5,
//             fontWeight: FontWeight.w400,
//             fontSize: fontSize,
//           ),),
//       ],
//     ),
//   );
// }