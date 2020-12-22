import 'dart:io';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LikeKanbanApiClient {
  static const String baseUrl = 'https://trello.backend.tests.nekidaem.ru/api';
  static const String apiVersion ='v1';

  final http.Client httpClient;
  LikeKanbanApiClient({@required this.httpClient}) : assert(httpClient != null);

  /// Получение токена.
  ///
  /// Параметры:
  /// String username - имя пользователя;
  /// String password - пароль.
  ///
  /// Возвращает TokenResponse с параметрами:
  /// String token - токен;
  /// String error - сообщение об ошибке с кодом ответа сервера,
  ///    либо, для локализованных сообщений, код ошибки:
  ///       '1' - неверный запрос на сервер (при коде ответа сервера 400);
  ///       '2' - отстутсвует интерет соединение.
  Future<TokenResponse> getToken({
    @required String username,
    @required String password,
  }) async {
    final requestUrl = '$baseUrl/$apiVersion/users/login/';
    try {
      final response = await this.httpClient.post(
        requestUrl,
        body: {'username': username, 'password': password},
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        return TokenResponse(token: responseJson['token'], error: '');
      } else if (response.statusCode == 400) {
        return TokenResponse(token: '', error: '1');
      } else {
        return TokenResponse(token: '', error: 'Something went wrong on getting token.\n\nResponse status code: ${response.statusCode}.');
      }
    } on SocketException {
      return TokenResponse(token: '', error: '2');
    } catch (e) {
      return TokenResponse(token: '', error: 'Something went wrong on getting token.\n\nError: $e');
    }
  }

  /// Обновление токена.
  ///
  /// Параметры:
  /// String token - токен на основе которого будет получен новый.
  ///
  /// Возвращает TokenResponse с параметрами:
  /// String token - новый токен;
  /// String error - сообщение об ошибке с кодом статуса ответа сервера,
  ///    либо, для локализованных сообщений, код ошибки:
  ///       '1' - неверный запрос на сервер (при коде ответа сервера 400);
  ///       '2' - отстутсвует интерет соединение.
  Future<TokenResponse> refreshToken({@required String token}) async {
    final requestUrl = '$baseUrl/$apiVersion/users/refresh_token/';
    try {
      final response = await this.httpClient.post(
        requestUrl, body: {'token': token},
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        return TokenResponse(token: responseJson['token'], error: '');
      } else if (response.statusCode == 400) {
        return TokenResponse(token: '', error: '1');
      } else {
        return TokenResponse(token: '', error: 'Something went wrong on refreshing token.\n\nResponse status code: ${response.statusCode}.');
      }
    } on SocketException {
      return TokenResponse(token: '', error: '2');
    } catch (e) {
      return TokenResponse(token: '', error: 'Something went wrong on refreshing token.\n\nError: $e');
    }
  }

  /// Получение списка карточек задач.
  ///
  /// Параметры:
  /// String token - токен;
  /// String row - название строки, определяющее принадлежность карточки
  ///    к определенному списку.
  ///
  /// Возвращает CardsResponse с параметрами:
  /// List<Cards> cards - список карточек для соответствующего списка;
  /// String error - сообщение об ошибке с кодом статуса ответа сервера,
  ///    либо, для локализованных сообщений, код ошибки:
  ///       '1' - неавторизованный пользователь (при коде ответа сервера 401);
  ///       '2' - отстутсвует интерет соединение.
  Future<CardsResponse> getCards({
    @required String token,
    @required String row,
  }) async {
    final requestUrl = '$baseUrl/$apiVersion/cards/';
    List<TaskCard> cards = [];
    try {
      final response = await this.httpClient.get(
        requestUrl,
        headers: {HttpHeaders.authorizationHeader: 'JWT $token'},

      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        for (var resp in responseJson) {
          if (resp['row'] == row) {
            cards.add(TaskCard(
              id: resp['id'],
              row: resp['row'],
              seqNum: resp['seq_num'],
              text: utf8.decode(resp['text'].runes.toList()),
            ));
          }
        }
        return CardsResponse(cards: cards, error: '');
      } else if (response.statusCode == 401) {
        return CardsResponse(cards: null, error: '1');
      } else {
        return CardsResponse(cards: null, error: 'Something went wrong on getting cards.\n\nResponse status code: ${response.statusCode}.');
      }
    } on SocketException {
      return CardsResponse(cards: null, error: '2');
    } catch (e) {
      return CardsResponse(cards: null, error: 'Something went wrong on getting cards.\n\nError: $e');
    }
  }
}
