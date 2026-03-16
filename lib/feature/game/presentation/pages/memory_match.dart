import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/app_icons.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/widgets/buttons/animated_button.dart';
import 'package:grid_wars/feature/game/presentation/blocs/memory_match_bloc/memory_match_bloc.dart';

class MemoryMatch extends StatefulWidget {
  const MemoryMatch({super.key});

  @override
  State<MemoryMatch> createState() => _MemoryMatchState();
}

class _MemoryMatchState extends State<MemoryMatch> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white.withValues(alpha: 0.1),
        automaticallyImplyLeading: true,
        title: Text(
          'Memory match',
          style: context.textTheme.bodyLarge?.copyWith(color: context.themeExtension.whiteToCyan, fontWeight: FontWeight.w900),
        ),
        leading: AnimatedButton(
          child: Icon(Icons.arrow_back_ios, color: context.themeExtension.whiteToCyan),
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BlocBuilder<MemoryMatchBloc, MemoryMatchState>(
            builder: (context, state) {
              if (state.isWin) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: SizedBox(
                        height: 200,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.youWin.tr(),
                                style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      context.read<MemoryMatchBloc>().add(const ResetGame$MemoryMatchEvent());
                                    },
                                    child: Text(LocaleKeys.playAgain.tr()),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(LocaleKeys.backToHome.tr()),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
              }
              return GridView.builder(
                itemCount: state.memoryCards.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.76,
                ),
                itemBuilder: (context, index) => InkWell(
                  onTap: !state.memoryCards[index].isSelected && !state.blockButton
                      ? () => context.read<MemoryMatchBloc>().add(SelectCard$MemoryMatchEvent(cardIndex: index))
                      : null,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Color(0xFF2e3552),
                      border: BoxBorder.all(
                        color: !state.memoryCards[index].isSelected ? context.themeExtension.whiteToCyan : Colors.transparent,
                        width: 4,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(4),
                      child: Center(
                        child: state.memoryCards[index].isSelected
                            ? Image(image: AssetImage(state.memoryCards[index].imagePath))
                            : ColoredBox(
                                color: Color(0xFF2e3552),
                                child: SvgPicture.asset(
                                  AppIcons.brain,
                                  height: 54,
                                  width: 54,
                                  colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () {
          context.read<MemoryMatchBloc>().add(const ResetGame$MemoryMatchEvent());
        },
        child: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(16, 0, 16, context.padding.bottom + 12),
          child: SizedBox(
            height: 48,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Colors.cyanAccent.withValues(alpha: 0.5), Colors.blueAccent.withValues(alpha: 0.5)],
                ),
                boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.3), offset: const Offset(3, 3), blurRadius: 6)],
                border: Border.all(color: AppColors.white.withValues(alpha: 0.4), width: 1.2),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.refresh, color: AppColors.white),
                    const SizedBox(width: 8),
                    Text(
                      LocaleKeys.resetGame.tr(),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
