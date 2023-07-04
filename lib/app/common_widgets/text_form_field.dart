import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


Widget customTextFormField(BuildContext context, String formValue, String labelText, String errorText, functionSetState) {
  TextTheme textTheme = Theme.of(context).textTheme;
  return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        focusColor: AppColors.lilac,
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.greyDark,
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
      style: textTheme.bodyMedium?.copyWith(
        color: AppColors.greyDark,
      ),
  );
}

Widget customTextFormFieldNotValidator(BuildContext context, String formValue, String labelText, functionSetState) {
  TextTheme textTheme = Theme.of(context).textTheme;
  return TextFormField(
    decoration: InputDecoration(
      labelText: labelText,
      focusColor: AppColors.lilac,
      labelStyle: textTheme.bodyLarge?.copyWith(
        color: AppColors.greyDark,
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
    style: textTheme.bodyMedium?.copyWith(
      color: AppColors.greyDark,
    ),
  );
}

Widget customTextFormMultiline(BuildContext context, String formValue, String labelText, String errorText, functionSetState) {
  TextTheme textTheme = Theme.of(context).textTheme;
  return TextFormField(
    maxLines: null, // Set this
    keyboardType: TextInputType.multiline,
    decoration: InputDecoration(
      labelText: labelText,
      focusColor: AppColors.lilac,
      labelStyle: textTheme.bodyLarge?.copyWith(
        color: AppColors.greyDark,
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
    style: textTheme.bodyMedium?.copyWith(
      color: AppColors.greyDark,
    ),
  );
}

Widget customTextFormFieldNum(BuildContext context, String formValue, String labelText, String errorText, functionSetState) {
  TextTheme textTheme = Theme.of(context).textTheme;
  return TextFormField(
    decoration: InputDecoration(
      labelText: labelText,
      focusColor: AppColors.lilac,
      labelStyle: textTheme.bodyLarge?.copyWith(
        color: AppColors.greyDark,
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
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly
    ],
    onSaved: (String? val) => functionSetState(val),
    textCapitalization: TextCapitalization.sentences,
    keyboardType: TextInputType.number,
    style: textTheme.bodyMedium?.copyWith(
      color: AppColors.greyDark,
    ),
  );
}

Widget customTextFormMultilineNotValidator(BuildContext context, String formValue, String labelText, functionSetState) {
  TextTheme textTheme = Theme.of(context).textTheme;
  return TextFormField(
    maxLines: null, // Set this
    keyboardType: TextInputType.multiline,
    decoration: InputDecoration(
      labelText: labelText,
      focusColor: AppColors.lilac,
      labelStyle: textTheme.bodyLarge?.copyWith(
        color: AppColors.greyDark,
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
    style: textTheme.bodyMedium?.copyWith(
      color: AppColors.greyDark,
    ),
  );
}

Widget customDatePicker(BuildContext context, DateTime time, String labelText, String errorText, functionSetState) {
  TextTheme textTheme = Theme.of(context).textTheme;
  return DateTimeField(
    initialValue: time,
    format: DateFormat('dd/MM/yyyy'),
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.calendar_today),
      labelText: labelText,
      labelStyle: textTheme.bodyLarge?.copyWith(
        height: 1.5,
        color: AppColors.greyDark,
        fontWeight: FontWeight.w400,
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
    style: textTheme.bodyMedium?.copyWith(
      height: 1.5,
      color: AppColors.greyDark,
      fontWeight: FontWeight.w400,
    ),
    onShowPicker: (context, currentValue) {
      return showDatePicker(
        context: context,
        locale: Locale('es', 'ES'),
        firstDate: DateTime(DateTime.now().year - 100, DateTime.now().month, DateTime.now().day),
        initialDate: currentValue ?? DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 100, DateTime.now().month, DateTime.now().day),
      );
    },
    onChanged: (dateTime) => functionSetState(dateTime),
    validator: (value) => value != null ? null : errorText,
  );
}
