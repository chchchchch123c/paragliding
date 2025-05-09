import 'package:flutter/material.dart';

class TapTooltip extends StatefulWidget {
  final Widget child;
  final String message;

  const TapTooltip({
    required this.child,
    required this.message,
    super.key,
  });

  @override
  State<TapTooltip> createState() => _TapTooltipState();
}

class _TapTooltipState extends State<TapTooltip> {
  final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        tooltipKey.currentState?.ensureTooltipVisible();
      },
      child: Tooltip(
        key: tooltipKey,
        message: widget.message,
        child: widget.child,
      ),
    );
  }
}
