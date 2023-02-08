import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);
}

class UnableToInitializeFailure extends Failure {
  const UnableToInitializeFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class UnableToListen extends Failure {
  const UnableToListen(String message) : super(message);

  @override
  List<Object?> get props => [message];
}