part of 'navigator_cubit.dart';

class BottomNavigationBarState extends Equatable {
  final bool hideBottomNavigationBarInPortal;
  final bool hideBottomNavigationBarInServices;
  final int index;
  final String servicesWebUrl;

  const BottomNavigationBarState({
    this.hideBottomNavigationBarInPortal = false,
    this.hideBottomNavigationBarInServices = false,
    this.servicesWebUrl = '',
    this.index = 0,
  });

  BottomNavigationBarState copyWith({
    bool? hideBottomNavigationBarInPortal,
    bool? hideBottomNavigationBarInServices,
    String? servicesWebUrl,
    int? index,
  }) =>
      BottomNavigationBarState(
        hideBottomNavigationBarInPortal: hideBottomNavigationBarInPortal ?? this.hideBottomNavigationBarInPortal,
        hideBottomNavigationBarInServices: hideBottomNavigationBarInServices ?? this.hideBottomNavigationBarInServices,
        servicesWebUrl: servicesWebUrl ?? this.servicesWebUrl,
        index: index ?? this.index,
      );

  @override
  List<Object?> get props => [
        hideBottomNavigationBarInPortal,
        hideBottomNavigationBarInServices,
        servicesWebUrl,
        index,
      ];
}
