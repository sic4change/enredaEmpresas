import 'package:enreda_empresas/app/common_widgets/expanded_row.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

Widget organizationRevisionForm(
    BuildContext context,
    String name,
    String firstName,
    String email,
    String phone,
    String countryName,
    String provinceName,
    String cityName,
    String postalCode,
    String natureName,
    String scopeName,
    String sizeOrgName,
    ){
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 14, 18, md: 15);
  return Column(
    children: [
      CustomExpandedRow(title: StringConst.FORM_ORGANIZATION, text: name,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_PHONE, text: phone,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_EMAIL, text: email,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_CONTACT, text: firstName,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_COUNTRY, text: countryName,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_PROVINCE, text: provinceName,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_CITY, text: cityName,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_POSTAL_CODE, text: postalCode,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_NATURE, text: natureName,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_SCOPE, text: scopeName,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_SIZE, text: sizeOrgName,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      Text(
        StringConst.FORM_ACCEPTANCE,
        style: textTheme.bodyText1?.copyWith(
          height: 1.5,
          color: AppColors.greyDark,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        ), ),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
    ],
  );
}