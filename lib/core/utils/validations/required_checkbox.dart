import 'package:formz/formz.dart';

enum RequiredCheckboxError { isRequired }

class RequiredCheckbox extends FormzInput<bool, RequiredCheckboxError> {
  const RequiredCheckbox.pure({bool value = false}) : super.pure(value);

  const RequiredCheckbox.dirty({bool value = false}) : super.dirty(value);

  @override
  RequiredCheckboxError? validator(bool value) {
    if (value == false) return RequiredCheckboxError.isRequired;

    return null;
  }
}
