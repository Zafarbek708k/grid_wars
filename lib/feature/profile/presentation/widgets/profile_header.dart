import 'package:flutter/material.dart';
import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/feature/profile/presentation/widgets/profile_card.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, this.imageUrl = ''});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ProfileCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: Color.fromRGBO(39, 77, 99, 1),
            backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
            child: imageUrl.isEmpty ? const Icon(Icons.gps_not_fixed_sharp, size: 40, color: AppColors.black) : null,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Game Player', style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  text: "Game player id:",
                  style: context.textTheme.bodySmall?.copyWith(color: AppColors.grey),
                  children: [
                    TextSpan(
                      text: " Hec4ss",
                      style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
