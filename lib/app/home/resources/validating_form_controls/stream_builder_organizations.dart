import 'package:enreda_empresas/app/models/gender.dart';
import 'package:enreda_empresas/app/models/organization.dart';
import 'package:enreda_empresas/app/models/resourcetype.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../values/values.dart';

Widget streamBuilderDropdownOrganizations (BuildContext context, Organization? selectedOrganization, String organizationId, functionToWriteBackThings ) {
  final database = Provider.of<Database>(context, listen: false);
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 14, 16, md: 15);
  return StreamBuilder<List<Organization>>(
      stream: database.filterOrganizationStream(organizationId),
      builder: (context, snapshotOrganizations){

        List<DropdownMenuItem<Organization>> organizationItems = [];
        if(snapshotOrganizations.hasData) {
          organizationItems = snapshotOrganizations.data!.map((Organization organization) =>
              DropdownMenuItem<Organization>(
                value: organization,
                child: Text(organization.name),
              ))
              .toList();
        }

        return DropdownButtonFormField<Organization>(
          hint: const Text(StringConst.FORM_PROMOTOR),
          isExpanded: true,
          value: selectedOrganization,
          items: organizationItems,
          validator: (value) => selectedOrganization != null ? null : StringConst.FORM_COMPANY_ERROR,
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