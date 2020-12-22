part of 'authorization_bloc.dart';

abstract class AuthorizationState extends Equatable {
  const AuthorizationState();
  @override
  List<Object> get props => [];
}

class AuthorizationFail extends AuthorizationState {}

class AuthorizationLoad extends AuthorizationState {}

class AuthorizationDone extends AuthorizationState {}