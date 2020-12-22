import 'package:meta/meta.dart';

class TokenResponse {
  final String token;
  final String error;
  TokenResponse({
    @required this.token,
    @required this.error,
  });
}
