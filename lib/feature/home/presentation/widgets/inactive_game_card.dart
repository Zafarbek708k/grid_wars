import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grid_wars/core/constants/locale_keys.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';

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
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// GAME ICON
                SvgPicture.asset(
                  item.icon,
                  height: 32,
                  width: 32,
                  colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
                ),

                const SizedBox(height: 8),

                /// GAME NAME
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    fontSize: 11,
                    height: 1.15,
                    color: Colors.white60,
                  ),
                ),

                const SizedBox(height: 4),

                /// COMING SOON
                Text(
                  LocaleKeys.comingSoon.tr(),
                  style: context.textTheme.bodySmall?.copyWith(color: Colors.white38, letterSpacing: 0.8, fontSize: 9),
                ),
              ],
            ),
          ),

          /// LOCK OVERLAY
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.45),
                boxShadow: [BoxShadow(color: Colors.cyan.withValues(alpha: 0.45), blurRadius: 14)],
              ),
              child: const Icon(Icons.lock_rounded, size: 14, color: Colors.cyanAccent),
            ),
          ),
        ],
      ),
    );
  }
}
