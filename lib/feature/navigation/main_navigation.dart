import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibration/vibration.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/widgets/buttons/animated_button.dart';
import 'package:grid_wars/feature/navigation/presentation/blocs/navigator_cubit.dart';
import 'package:grid_wars/feature/navigation/presentation/presentation/home_tab_controller_provider.dart';
import 'package:grid_wars/feature/navigation/presentation/presentation/nav_bar_item.dart';
import 'package:grid_wars/feature/navigation/presentation/presentation/navigator.dart';

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
              height: 65,
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.16),
                          Color.fromRGBO(12, 43, 62, 1).withValues(alpha: 0.55),
                        ],
                      ),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.28), width: 1.2),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 20, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: _currentIndex,
                      builder: (context, page, child) {
                        final int count = NavBarEnum.values.length;
                        return Stack(
                          children: [
                            // Liquid glow pill that slides under the active tab.
                            AnimatedAlign(
                              duration: const Duration(milliseconds: 420),
                              curve: Curves.easeOutBack,
                              alignment: Alignment(-1 + page * (2 / (count - 1)), 0),
                              child: FractionallySizedBox(
                                widthFactor: 1 / count,
                                heightFactor: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          AppColors.cyan.withValues(alpha: 0.32),
                                          AppColors.cyan.withValues(alpha: 0.08),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(color: AppColors.cyan.withValues(alpha: 0.35), blurRadius: 18, spreadRadius: 1),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(count, (index) {
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
                                      title: NavBarEnum.values[index].title.tr(),
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
        ),
      ),
    );
  }

  Widget _buildPageNavigator(NavBarEnum tabItem) {
    return TabNavigator(navigatorKey: _navigatorKeys[tabItem]!, tabItem: tabItem);
  }
}
