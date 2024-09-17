import 'package:enreda_empresas/app/common_widgets/expanded_row.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

Widget companyRevisionForm(
    BuildContext context,
    String name,
    String cif,
    String category,
    String mission,
    String geographicZone,
    String subGeographicZone,
    String phoneWithCodeSocialEntity,
    String linkedin,
    String otherSocialMedia,
    String countryName,
    String provinceName,
    String cityName,
    String postalCode,
    String firstName,
    String lastName,
    String phone,
    String email,
    ){
  TextTheme textTheme = Theme.of(context).textTheme;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CustomExpandedRow(title: StringConst.FORM_COMPANY_NAME, text: name,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_COMPANY_CIF, text: cif,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_COMPANY_CATEGORY, text: category,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_COMPANY_MISSION, text: mission,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.ZONE, text: geographicZone,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.SUB_ZONE, text: subGeographicZone,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_PHONE_COMPANY, text: phoneWithCodeSocialEntity,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_LINKEDIN, text: linkedin,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_OTHER_SOCIAL_MEDIA, text: otherSocialMedia,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_COUNTRY, text: countryName,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_PROVINCE, text: provinceName,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_CITY, text: cityName,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_POSTAL_CODE, text: postalCode,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_CONTACT, text: '${firstName} ${lastName}',),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_PHONE, text: phone,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_EMAIL, text: email,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      Text(
        StringConst.FORM_ACCEPTANCE,
        style: textTheme.bodyMedium?.copyWith(
          height: 1.5,
          color: AppColors.greyDark,
          fontWeight: FontWeight.w700,
        ), ),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
    ],
  );
}