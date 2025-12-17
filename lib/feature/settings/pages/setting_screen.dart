import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/constants/app_images.dart';
import 'package:grid_wars/core/enums/theme_enum.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/feature/settings/blocs/app_setting_bloc/app_setting_bloc.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<AppSettingBloc, AppSettingState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: AppColors.cyan, width: 1)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Theme: ", style: context.textTheme.bodyLarge?.copyWith(color: AppColors.cyan)),
                          CupertinoSwitch(
                            value: state.selectedTheme == ThemeMode.light,
                            onChanged: (v) {
                              if (v) {
                                context.read<AppSettingBloc>().add(ChangeThemeEvent(ThemeEnum.light));
                              } else {
                                context.read<AppSettingBloc>().add(ChangeThemeEvent(ThemeEnum.dark));
                              }
                            },
                            activeThumbImage: AssetImage(AppImages.light),
                            inactiveThumbImage: AssetImage(AppImages.dark),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
