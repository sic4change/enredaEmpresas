import 'package:enreda_empresas/app/models/dedication.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/resourceCategory.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../values/strings.dart';
import '../../../values/values.dart';

Widget streamBuilderDropdownResourceCategory (BuildContext context, ResourceCategory? selectedResourceCategory,  functionToWriteBackThings, Resource resource ) {
  final database = Provider.of<Database>(context, listen: false);
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 14, 16, md: 15);
  return StreamBuilder<List<ResourceCategory>>(
      stream: database.resourceCategoryStream(),
      builder: (context, snapshotResourceCategory){

        List<DropdownMenuItem<ResourceCategory>> resourceCategoryItems = [];
        if (snapshotResourceCategory.hasData) {
          resourceCategoryItems = snapshotResourceCategory.data!.map((ResourceCategory resourceCategory) {
            if (selectedResourceCategory == null && resourceCategory.id == resource.resourceCategory) {
              selectedResourceCategory = resourceCategory;
            }
            return DropdownMenuItem<ResourceCategory>(
                value: resourceCategory,
                child: Text(resourceCategory.name),
              );
          })
              .toList();
        }
        

        return DropdownButtonFormField<ResourceCategory>(
          hint: const Text(StringConst.FORM_RESOURCE_CATEGORY),
          value: selectedResourceCategory,
          items: resourceCategoryItems,
          validator: (value) => selectedResourceCategory != null ? null : StringConst.FORM_MOTIVATION_ERROR,
          onChanged: (value) => functionToWriteBackThings(value),
          onSaved: (value) => functionToWriteBackThings(value),
          iconDisabledColor: AppColors.greyDark,
          iconEnabledColor: AppColors.primaryColor,
          decoration: InputDecoration(
            labelStyle: textTheme.button?.copyWith(
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
          style: textTheme.button?.copyWith(
            height: 1.5,
            color: AppColors.greyDark,
            fontWeight: FontWeight.w400,
            fontSize: fontSize,
          ),
        );
      });
}