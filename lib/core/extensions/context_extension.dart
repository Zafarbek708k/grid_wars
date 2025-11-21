import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grid_wars/core/enums/pop_up_status.dart';
import 'package:grid_wars/core/theme/theme_extension.dart';
import 'package:grid_wars/feature/game/presentation/widgets/animated_button.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_svg/svg.dart';

extension ContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  TextScaler get textScaler => MediaQuery.textScalerOf(this);

  double get maxScale => max(textScaler.scale(1), 1);

  EdgeInsets get padding => MediaQuery.paddingOf(this);

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  Size get screenSize => mediaQuery.size;

  double scaled(double base) => textScaler.scale(base);

  ColorScheme get appTheme => theme.colorScheme;

  Locale get locale => Localizations.localeOf(this);

  AppThemeExtension get themeExtension => theme.extension<AppThemeExtension>()!;

  Brightness get brightness => theme.brightness;

  Future<void> showPopUp({
    required PopUpStatus status,
    required String message,
    Widget? child,
    double? height,
    Duration? displayDuration,
    Duration? animationDuration,
    Duration? reverseAnimationDuration,
    DismissType? dismissType,
    TextStyle? messageStyle,
    required BuildContext context,
  }) async {
    if (status == PopUpStatus.error || status == PopUpStatus.warning) {
      if (Platform.isIOS) {
        await HapticFeedback.lightImpact();
      } else {
        await Vibration.vibrate(duration: 200, amplitude: 64);
      }
    }
    AnimationController? localAnimationController;
    showTopSnackBar(
      Overlay.of(this),
      child ??
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4).copyWith(right: 0),
            height: height,
            decoration: BoxDecoration(
              color: context.themeExtension.whiteToDark.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SvgPicture.asset(status.icon),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style:
                        messageStyle ??
                        textTheme.bodyLarge?.copyWith(
                          color: context.themeExtension.whiteToDark,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                AnimatedButton(
                  onTap: () {
                    if (localAnimationController != null) {
                      localAnimationController!.reverse();
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.cancel_outlined),
                    // child: SvgPicture.asset(
                    //   AppIcons.,
                    //   colorFilter: const ColorFilter.mode(
                    //     Color(0xffD2D5DC),
                    //     BlendMode.srcIn,
                    //   ),
                    // ),
                  ),
                ),
              ],
            ),
          ),
      displayDuration: displayDuration ?? const Duration(milliseconds: 2100),
      dismissDirection: [DismissDirection.vertical, DismissDirection.horizontal],
      dismissType: dismissType ?? DismissType.onTap,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeIn,
      onAnimationControllerInit: (p0) => localAnimationController = p0,
      animationDuration: animationDuration ?? const Duration(milliseconds: 400),
      reverseAnimationDuration: reverseAnimationDuration ?? const Duration(milliseconds: 300),
    );
  }
}
