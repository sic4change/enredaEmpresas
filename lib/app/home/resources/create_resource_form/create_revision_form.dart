import 'package:enreda_empresas/app/common_widgets/expanded_row.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

Widget resourceRevisionForm(
  BuildContext context,
  String resourceTitle,
  String resourceDescription,
  String resourceTypeName,
  String resourceCategoryName,
  String selectedDegree,
  String selectedContract,
  String selectedSalary,
  String interestsNames,
  String formattedStartDate,
  String formattedEndDate,
  String formattedMaxDate,
  String duration,
  String schedule,
) {
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 14, 16, md: 15);
  return Column(
    children: [
      CustomExpandedRow(title: StringConst.FORM_TITLE, text: resourceTitle),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.DESCRIPTION, text: resourceDescription),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_RESOURCE_TYPE, text: resourceTypeName),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_RESOURCE_CATEGORY, text: resourceCategoryName),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_DEGREE, text: selectedDegree),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_CONTRACT, text: selectedContract),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_SALARY, text: selectedSalary),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_START, text: formattedStartDate),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_END, text: formattedEndDate),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_MAX, text: formattedMaxDate),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_DURATION, text: duration),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      CustomExpandedRow(title: StringConst.FORM_SCHEDULE, text: schedule),
      const SizedBox(height: Sizes.kDefaultPaddingDouble),
      (interestsNames != '') ? const SizedBox(height: Sizes.kDefaultPaddingDouble) : Container(),
      (interestsNames != '') ? CustomExpandedRow(title: StringConst.FORM_INTERESTS, text: interestsNames) : Container(),
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