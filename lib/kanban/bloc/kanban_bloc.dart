import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_app/api/like_kanban_api_client.dart';
import 'package:flutter_app/models/models.dart';
part 'kanban_event.dart';
part 'kanban_state.dart';

/// BLoC загрузки списков карточек задач.
///
/// Параметры:
/// LikeKanbanApiClient likeKanbanApiClient - клиент для работы с API.
///
/// События:
/// KanbanCardsRequested - запрос списка карточек.
///    Запрос осуществляется с применением токена, полученного в результате
///    запроса на обновление токена хранящегося в SharedPreferences.
///
///   Параметры:
///   String row - название строки, определяющее список карточек задач.
///
///   Возвращает состояния:
///   KanbanCardsLoad - событие в процессе выполнения;
///   KanbanCardsLoadDone - список карт успешно загружен (
///     Параметры:
///     List<Cards> cards - список карточек задач, полученный от клиена API.
///   );
///   KanbanCardsLoadFail - список карт не загружен (
///     Параметры:
///     String errorMessage - сообщение об ошибке, полученное от клиента API.
///   );
///   KanbanAuthorizationFail - пользователь не авторизован.
class KanbanBloc extends Bloc<KanbanEvent, KanbanState> {
  final LikeKanbanApiClient likeKanbanApiClient;
  KanbanBloc({@required this.likeKanbanApiClient})
      : assert(likeKanbanApiClient != null),
        super(KanbanCardsLoad());

  @override
  Stream<KanbanState> mapEventToState(KanbanEvent event) async* {
    if (event is KanbanCardsRequested) {
      yield KanbanCardsLoad();
      final String prevToken = await SharedPreferences.getInstance().then((prefs) {
        return prefs.getString('token');
      });
      final TokenResponse tokenResp = await likeKanbanApiClient.refreshToken(
        token: prevToken,
      );
      if (tokenResp.token != '') {
        await SharedPreferences.getInstance().then((prefs) {
          prefs.setString('token', tokenResp.token);
        });
        final CardsResponse cardsResp = await likeKanbanApiClient.getCards(
          token: tokenResp.token,
          row: event.row,
        );
        if (cardsResp.cards!=null) {
          yield KanbanCardsLoadDone(cards: cardsResp.cards);
        } else {
          if (cardsResp.error == '1') {
            yield KanbanAuthorizationFail();
          } else {
            yield KanbanCardsLoadFail(errorMessage: cardsResp.error);
          }
        }
      } else if (tokenResp.error == '1') {
        await SharedPreferences.getInstance().then((prefs) {
          prefs.setString('token', '');
        });
        yield KanbanAuthorizationFail();
      } else {
        yield KanbanCardsLoadFail(errorMessage: tokenResp.error);
      }
    }
  }
}
