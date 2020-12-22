part of 'kanban_bloc.dart';

abstract class KanbanState extends Equatable {
  const KanbanState();
  @override
  List<Object> get props => [];
}

class KanbanCardsLoadFail extends KanbanState {
  final String errorMessage;
  const KanbanCardsLoadFail({@required this.errorMessage}) : assert(errorMessage != null);
  @override
  List<Object> get props => [errorMessage];
}

class KanbanCardsLoad extends KanbanState {}

class KanbanAuthorizationFail extends KanbanState {}

class KanbanCardsLoadDone extends KanbanState {
  final List<TaskCard> cards;
  const KanbanCardsLoadDone({@required this.cards}) : assert(cards != null);
  @override
  List<Object> get props => [cards];
}
