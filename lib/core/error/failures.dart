import 'package:equatable/equatable.dart';

class Failures extends Equatable {
  final int? errorCode;
  final String message;

  const Failures({
    this.message = 'Ha ocurrido un error inesperado',
    this.errorCode,
  });

  @override
  List<Object?> get props => [errorCode, message];
}

class DatabaseFailure extends Failures {
  const DatabaseFailure({
    super.message = 'Error en la base de datos',
    super.errorCode = 1001,
  });
}
