import 'package:enreda_empresas/app/common_widgets/alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/show_exception_alert_dialog.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/home/web_home.dart';
import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/sign_in/email_sign_in_change_model.dart';
import 'package:enreda_empresas/app/utils/adaptative.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../sign_up/company/company_registering.dart';


class EmailSignInFormChangeNotifier extends StatefulWidget {
  final EmailSignInChangeModel model;

  const EmailSignInFormChangeNotifier({super.key, required this.model});

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscureText = true;
  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  List<Widget> _buildChildren(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: _buildEmailTextField(),
      ),
      const SizedBox(
        height: 16.0,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: _buildPasswordTextField(),
      ),
      const SpaceH20(),
      Center(
        child: TextButton(
          onPressed: model.canSubmit ? _submit : null,
          style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.all(AppColors.turquoiseButton2),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ))),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 16.0, horizontal: 48.0),
            child: Text(
              StringConst.ACCESS,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary900,
              ),
            ),
          ),
        ),
      ),
      const SpaceH12(),
      _buildForgotPassword(context),
      const SpaceH12(),
      _buildCreateAccount(context),
      const SizedBox(
        height: 8.0,
      ),
    ];
  }

  TextField _buildEmailTextField() {
    double fontSize = responsiveSize(context, 14, 16, md: 15);
    TextTheme textTheme = Theme.of(context).textTheme;
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      cursorColor: AppColors.primary900,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.white,
        labelText: 'Correo electrónico',
        hintText: 'email@email.com',
        hintStyle: textTheme.bodySmall?.copyWith(
          height: 1.5,
          color: AppColors.primary900,
          fontWeight: FontWeight.w400,
          fontSize: fontSize,
        ),
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
        focusColor: AppColors.primary900,
        labelStyle: textTheme.bodySmall?.copyWith(
          height: 1.5,
          color: AppColors.primary900,
          fontWeight: FontWeight.w400,
          fontSize: fontSize,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary900, width: 1.0),
        ),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: AppColors.primary900,
            width: 1.0,
          ),
        ),
        floatingLabelStyle: const TextStyle(color: AppColors.primary900),

      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: model.updateEmail,
      onEditingComplete: () => _emailEditingComplete(),
      style: textTheme.bodySmall?.copyWith(
        height: 1.5,
        color: AppColors.primary900,
        fontWeight: FontWeight.w400,
        fontSize: fontSize,
      ),
    );
  }

  TextField _buildPasswordTextField() {
    double fontSize = responsiveSize(context, 14, 16, md: 15);
    TextTheme textTheme = Theme.of(context).textTheme;
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      cursorColor: AppColors.primary900,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.white,
        labelText: 'Contraseña',
        hintStyle: textTheme.bodySmall?.copyWith(
          height: 1.5,
          color: AppColors.primary900,
          fontWeight: FontWeight.w400,
          fontSize: fontSize,
        ),
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: InkWell(
            onTap: _toggle,
            child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: FaIcon(_obscureText ? FontAwesomeIcons.eye :
                FontAwesomeIcons.eyeSlash, size: 20, color: AppColors.primary900,)),
          ),
        ),
        focusColor: AppColors.primary900,
        labelStyle: textTheme.bodySmall?.copyWith(
          height: 1.5,
          color: AppColors.primary900,
          fontWeight: FontWeight.w400,
          fontSize: fontSize,
        ),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary900, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: AppColors.primary900,
            width: 1.0,
          ),
        ),
        floatingLabelStyle: const TextStyle(color: AppColors.primary900),
      ),
      obscureText: _obscureText,
      textInputAction: TextInputAction.done,
      onChanged: model.updatePassword,
      onEditingComplete: _submit,
      style: textTheme.bodySmall?.copyWith(
        height: 1.5,
        color: AppColors.primary900,
        fontWeight: FontWeight.w400,
        fontSize: fontSize,
      ),
    );
  }

  void _launchForgotPassword(BuildContext context) {
    if (_emailController.value.text.isNotEmpty &&
        RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(_emailController.value.text)) {
      _confirmChangePassword(context);
    } else {
      _showMessageNotChangePassword(context);
    }
  }

  Widget _buildForgotPassword(BuildContext context) {
    return InkWell(
      mouseCursor: MaterialStateMouseCursor.clickable,
      onTap: () => _launchForgotPassword(context),
      child: const Center(child: CustomTextBold(title: "¿Has olvidado la contraseña?", color: AppColors.primary900,)),
    );
  }

  void _organizationRegistering(BuildContext context) {
    Navigator.of(this.context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: ((context) => const CompanyRegistering()),
      ),
    );
  }

  Widget _buildCreateAccount(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomTextSmall(text: '¿Aún no tienes cuenta?', color: AppColors.primary900),
        const SpaceW8(),
        InkWell(
          mouseCursor: MaterialStateMouseCursor.clickable,
          onTap: () => _organizationRegistering(context),
          child: const Center(
              child: CustomTextBold(title: "Regístrate", color: AppColors.primary900,),
        ),
        ),
      ],
    );
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      WebHome.goToControlPanel();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Error',
        exception: e,
      );
    }
  }

  Future<void> _changePassword(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.changePasswordWithEmail(_emailController.value.text);
      _emailController.clear();
      _passwordController.clear();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _confirmChangePassword(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Cambiar contraseña',
        content: 'Si pulsa en Aceptar se le envirá a su correo las acciones a '
            'realizar para cambiar su contraseña. Si no aparece, revisa las carpetas de SPAM y Correo no deseado',
        cancelActionText: 'Cancelar',
        defaultActionText: 'Aceptar');
    if (didRequestSignOut == true) {
      _changePassword(context);
    }
  }

  Future<void> _showMessageNotChangePassword(BuildContext context) async {
    showAlertDialog(
      context,
      title: 'Cambiar contraseña',
      content: 'Debes introducir un correo electrónico válido',
      defaultActionText: 'Ok',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: _buildChildren(context),
    );
  }
}
