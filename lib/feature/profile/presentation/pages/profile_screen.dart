import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/enums/language_enum.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/feature/profile/presentation/widgets/language_card.dart' show LanguageCard;
import 'package:grid_wars/feature/profile/presentation/widgets/profile_card.dart';
import 'package:grid_wars/feature/profile/presentation/widgets/profile_header.dart';
import 'package:grid_wars/feature/settings/presentation/blocs/app_setting_bloc/app_setting_bloc.dart';
import 'package:grid_wars/feature/settings/presentation/widgets/app_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: "Profile Screen",
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // ProfileHeader(),
              // ProfileCard(
              //   child: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text("Best Players", style: context.textTheme.headlineMedium),
              //       Wrap(
              //         children: [
              //           ///
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // ProfileCard(
              //   child: Column(
              //     spacing: 4,
              //     mainAxisSize: MainAxisSize.min,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text("Best Scores", style: context.textTheme.headlineMedium),
              //       ...List.generate(defaultScores.length, (i) => ScoreCard(score: defaultScores[i])),
              //     ],
              //   ),
              // ),
              ProfileCard(
                child: BlocSelector<AppSettingBloc, AppSettingState, LanguageEnum>(
                  selector: (state) => state.languageEnum,
                  builder: (ctx, locale) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(child: Icon(Icons.translate, color: AppColors.white)),
                              TextSpan(text: "Languages", style: context.textTheme.headlineMedium),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(LanguageEnum.values.length, (i) {
                          final language = LanguageEnum.values[i];
                          return LanguageCard(
                            onTap: () {
                              context.setLocale(Locale(language.languageCode));
                              context.read<AppSettingBloc>().add(ChangeLanguageEvent(language));
                            },
                            language: language,
                            isSelected: language == locale,
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<ScoresEntity> defaultScores = [
  ScoresEntity(gameName: "Tic Tac Toe", score: 100),
  ScoresEntity(gameName: "Puzzle 15", score: 200),
  ScoresEntity(gameName: "Memory Match", score: 150),
];

class ScoresEntity {
  final String gameName;
  final int score;

  ScoresEntity({required this.gameName, required this.score});
}

class BestPlayerEntity {
  final String name;
  final int score;

  BestPlayerEntity({required this.name, required this.score});
}

class ScoreCard extends StatelessWidget {
  const ScoreCard({super.key, required this.score});

  final ScoresEntity score;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(score.gameName, style: context.textTheme.bodyMedium),
          Text(score.score.toString(), style: context.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
