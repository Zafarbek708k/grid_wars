part of 'x_o_bloc.dart';

sealed class XOEvent extends Equatable {
  const XOEvent();
}

class TabEvent extends XOEvent {
  final int index;

  const TabEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class ResetGameEvent extends XOEvent {
  const ResetGameEvent();

  @override
  List<Object?> get props => [];
}
