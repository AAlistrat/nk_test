import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';

part 'authorization_event.dart';
part 'authorization_state.dart';

/// BLoC проверки авторизации.
///
/// События:
/// AuthorizationStatusRequested - запрос статуса авторизации пользователя.
///    Статус проверяется по значению токена в SharedPreferences.
///
///   Возвращает состояния:
///   AuthorizationLoad - событие в процессе выполнения;
///   AuthorizationDone - пользователь авторизован;
///   AuthorizationFail - пользователь не авторизован.
///
/// AuthorizationLogOutRequested - запрос сброса статуса авторизации.
///    Статус сбрасывается путем замены значения токена в SharedPreferences на
///    пустую строку.
///
///   Возвращает состояния:
///   AuthorizationLoad - событие в процессе выполнения;
///   AuthorizationFail - пользователь не авторизован (статус сброшен).
class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  AuthorizationBloc() : super(AuthorizationLoad());

  @override
  Stream<AuthorizationState> mapEventToState(AuthorizationEvent event) async* {
    if (event is AuthorizationStatusRequested) {
      yield AuthorizationLoad();
      final String token = await SharedPreferences.getInstance().then((prefs) {
        return prefs.getString('token') ?? '';
      });
      if (token != '') {
        yield AuthorizationDone();
      } else {
        yield AuthorizationFail();
      }
    }
    if (event is AuthorizationLogOutRequested) {
      yield AuthorizationLoad();
      await SharedPreferences.getInstance().then((prefs) {
        prefs.setString('token', '');
      });
      yield AuthorizationFail();
    }
  }
}
