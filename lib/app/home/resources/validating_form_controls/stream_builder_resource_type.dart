import 'package:enreda_empresas/app/models/gender.dart';
import 'package:enreda_empresas/app/models/resource.dart';
import 'package:enreda_empresas/app/models/resourcetype.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../values/values.dart';

Widget streamBuilderDropdownResourceType (BuildContext context, ResourceType? selectedResourceType,  functionToWriteBackThings, Resource resource ) {
  final database = Provider.of<Database>(context, listen: false);
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 14, 16, md: 15);
  return StreamBuilder<List<ResourceType>>(
      stream: database.resourceTypeStream(),
      builder: (context, snapshotResourceTypes){

        List<DropdownMenuItem<ResourceType>> resourceTypeItems = [];
        if(snapshotResourceTypes.hasData) {
          resourceTypeItems = snapshotResourceTypes.data!.map((ResourceType resourceType) {
            if (selectedResourceType == null && resourceType.resourceTypeId == resource.resourceType) {
              selectedResourceType = resourceType;
            }
            return DropdownMenuItem<ResourceType>(
                value: resourceType,
                child: Text(resourceType.name),
              );
          })
              .toList();
        }

        // si el selectedValue no está en la lista, entonces lo volvemos nulo

        return DropdownButtonFormField<ResourceType>(
          hint: const Text(StringConst.FORM_RESOURCE_TYPE),
          isExpanded: true,
          value: selectedResourceType,
          items: resourceTypeItems,
          validator: (value) => selectedResourceType != null ? null : StringConst.FORM_RESOURCE_TYPE_ERROR,
          onChanged: (value) => functionToWriteBackThings(value),
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
              borderSide: const BorderSide(
                color: AppColors.greyUltraLight,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(
                color: AppColors.greyUltraLight,
                width: 1.0,
              ),
            ),
          ),
          style: textTheme.button?.copyWith(
            height: 1.5,
            fontWeight: FontWeight.w400,
            color: AppColors.greyDark,
            fontSize: fontSize,
          ),
        );
      });
}