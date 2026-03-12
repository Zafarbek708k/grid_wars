import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/enums/home_screen_apps.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/widgets/buttons/animated_button.dart';
import 'package:grid_wars/feature/home/presentation/widgets/rating_stars.dart';

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
            SvgPicture.asset(
              item.icon,
              height: 36,
              width: 36,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(AppColors.cyan, BlendMode.srcIn),
            ),
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
