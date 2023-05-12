import 'package:enreda_empresas/app/sign_in/validators.dart';

enum EmailSignFormType { sigIn, register }

class EmailSignInModel with EmailAndPasswordValidator {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignFormType.sigIn,
    this.isLoading = false,
    this.submited = false,
  });
  final String email;
  final String password;
  final EmailSignFormType formType;
  final bool isLoading;
  final bool submited;

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

  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailSignFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submited: submitted ?? this.submited,
    );
  }
}
