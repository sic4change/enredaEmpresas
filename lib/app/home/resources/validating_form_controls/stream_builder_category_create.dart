import 'package:enreda_empresas/app/models/dedication.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/resourceCategory.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../values/strings.dart';
import '../../../values/values.dart';

Widget streamBuilderDropdownResourceCategoryCreate (BuildContext context, ResourceCategory? selectedResourceCategory,  functionToWriteBackThings ) {
  final database = Provider.of<Database>(context, listen: false);
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 14, 16, md: 15);
  const String targetId = 'POUBGFk5gU6c5X1DKo1b';
  return StreamBuilder<List<ResourceCategory>>(
      stream: database.resourceCategoryStream(),
      builder: (context, snapshotResourceCategory){

        List<DropdownMenuItem<ResourceCategory>> resourceCategoryItems = [];
        ResourceCategory? initResourceCategory;
        if (snapshotResourceCategory.hasData) {
          resourceCategoryItems = snapshotResourceCategory.data!.map((ResourceCategory resourceCategory) {
            if (resourceCategory.id == targetId) {
              initResourceCategory = resourceCategory;
            }
            return DropdownMenuItem<ResourceCategory>(
              value: resourceCategory,
              child: Text(resourceCategory.name),
            );
          }).toList();

          // Set the initial value if not already selected
          if (selectedResourceCategory == null && initResourceCategory != null) {
            selectedResourceCategory = initResourceCategory;
          }
        }

        return DropdownButtonFormField<ResourceCategory>(
          value: selectedResourceCategory,
          items: resourceCategoryItems,
          validator: (value) => selectedResourceCategory != null ? null : StringConst.FORM_MOTIVATION_ERROR,
          onChanged: null, //(value) => functionToWriteBackThings(value),
          iconDisabledColor: AppColors.greyDark,
          iconEnabledColor: AppColors.primaryColor,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelStyle: textTheme.bodySmall?.copyWith(
              height: 1.5,
              color: AppColors.greyDark,
              fontWeight: FontWeight.w400,
              fontSize: fontSize,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: AppColors.greyUltraLight,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: AppColors.greyUltraLight,
                width: 1.0,
              ),
            ),
          ),
          style: textTheme.bodySmall?.copyWith(
            height: 1.5,
            color: AppColors.greyDark,
            fontWeight: FontWeight.w400,
            fontSize: fontSize,
          ),
        );
      });
}