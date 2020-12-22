part of 'authorization_bloc.dart';

abstract class AuthorizationEvent extends Equatable {
  const AuthorizationEvent();
  @override
  List<Object> get props => [];
}

class AuthorizationStatusRequested extends AuthorizationEvent {}

class AuthorizationLogOutRequested extends AuthorizationEvent {}