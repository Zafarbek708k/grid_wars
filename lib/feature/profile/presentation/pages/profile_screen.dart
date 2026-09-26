import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/enums/language_enum.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/widgets/buttons/animated_button.dart';
import 'package:grid_wars/feature/navigation/presentation/blocs/navigator_cubit.dart';
import 'package:grid_wars/feature/profile/presentation/widgets/daily_challenge_summary_card.dart';
import 'package:grid_wars/feature/profile/presentation/widgets/game_history_card.dart';
import 'package:grid_wars/feature/profile/presentation/widgets/language_card.dart' show LanguageCard;
import 'package:grid_wars/feature/profile/presentation/widgets/profile_card.dart';
import 'package:grid_wars/feature/profile/presentation/widgets/profile_header.dart';
import 'package:grid_wars/feature/settings/presentation/blocs/app_setting_bloc/app_setting_bloc.dart';
import 'package:grid_wars/feature/settings/presentation/widgets/app_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: LocaleKeys.profileScreen.tr(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const ProfileHeader(),
              // Re-read on every bottom-nav change so returning to this tab
              // after playing a game shows fresh stats.
              // Not const: BlocBuilder's rebuilds must produce a genuinely
              // new Column each time, otherwise Flutter sees the identical
              // const instance and skips rebuilding these cards entirely —
              // which is exactly why stats used to look frozen/stale.
              BlocBuilder<BottomNavigationBarCubit, BottomNavigationBarState>(
                builder: (context, _) => Column(
                  children: [
                    DailyChallengeSummaryCard(),
                    GameHistoryCard(),
                  ],
                ),
              ),
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
                              WidgetSpan(child: SizedBox(width: 4)),
                              TextSpan(text: LocaleKeys.language.tr(), style: context.textTheme.headlineMedium),
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
              ProfileCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(child: Icon(Icons.share_rounded, color: AppColors.white)),
                          const WidgetSpan(child: SizedBox(width: 6)),
                          TextSpan(text: LocaleKeys.shareApp.tr(), style: context.textTheme.headlineMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      LocaleKeys.shareDesc.tr(),
                      style: context.textTheme.bodySmall?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedButton(
                            onTap: () async {
                              final Uri uri = Uri.parse(
                                'https://play.google.com/store/apps/details?id=com.karimov.gridwars.grid_wars&pcampaignid=web_share',
                              );
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            },
                            child: Container(
                              height: 46,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0072FF).withValues(alpha: 0.45),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.shop_two_rounded, color: Colors.white, size: 22),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Google Play',
                                    style: context.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        AnimatedButton(
                          onTap: () async {
                            const String url =
                                'https://play.google.com/store/apps/details?id=com.karimov.gridwars.grid_wars&pcampaignid=web_share';
                            await Clipboard.setData(const ClipboardData(text: url));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(LocaleKeys.linkCopied.tr()),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFF0072FF),
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 46,
                            width: 48,
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white30),
                            ),
                            child: const Icon(Icons.copy_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
