import 'package:formz/formz.dart';

enum RequiredFieldError { isEmpty }

class RequiredField extends FormzInput<String, RequiredFieldError> {
  const RequiredField.pure({String value = ''}) : super.pure(value);

  const RequiredField.dirty({String value = ''}) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == RequiredFieldError.isEmpty) return 'El campo es requerido';

    return null;
  }

  @override
  RequiredFieldError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return RequiredFieldError.isEmpty;

    return null;
  }
}