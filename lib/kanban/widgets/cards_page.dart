import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/login/login.dart';
import '../bloc/kanban_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Виджет страницы списка задач.
///   Параметры:
///   String row - название строки, определяющее список задач;
///   String title - название списка задач.
///
/// При инициализации виджета вызывается событие KanbanCardsRequested.
///
/// Состояние виджета управляется BLoC-ом KanbanBloc:
///   - в состоянии KanbanCardsLoad на странице отображается индикатор загрузки;
///   - в состоянии KanbanCardsLoadDone на странице отображается список задач;
///   - в состоянии KanbanCardsLoadFail на странице отображается сообщение об
///     ошибке;
///   - при смене состояния на KanbanAuthorizationFail, осуществляется возврат к
///     LoginScreen.
class CardsPage extends StatefulWidget {
  final String row;
  final String title;
  const CardsPage({@required this.row, @required this.title});

  @override
  _CardsPageState createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  @override
  void initState() {
    BlocProvider.of<KanbanBloc>(context)
        .add(KanbanCardsRequested(row: widget.row));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.blue,
          toolbarHeight: 48,
          elevation: 4,
          title: Text(widget.title),
        ),
        Expanded(
          child: BlocConsumer<KanbanBloc, KanbanState>(
            listener: (context, state) {
              if (state is KanbanAuthorizationFail) {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }
            },
            builder: (context, state) {
              if (state is KanbanCardsLoadFail) {
                String messageText = state.errorMessage;
                if (state.errorMessage == '2') {
                  messageText = AppLocalizations.of(context).noInternet;
                }
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(messageText),
                  ),
                );
              }
              if (state is KanbanCardsLoadDone) {
                return ListView.builder(
                  itemCount: state.cards.length,
                  itemBuilder: (context, i) => Card(
                    child: ListTile(
                      title: Text(
                        'ID: ${state.cards[i].id}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      subtitle: Text(
                        '${state.cards[i].text}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}
