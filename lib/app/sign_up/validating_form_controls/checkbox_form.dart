import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/utils/functions.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget checkboxForm(BuildContext context, _checkFieldKey, bool _isChecked, functionSetState) {
  TextTheme textTheme = Theme.of(context).textTheme;
  double fontSize = responsiveSize(context, 14, 16, md: 15);
  return Form(
    key: _checkFieldKey,
    child: FormField<bool>(
      initialValue: _isChecked,
      builder: (FormFieldState<bool> state) {
        return Column(
          children: <Widget>[
            Row(
              children: [
                Checkbox(
                    activeColor: AppColors.primaryColor,
                    value: state.value,
                    onChanged: (bool? val) => { functionSetState(val), state.didChange(val)}
                ),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: StringConst.FORM_ACCEPT_SENTENCE,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.primary900,
                            height: 1.5,
                            fontSize: fontSize,
                          ),
                        ),
                        TextSpan(
                          text: StringConst.PRIVACY_POLICIES,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                            fontSize: fontSize,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchURL(StringConst.POLICIES_URL);
                            },
                        ),
                        TextSpan(
                          text: StringConst.FORM_ACCEPT_SENTENCE_Y,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.primary900,
                            height: 1.5,
                            fontSize: fontSize,
                          ),
                        ),
                        TextSpan(
                          text: StringConst.USE_CONDITIONS,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                            fontSize: fontSize,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchURL(StringConst.USE_CONDITIONS_URL);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            state.errorText == null
                ? Text("")
                : Text(state.errorText!, style: TextStyle(color: AppColors.red, fontSize: 13)),
          ],
        );
      },
      validator: (value) => _isChecked ? null : StringConst.FORM_ACCEPTANCE_ERROR,
    ),
  );
}