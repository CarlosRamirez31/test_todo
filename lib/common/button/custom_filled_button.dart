import 'package:flutter/material.dart';

class CustomFilledButton extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final dynamic Function()? onPressed;

  const CustomFilledButton({
    super.key,
    required this.text,
    this.backgroundColor,
    this.foregroundColor,
    required this.padding,
    required this.borderRadius,
    this.onPressed,
    this.textStyle,
  });

  @override
  State<CustomFilledButton> createState() => _CustomFilledButtonState();
}

class _CustomFilledButtonState extends State<CustomFilledButton> {
  Set<WidgetState> stateColor = <WidgetState>{};

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: widget.onPressed,
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(widget.padding),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: widget.borderRadius),
        ),
        backgroundColor: WidgetStatePropertyAll(widget.backgroundColor),
        foregroundColor: WidgetStatePropertyAll(widget.foregroundColor),
      ),
      label: Text(widget.text, style: widget.textStyle),
    );
  }
}
