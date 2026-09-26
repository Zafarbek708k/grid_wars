part of 'word_search_bloc.dart';

sealed class WordSearchEvent {
  const WordSearchEvent();
}

class NewGame$WordSearchEvent extends WordSearchEvent {
  const NewGame$WordSearchEvent();
}

class StartSelection$WordSearchEvent extends WordSearchEvent {
  final int row;
  final int col;

  const StartSelection$WordSearchEvent({required this.row, required this.col});
}

class UpdateSelection$WordSearchEvent extends WordSearchEvent {
  final int row;
  final int col;

  const UpdateSelection$WordSearchEvent({required this.row, required this.col});
}

class EndSelection$WordSearchEvent extends WordSearchEvent {
  const EndSelection$WordSearchEvent();
}
