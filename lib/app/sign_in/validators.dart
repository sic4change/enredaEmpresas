abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator {

  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }

}

mixin EmailAndPasswordValidator {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
  final String invalidEmailErrorText = 'El correo no puede estar vacío';
  final String invalidPasswordErrorText = 'La contraseña no puede estar vacía';
}