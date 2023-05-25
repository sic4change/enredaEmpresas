import 'package:enreda_empresas/app/common_widgets/expanded_row.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

Widget ResourceRevisionForm(
    BuildContext context,
    String _firstName,
    String _lastName,
    String _email,
    String genderName,
    String countryName,
    String provinceName,
    String cityName,
    String _postalCode,
    String abilitesNames,
    String dedicationName,
    String timeSearchingName,
    String timeSpentWeeklyName,
    String educationName,
    String specificInterestsNames,
    String interestsNames,
    ){
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 14, 16, md: 15);
  return Column(
    children: [
      CustomExpandedRow(title: StringConst.FORM_TITLE, text: _firstName),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_LASTNAME, text: _lastName),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_EMAIL, text: _email),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_RESOURCE_TYPE, text: genderName),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_COUNTRY, text: countryName),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_PROVINCE, text: provinceName),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_CITY, text: cityName),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_POSTAL_CODE, text: _postalCode),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_ABILITIES_REV, text: abilitesNames),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_DEDICATION_REV, text: dedicationName),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_TIME_SEARCHING_REV, text: timeSearchingName),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_TIME_SPENT_WEEKLY_REV, text: timeSpentWeeklyName),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_EDUCATION_REV, text: educationName),
      (interestsNames != '') ? const SizedBox(height: Sizes.kDefaultPaddingDouble) : Container(),
      (interestsNames != '') ? CustomExpandedRow(title: StringConst.FORM_INTERESTS, text: interestsNames) : Container(),
      (specificInterestsNames != '') ? const SizedBox(height: Sizes.kDefaultPaddingDouble) : Container(),
      (specificInterestsNames != '') ? CustomExpandedRow(title: StringConst.FORM_SPECIFIC_INTERESTS, text: specificInterestsNames) : Container(),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      Text(StringConst.FORM_ACCEPTANCE,
        style: textTheme.button?.copyWith(
          height: 1.5,
          color: AppColors.greyDark,
          fontWeight: FontWeight.w400,
          fontSize: fontSize,
        ),),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
    ],
  );
}