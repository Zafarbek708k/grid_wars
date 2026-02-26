import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigator_state.dart';

class BottomNavigationBarCubit extends Cubit<BottomNavigationBarState> {
  BottomNavigationBarCubit() : super(const BottomNavigationBarState());

  showBarInPortal() => emit(state.copyWith(hideBottomNavigationBarInPortal: false));

  hideBarInPortal() => emit(state.copyWith(hideBottomNavigationBarInPortal: true));

  showBarInServices() => emit(state.copyWith(hideBottomNavigationBarInServices: false));

  hideBarInServices() => emit(state.copyWith(hideBottomNavigationBarInServices: true));

  changeIndex(int index) => emit(state.copyWith(index: index));
}
