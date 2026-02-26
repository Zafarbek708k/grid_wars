import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/feature/game/presentation/widgets/animated_button.dart';
import 'package:grid_wars/feature/navigation/presentation/blocs/navigator_cubit.dart';
import 'package:grid_wars/feature/navigation/presentation/presentation/home_tab_controller_provider.dart';
import 'package:grid_wars/feature/navigation/presentation/presentation/nav_bar_item.dart';
import 'package:grid_wars/feature/navigation/presentation/presentation/navigator.dart';
import 'package:vibration/vibration.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> with TickerProviderStateMixin {
  late final TabController _controller;
  late final ValueNotifier<bool> _canPop;
  late final ValueNotifier<int> _currentIndex;

  final Map<NavBarEnum, GlobalKey<NavigatorState>> _navigatorKeys = {
    NavBarEnum.home: GlobalKey<NavigatorState>(),
    NavBarEnum.games: GlobalKey<NavigatorState>(),
    NavBarEnum.profile: GlobalKey<NavigatorState>(),
  };

  @override
  void initState() {
    _canPop = ValueNotifier(false);
    _currentIndex = ValueNotifier(0);
    _controller = TabController(length: 3, vsync: this, animationDuration: Duration.zero);
    _controller.addListener(onTabChange);
    super.initState();
  }

  void onTabChange() async {
    final index = _controller.index;
    _currentIndex.value = index;
    _canPop.value = index == 0;
    return;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BottomNavigationBarCubit, BottomNavigationBarState>(
      listenWhen: (o, n) => o.index != n.index && n.index != -1,
      listener: (context, state) {
        _controller.animateTo(state.index);
        context.read<BottomNavigationBarCubit>().changeIndex(-1);
      },
      child: HomeTabControllerProvider(
        controller: _controller,
        child: ValueListenableBuilder(
          valueListenable: _canPop,
          builder: (context, canPop, child) {
            return PopScope(
              canPop: canPop,
              onPopInvokedWithResult: (bool canPop, result) async {
                final currentState = _navigatorKeys[NavBarEnum.values[_currentIndex.value]]!.currentState;
                final isFirstRouteInCurrentTab = !await currentState!.maybePop();
                if (isFirstRouteInCurrentTab && !canPop && context.mounted) {
                  context.read<BottomNavigationBarCubit>().changeIndex(0);
                }
              },
              child: child ?? const SizedBox.shrink(),
            );
          },
          child: Scaffold(
            extendBody: true,
            resizeToAvoidBottomInset: true,
            body: TabBarView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildPageNavigator(NavBarEnum.home),
                _buildPageNavigator(NavBarEnum.games),
                _buildPageNavigator(NavBarEnum.profile),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Container(
              height: 62,
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(12, 43, 62, 1),
                // color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.themeExtension.whiteToCyan, width: 1.2),
              ),
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: _currentIndex,
                  builder: (context, page, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: List.generate(NavBarEnum.values.length, (index) {
                            return Expanded(
                              child: AnimatedButton(
                                onTap: () {
                                  if (Platform.isIOS) {
                                    HapticFeedback.lightImpact();
                                  } else {
                                    Vibration.vibrate(duration: 50, amplitude: 1, sharpness: 2);
                                  }
                                  context.read<BottomNavigationBarCubit>().changeIndex(index);
                                },
                                child: NavItemWidget(
                                  value: index,
                                  groupValue: page,
                                  icon: NavBarEnum.values[index].icon,
                                  title: _title(context, NavBarEnum.values[index]),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _title(BuildContext context, NavBarEnum item) {
    switch (item) {
      case NavBarEnum.home:
        return "Home";
      case NavBarEnum.games:
        return "Games";
      case NavBarEnum.profile:
        return "Profile";
    }
  }

  Widget _buildPageNavigator(NavBarEnum tabItem) {
    return TabNavigator(navigatorKey: _navigatorKeys[tabItem]!, tabItem: tabItem);
  }
}
