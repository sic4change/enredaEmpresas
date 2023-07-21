import 'package:enreda_empresas/app/models/city.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Widget streamBuilderForCity (BuildContext context, String? selectedCountryId, String? selectedProvinceId, City? selectedCity, functionToWriteBackThings, genericType ) {
  final database = Provider.of<Database>(context, listen: false);
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 14, 16, md: 15);
  return StreamBuilder<List<City>>(
      stream: database.citiesProvinceStream(selectedProvinceId),
      builder: (context, snapshotCities) {
        List<DropdownMenuItem<City>> cityItems = [];
        if (snapshotCities.hasData &&
            selectedProvinceId != null &&
            snapshotCities.data!.isNotEmpty &&
            snapshotCities.data![0].provinceId == selectedProvinceId &&
            snapshotCities.data![0].countryId == selectedCountryId) {
              cityItems = snapshotCities.data!.map((City city) {
                if (selectedCity == null &&
                    city.cityId == genericType.address?.city) {
                  selectedCity = city;
                }
                return DropdownMenuItem<City>(
                  value: city,
                  child: Text(city.name),
                );
              }).toList();
            }
        return DropdownButtonFormField<City>(
          hint: const Text(StringConst.FORM_CITY),
          isExpanded: true,
          value: selectedCity,
          items: cityItems,
          validator: (value) =>
              selectedCity != null ? null : StringConst.CITY_ERROR,
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
      });
}