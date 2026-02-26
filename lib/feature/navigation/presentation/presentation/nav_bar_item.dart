import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';

class NavItemWidget extends StatelessWidget {
  final int groupValue;
  final int value;
  final String icon;
  final String title;

  const NavItemWidget({
    required this.groupValue,
    required this.value,
    required this.icon,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = groupValue == value;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, Platform.isIOS ? 0 : 10, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(
            child: SvgPicture.asset(
              icon,
              height: isActive ? 26 : 32,
              width: isActive ? 26 : 32,
              colorFilter: ColorFilter.mode(isActive ? AppColors.cyan : AppColors.white, BlendMode.srcIn),
            ),
          ),
          if (isActive) ...{
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: context.textTheme.bodyMedium!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.cyan : AppColors.white,
              ),
            ),
          },
        ],
      ),
    );
  }
}
