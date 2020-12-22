part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInit extends LoginState {}

class LoginFail extends LoginState {
  final String errorMessage;
  const LoginFail({@required this.errorMessage}) : assert(errorMessage != null);
  @override
  List<Object> get props => [errorMessage];
}

class LoginLoad extends LoginState {}

class LoginDone extends LoginState {}
