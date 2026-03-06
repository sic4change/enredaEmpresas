import 'package:enreda_empresas/app/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';

Widget checkboxNewsletterForm({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required bool isChecked,
  required Function(bool?) onToggle,
}) {
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 14, 16, md: 15);
  return Form(
    key: formKey,
    child: FormField<bool>(
      initialValue: isChecked,
      builder: (FormFieldState<bool> state) {
        return Column(
          children: <Widget>[
            Row(
              children: [
                Checkbox(
                    activeColor: AppColors.primaryColor,
                    value: state.value,
                    onChanged: (bool? val) {
                      onToggle(val);
                      state.didChange(val);
                    }
                ),
                Flexible(
                  child: Text(
                    StringConst.FORM_NEWSLETTER,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.primary900,
                      height: 1.5,
                      fontSize: fontSize,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );
}
