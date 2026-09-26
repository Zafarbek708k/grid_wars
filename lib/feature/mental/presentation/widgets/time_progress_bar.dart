import 'package:flutter/material.dart';

class TimerProgressBar extends StatefulWidget {
  final int duration;
  final Color color;
  final String questionKey;
  final bool stop;

  const TimerProgressBar({
    super.key,
    required this.duration,
    required this.questionKey,
    this.color = Colors.cyan,
    this.stop = false,
  });

  @override
  State<TimerProgressBar> createState() => _TimerProgressBarState();
}

class _TimerProgressBarState extends State<TimerProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    _controller.reverse(from: 1.0);
  }

  @override
  void didUpdateWidget(covariant TimerProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.stop && !_controller.isDismissed) {
      _controller.stop();
    }

    if (oldWidget.questionKey != widget.questionKey) {
      _controller.reset();
      _controller.duration = Duration(seconds: widget.duration);
      _controller.reverse(from: 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return LinearProgressIndicator(
          value: _controller.value,
          color: widget.color,
          minHeight: 16,
          borderRadius: const BorderRadius.all(Radius.circular(2)),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
