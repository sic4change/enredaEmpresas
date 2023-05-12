import 'package:enreda_empresas/app/services/auth.dart';
import 'package:enreda_empresas/app/sign_in/email_sign_in_model.dart';
import 'package:enreda_empresas/app/sign_in/validators.dart';
import 'package:flutter/foundation.dart';



class EmailSignInChangeModel with EmailAndPasswordValidator, ChangeNotifier {
  EmailSignInChangeModel({
    required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailSignFormType.sigIn,
    this.isLoading = false,
    this.submited = false,
  });
  final AuthBase auth;
  String email;
  String password;
  EmailSignFormType formType;
  bool isLoading;
  bool submited;

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailSignFormType.sigIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText {
    return formType == EmailSignFormType.sigIn ? 'Acceder' : 'Crear cuenta';
  }

  String get secundaryButtonText {
    return formType == EmailSignFormType.sigIn
        ? 'Necesitas una cuenta? Regístrate'
        : 'Ya tienes una cuenta? Accede';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        emailValidator.isValid(password) &&
        !isLoading;
  }

  String? get passwordErrorText {
    bool showErrorText = submited && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String? get emailErrorText {
    bool showErrorText = submited && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  void toggleFormType() {
    final formType = this.formType == EmailSignFormType.sigIn
        ? EmailSignFormType.register
        : EmailSignFormType.sigIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String? email,
    String? password,
    EmailSignFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
      this.email = email ?? this.email;
      this.password = password ?? this.password;
      this.formType = formType ?? this.formType;
      this.isLoading = isLoading ?? this.isLoading;
      this.submited = submitted ?? this.submited;
      notifyListeners();
  }
}
