import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/expanded_row.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

Widget companyRevisionForm(
    BuildContext context,
    String name,
    String cif,
    String category,
    String mission,
    String phoneWithCodeSocialEntity,
    String countryName,
    String provinceName,
    String cityName,
    String postalCode,
    String firstName,
    String lastName,
    String phone,
    String email,
    ){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CustomExpandedRow(title: StringConst.FORM_COMPANY_NAME, text: name,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_COMPANY_MISSION, text: mission,),
      CustomExpandedRow(title: StringConst.FORM_COMPANY_CIF_GROUP, text: cif,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_COMPANY_CATEGORY, text: category,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_PHONE_COMPANY, text: phoneWithCodeSocialEntity,),
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
      CustomTextSmall(text: StringConst.FORM_ACCEPTANCE,),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
    ],
  );
}