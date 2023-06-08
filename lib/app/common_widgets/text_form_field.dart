import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';


Widget customTextFormField(BuildContext context, String formValue, String labelText, String errorText, functionSetState) {
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 13, 15, md: 14);
  return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        focusColor: AppColors.lilac,
        labelStyle: textTheme.bodySmall?.copyWith(
          color: AppColors.greyDark,
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
      initialValue: formValue,
      validator: (value) =>
      value!.isNotEmpty ? null : errorText,
      onSaved: (String? val) => functionSetState(val),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.name,
      style: textTheme.bodySmall?.copyWith(
        color: AppColors.greyDark,
        fontSize: fontSize,
      ),
  );
}

Widget customTextFormFieldNotValidator(BuildContext context, String formValue, String labelText, functionSetState) {
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 13, 15, md: 14);
  return TextFormField(
    decoration: InputDecoration(
      labelText: labelText,
      focusColor: AppColors.lilac,
      labelStyle: textTheme.bodySmall?.copyWith(
        color: AppColors.greyDark,
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
    initialValue: formValue,
    onSaved: (val) => functionSetState(val),
    textCapitalization: TextCapitalization.sentences,
    keyboardType: TextInputType.name,
    style: textTheme.bodySmall?.copyWith(
      color: AppColors.greyDark,
      fontSize: fontSize,
    ),
  );
}

Widget customTextFormMultiline(BuildContext context, String formValue, String labelText, String errorText, functionSetState) {
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 13, 15, md: 14);
  return TextFormField(
    maxLines: null, // Set this
    keyboardType: TextInputType.multiline,
    decoration: InputDecoration(
      labelText: labelText,
      focusColor: AppColors.lilac,
      labelStyle: textTheme.bodySmall?.copyWith(
        color: AppColors.greyDark,
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
    initialValue: formValue,
    validator: (value) =>
    value!.isNotEmpty ? null : errorText,
    onSaved: (String? val) => functionSetState(val),
    textCapitalization: TextCapitalization.sentences,
    style: textTheme.bodySmall?.copyWith(
      color: AppColors.greyDark,
      fontSize: fontSize,
    ),
  );
}

Widget customTextFormFieldNum(BuildContext context, int formValue, String labelText, String errorText, functionSetState) {
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 13, 15, md: 14);
  return TextFormField(
    decoration: InputDecoration(
      labelText: labelText,
      focusColor: AppColors.lilac,
      labelStyle: textTheme.bodySmall?.copyWith(
        color: AppColors.greyDark,
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
    initialValue: formValue.toString(),
    validator: (value) =>
    value!.isNotEmpty ? null : errorText,
    onSaved: (String? val) => functionSetState(val),
    textCapitalization: TextCapitalization.sentences,
    keyboardType: TextInputType.number,
    style: textTheme.bodySmall?.copyWith(
      color: AppColors.greyDark,
      fontSize: fontSize,
    ),
  );
}

Widget customTextFormMultilineNotValidator(BuildContext context, String formValue, String labelText, functionSetState) {
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 13, 15, md: 14);
  return TextFormField(
    maxLines: null, // Set this
    keyboardType: TextInputType.multiline,
    decoration: InputDecoration(
      labelText: labelText,
      focusColor: AppColors.lilac,
      labelStyle: textTheme.bodySmall?.copyWith(
        color: AppColors.greyDark,
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
    initialValue: formValue,
    onSaved: (String? val) => functionSetState(val),
    textCapitalization: TextCapitalization.sentences,
    style: textTheme.bodySmall?.copyWith(
      color: AppColors.greyDark,
      fontSize: fontSize,
    ),
  );
}