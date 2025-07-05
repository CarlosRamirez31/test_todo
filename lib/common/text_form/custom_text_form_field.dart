import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String? hintText;
  final String? errorText;
  final void Function(String)? onChanged;
  final String? initialValue;
  final void Function()? onTap;
  final int? maxLength;
  final String? counterText;
  final bool enableAutoExpand;
  final int defaultLines;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.onChanged,
    this.errorText,
    this.initialValue,
    this.onTap,
    this.maxLength,
    this.counterText,
    this.enableAutoExpand = false,
    this.defaultLines = 1,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant CustomTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      textEditingController.text = widget.initialValue ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.transparent),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: TextFormField(
            controller: textEditingController,
            onChanged: widget.onChanged,
            maxLength: widget.maxLength,
            maxLines: widget.enableAutoExpand ? null : widget.defaultLines,
            minLines: widget.defaultLines,
            keyboardType: widget.enableAutoExpand ? TextInputType.multiline : TextInputType.text,
            decoration: InputDecoration(
              counterText: widget.counterText,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              hintText: widget.hintText,
              enabledBorder: border,
              focusedBorder: border,
              errorBorder: border.copyWith(
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: border,
              isDense: true,
              filled: true,
              border: InputBorder.none,
              errorText: widget.errorText,
            ),
          ),
        ),
      ],
    );
  }
}
