import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class GameControls extends StatelessWidget {
  final VoidCallback onLeftDown;
  final VoidCallback onLeftUp;
  final VoidCallback onRightDown;
  final VoidCallback onRightUp;
  final VoidCallback onJump;

  const GameControls({
    super.key,
    required this.onLeftDown,
    required this.onLeftUp,
    required this.onRightDown,
    required this.onRightUp,
    required this.onJump,
  });

  void _triggerHaptic() {
    try {
      if (Platform.isIOS) {
        HapticFeedback.lightImpact();
      } else {
        Vibration.vibrate(duration: 30, amplitude: 60);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF091420),
        border: const Border(
          top: BorderSide(color: Color(0xFF1E3A5F), width: 2.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Directional D-Pad (Left & Right hold-to-move)
            Row(
              children: [
                _HoldButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  label: 'LEFT',
                  color: Colors.cyanAccent,
                  onDown: () {
                    _triggerHaptic();
                    onLeftDown();
                  },
                  onUp: onLeftUp,
                ),
                const SizedBox(width: 16),
                _HoldButton(
                  icon: Icons.arrow_forward_ios_rounded,
                  label: 'RIGHT',
                  color: Colors.cyanAccent,
                  onDown: () {
                    _triggerHaptic();
                    onRightDown();
                  },
                  onUp: onRightUp,
                ),
              ],
            ),

            // Action Button (JUMP)
            _TapButton(
              icon: Icons.arrow_upward_rounded,
              label: 'JUMP (A)',
              color: Colors.redAccent,
              onTap: () {
                _triggerHaptic();
                onJump();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HoldButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onDown;
  final VoidCallback onUp;

  const _HoldButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onDown,
    required this.onUp,
  });

  @override
  State<_HoldButton> createState() => _HoldButtonState();
}

class _HoldButtonState extends State<_HoldButton> {
  bool _isPressed = false;

  void _handlePressStart() {
    setState(() => _isPressed = true);
    widget.onDown();
  }

  void _handlePressEnd() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      widget.onUp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _handlePressStart(),
      onTapUp: (_) => _handlePressEnd(),
      onTapCancel: _handlePressEnd,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        width: 68,
        height: 52,
        decoration: BoxDecoration(
          color: _isPressed ? widget.color.withValues(alpha: 0.3) : const Color(0xFF142436),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _isPressed ? widget.color : widget.color.withValues(alpha: 0.4),
            width: 2.0,
          ),
          boxShadow: [
            if (_isPressed)
              BoxShadow(
                color: widget.color.withValues(alpha: 0.5),
                blurRadius: 12,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Icon(
          widget.icon,
          color: _isPressed ? Colors.white : widget.color,
          size: 28,
        ),
      ),
    );
  }
}

class _TapButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _TapButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_TapButton> createState() => _TapButtonState();
}

class _TapButtonState extends State<_TapButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        widget.onTap();
      },
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        width: 100,
        height: 52,
        decoration: BoxDecoration(
          color: _isPressed ? widget.color.withValues(alpha: 0.35) : const Color(0xFF2E1318),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isPressed ? widget.color : widget.color.withValues(alpha: 0.5),
            width: 2.2,
          ),
          boxShadow: [
            if (_isPressed)
              BoxShadow(
                color: widget.color.withValues(alpha: 0.6),
                blurRadius: 14,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: _isPressed ? Colors.white : widget.color,
              size: 26,
            ),
            const SizedBox(width: 4),
            Text(
              'JUMP',
              style: TextStyle(
                color: _isPressed ? Colors.white : widget.color,
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
