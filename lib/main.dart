import 'package:flutter/material.dart';
import 'package:flutter_app/api/like_kanban_api_client.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/login/login.dart';
import 'package:flutter_app/kanban/kanban.dart';
import 'package:flutter_app/splash/splash.dart';
import 'package:flutter_app/authorization/authorization.dart';
import 'package:http/http.dart' as http;

void main() {
  final LikeKanbanApiClient likeKanbanApiClient = LikeKanbanApiClient(
    httpClient: http.Client(),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthorizationBloc>(
          create: (BuildContext context) => AuthorizationBloc(),
        ),
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(
            likeKanbanApiClient: likeKanbanApiClient,
          ),
        ),
        BlocProvider<KanbanBloc>(
          create: (BuildContext context) => KanbanBloc(
            likeKanbanApiClient: likeKanbanApiClient,
          ),
        ),
      ],
      child: App(),
    ),
  );
}

/// Виджет приложения.
///
/// При инициализации виджета вызывается событие AuthorizationStatusRequested.
///
/// Состояние виджета управляется BLoC-ом AuthorizationBloc:
///   - в состоянии AuthorizationLoad показывается SplashScreen;
///   - в состоянии AuthorizationDone показывается KanbanScreen;
///   - в состоянии AuthorizationFail показывается LoginScreen;
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    BlocProvider.of<AuthorizationBloc>(context)
        .add(AuthorizationStatusRequested());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('ru', ''),
      ],
      title: 'NK-Test',
      home: BlocBuilder<AuthorizationBloc, AuthorizationState>(
        buildWhen: (prev, curr) => prev != curr,
        builder: (context, state) {
          if (state is AuthorizationFail) return LoginScreen();
          if (state is AuthorizationDone) return KanbanScreen();
          return SplashScreen();
        },
      ),
    );
  }
}
