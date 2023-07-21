import 'package:enreda_empresas/app/models/province.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Widget streamBuilderForProvince (BuildContext context, String? selectedCountryId, Province? selectedProvince,  functionToWriteBackThings, genericType ) {
  final database = Provider.of<Database>(context, listen: false);
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 14, 16, md: 15);
  return StreamBuilder<List<Province>>(
      stream: database.provincesCountryStream(selectedCountryId),
      builder: (context, snapshotProvinces) {

        List<DropdownMenuItem<Province>> provinceItems = [];
        if (snapshotProvinces.hasData && selectedCountryId != null &&
            snapshotProvinces.data!.isNotEmpty &&
            snapshotProvinces.data![0].countryId == selectedCountryId) {
          provinceItems = snapshotProvinces.data!.map((Province province) {
            if (selectedProvince == null && province.provinceId == genericType.address?.province) {
              selectedProvince = province;
            }
            return DropdownMenuItem<Province>(
                value: province,
                child: Text(province.name),
              );
          }
          ).toList();
        }

        return DropdownButtonFormField<Province>(
          hint: const Text(StringConst.FORM_PROVINCE),
          isExpanded: true,
          value: selectedProvince,
          items: provinceItems,
          validator: (value) => selectedProvince != null ?
          null : StringConst.PROVINCE_ERROR,
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
      }
  );
}