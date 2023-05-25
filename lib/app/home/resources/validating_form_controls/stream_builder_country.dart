import 'package:enreda_empresas/app/models/country.dart';
import 'package:enreda_empresas/app/services/database.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../values/values.dart';

Widget streamBuilderForCountry (BuildContext context, Country? selectedCountry,  functionToWriteBackThings ) {
  final database = Provider.of<Database>(context, listen: false);
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 14, 16, md: 15);
  return StreamBuilder<List<Country>>(
      stream: database.countryFormatedStream(),
      builder: (context, snapshotCountries){

        List<DropdownMenuItem<Country>> countryItems = [];
        if (snapshotCountries.hasData) {
          countryItems = snapshotCountries.data!.map((Country c) =>
              DropdownMenuItem<Country>(
                value: c,
                child: Text(c.name),
              ))
              .toList();
        }

        return DropdownButtonFormField<Country>(
          hint: Text(StringConst.FORM_COUNTRY),
          isExpanded: true,
          value: selectedCountry,
          items: countryItems,
          validator: (value) => selectedCountry != null ? null : StringConst.COUNTRY_ERROR,
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
            fontWeight: FontWeight.w400,
            color: AppColors.greyDark,
            fontSize: fontSize,
          ),
        );
      });
}