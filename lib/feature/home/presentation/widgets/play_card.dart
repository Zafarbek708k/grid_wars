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
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF142638), Color(0xFF0F1E2E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: context.themeExtension.whiteToCyan.withValues(alpha: 0.4), width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 16, offset: const Offset(0, 8)),
            BoxShadow(color: Colors.cyan.withValues(alpha: 0.25), blurRadius: 20, spreadRadius: 1),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              item.icon,
              height: 42,
              width: 42,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(AppColors.cyan, BlendMode.srcIn),
            ),
            const SizedBox(height: 10),
            Text(
              item.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5, fontSize: 14),
            ),
            const SizedBox(height: 6),
            RatingStars(rating: item.rating),
          ],
        ),
      ),
    );
  }
}
