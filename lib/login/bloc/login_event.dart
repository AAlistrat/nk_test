part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class LoginRequested extends LoginEvent {
  final String username;
  final String password;
  const LoginRequested({@required this.username, @required this.password})
      : assert(username != null),
        assert(password != null);
  @override
  List<Object> get props => [username, password];
}
