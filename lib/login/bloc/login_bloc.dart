import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_app/api/like_kanban_api_client.dart';
import 'package:flutter_app/models/models.dart';
part 'login_event.dart';
part 'login_state.dart';

/// BLoC входа пользователя в систему.
///
/// Параметры:
/// LikeKanbanApiClient likeKanbanApiClient - клиент для работы с API.
///
/// События:
/// LoginRequested - запрос входа в ситему.
///
///   Параметры:
///   String username - имя пользователя;
///   String password - пароль.
///
///   Возвращает состояния:
///   LoginInit - при инициализации BLoC-а;
///   LoginLoad - событие в процессе выполнения;
///   LoginDone - вход выполнен;
///   LoginFail - вход не выполнен (
///     Параметры:
///     String errorMessage - сообщение об ошибке, полученное от клиента API.
///   ).

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LikeKanbanApiClient likeKanbanApiClient;
  LoginBloc({@required this.likeKanbanApiClient})
      : assert(likeKanbanApiClient != null),
        super(LoginInit());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginRequested) {
      yield LoginLoad();
      final TokenResponse tokenResponse = await likeKanbanApiClient.getToken(
        username: event.username,
        password: event.password,
      );
      if (tokenResponse.token != '') {
        await SharedPreferences.getInstance().then((prefs) {
          prefs.setString('token', tokenResponse.token);
        });
        yield LoginDone();
      } else {
        yield LoginFail(errorMessage: tokenResponse.error);
      }
    }
  }
}
