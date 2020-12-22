import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/login/login.dart';
import 'package:flutter_app/authorization/authorization.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'cards_page.dart';

/// Виджет экрана списков карточек задач.
///   Виджет содержит:
///   - четыре вкладки, представляющие собой страницы списков задач;
///   - кнопку выхода.
///
/// Нажатие на кнопку выхода провоцирует следующие действия:
/// - событие AuthorizationLogOutRequest;
/// - возврат к LoginScreen.
class KanbanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          elevation: 4,
          color: Colors.blue,
          child: SizedBox(
            height: 48,
            child: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.assignment_outlined)),
                Tab(icon: Icon(Icons.assignment_returned_outlined)),
                Tab(icon: Icon(Icons.assignment_late_outlined)),
                Tab(icon: Icon(Icons.assignment_turned_in_outlined)),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              children: [
                CardsPage(row: '0', title: AppLocalizations.of(context).onHold),
                CardsPage(row: '1', title: AppLocalizations.of(context).inProgress),
                CardsPage(row: '2', title: AppLocalizations.of(context).needsReview),
                CardsPage(row: '3', title: AppLocalizations.of(context).approved),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: FlatButton(
                        shape: CircleBorder(),
                        padding: EdgeInsets.zero,
                        color: Colors.white,
                        child: Center(child: Icon(Icons.exit_to_app_outlined)),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                          BlocProvider.of<AuthorizationBloc>(context)
                              .add(AuthorizationLogOutRequested());
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
