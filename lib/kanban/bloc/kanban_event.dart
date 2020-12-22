part of 'kanban_bloc.dart';

abstract class KanbanEvent extends Equatable {
  const KanbanEvent();
  @override
  List<Object> get props => [];
}

class KanbanCardsRequested extends KanbanEvent {
  final String row;
  const KanbanCardsRequested({@required this.row}) : assert(row != null);
  @override
  List<Object> get props => [row];
}
