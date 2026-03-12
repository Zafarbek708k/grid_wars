import 'package:flutter/material.dart';

import 'package:grid_wars/core/constants/app_colors.dart';
import 'package:grid_wars/core/extensions/context_extension.dart';
import 'package:grid_wars/core/router/app_router.dart';
import 'package:grid_wars/core/widgets/buttons/animated_button.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 12,
                  children: [
                    Text(
                      "Select an option",
                      style: context.textTheme.headlineLarge?.copyWith(color: context.themeExtension.whiteToCyan),
                    ),

                    ShaderMaskedButton(
                      onPressed: () => Navigator.of(context).pushNamed(AppRouter.xAndO),
                      txt: "X and O",
                      txtStyle: context.textTheme.bodyLarge?.copyWith(color: context.themeExtension.whiteToCyan),
                    ),
                    ShaderMaskedButton(
                      isDisabled: true,
                      onPressed: () {},
                      // onPressed: () => Navigator.of(context).pushNamed(AppRouter.xAndO),
                      txt: "Game 15",
                      shaderGradient: AppColors.disabledGradient,
                      txtStyle: context.textTheme.bodyLarge?.copyWith(color: context.themeExtension.whiteToCyan),
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

class ShaderMaskedButton extends StatelessWidget {
  const ShaderMaskedButton({
    super.key,
    required this.onPressed,
    required this.txt,
    this.txtStyle,
    this.child,
    this.padding,
    this.isDisabled = false,
    this.shaderGradient = AppColors.cyanToPurple,
  });

  final VoidCallback onPressed;
  final String txt;
  final TextStyle? txtStyle;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final bool isDisabled;
  final LinearGradient shaderGradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => shaderGradient.createShader(rect),
      child: AnimatedButton(
        duration: !isDisabled ? Duration.zero : const Duration(milliseconds: 150),
        scaleValue: !isDisabled ? 0.0 : 0.95,
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: context.themeExtension.whiteToCyan),
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: child ?? Center(child: Text(txt, style: txtStyle ?? context.textTheme.headlineLarge)),
          ),
        ),
      ),
    );
  }
}
