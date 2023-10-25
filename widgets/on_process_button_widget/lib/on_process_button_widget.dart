import 'package:flutter/material.dart';

class OnProcessButtonWidget extends StatefulWidget {
  const OnProcessButtonWidget({
    super.key,
    this.enable = true,
    this.animationDuration = const Duration(seconds: 1),
  });

  final bool enable;
  final Duration animationDuration;

  @override
  State<OnProcessButtonWidget> createState() => _OnProcessButtonWidgetState();
}

class _OnProcessButtonWidgetState extends State<OnProcessButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: widget.animationDuration,
      child: Container(),
    );
  }
}

enum _ButtonStatus {
  stable,
  running,
  success,
  error
}
