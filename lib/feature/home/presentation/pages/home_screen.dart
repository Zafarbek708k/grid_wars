import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/feature/game/presentation/pages/x_and_o.dart';
import 'package:grid_wars/feature/game/presentation/widgets/animated_button.dart';
import 'package:grid_wars/feature/settings/presentation/widgets/app_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: "Home Screen",
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("Play now", style: context.textTheme.bodySmall),
            ),
            const SizedBox(height: 12),
            ...List.generate(HomeScreenApps.values.where((e) => e.isActive).length, (i) {
              final item = HomeScreenApps.values[i];
              if (!item.isActive) return SizedBox.shrink();
              return PlayCard(
                onTap: () {
                  if (item.isTicTacToe) {
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) => const XAndO()));
                  }
                },
                item: item,
              );
            }),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("Soon ", style: context.textTheme.bodySmall),
            ),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: HomeScreenApps.values.where((e) => !e.isActive).length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final item = HomeScreenApps.values.where((e) => !e.isActive).toList()[index];
                return InActiveGameCard(item: item);
              },
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}

class InActiveGameCard extends StatelessWidget {
  const InActiveGameCard({super.key, required this.item});

  final HomeScreenApps item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          colors: [Colors.white.withValues(alpha: 0.06), Colors.white.withValues(alpha: 0.02)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: context.themeExtension.whiteToCyan.withValues(alpha: 0.35), width: 1.4),
        boxShadow: [
          // Depth shadow
          BoxShadow(color: Colors.black.withValues(alpha: 0.6), blurRadius: 20, offset: const Offset(0, 10)),

          // Cyan glow (soft)
          BoxShadow(color: Colors.cyan.withValues(alpha: 0.15), blurRadius: 24),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// MAIN CONTENT
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// GAME ICON
                SvgPicture.asset(
                  item.icon,
                  height: 54,
                  width: 54,
                  colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
                ),

                const SizedBox(height: 14),

                /// GAME NAME
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: Colors.white60,
                  ),
                ),

                const SizedBox(height: 6),

                /// COMING SOON
                Text(
                  "Coming Soon",
                  style: context.textTheme.bodySmall?.copyWith(color: Colors.white38, letterSpacing: 1.2),
                ),
              ],
            ),
          ),

          /// LOCK OVERLAY
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.45),
                boxShadow: [BoxShadow(color: Colors.cyan.withValues(alpha: 0.45), blurRadius: 14)],
              ),
              child: const Icon(Icons.lock_rounded, size: 18, color: Colors.cyanAccent),
            ),
          ),
        ],
      ),
    );
  }
}

class PlayCard extends StatelessWidget {
  const PlayCard({super.key, required this.onTap, required this.item});

  final Function() onTap;

  final HomeScreenApps item;

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFF142638), Color(0xFF0F1E2E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: context.themeExtension.whiteToCyan.withValues(alpha: 0.4), width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.6), blurRadius: 20, offset: const Offset(0, 12)),
            BoxShadow(color: Colors.cyan.withValues(alpha: 0.35), blurRadius: 25, spreadRadius: 1),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(item.icon, height: 36, width: 36, fit: BoxFit.cover),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                Text(
                  item.name,
                  style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                RatingStars(rating: 3),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        ...List.generate(rating, (i) => const Icon(Icons.star, color: Colors.amber, size: 16)),
        ...List.generate(5 - rating, (i) => const Icon(Icons.star_border, color: Colors.amber, size: 16)),
      ],
    );
  }
}
