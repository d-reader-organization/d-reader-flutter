import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? defaultValue, labelText;
  final bool isReadOnly, obscureText;
  final Widget? suffix;
  final Function()? onTap;
  final Function(String value)? onChange, onFieldSubmitted;
  final String? Function(String? value)? onValidate;
  final AutovalidateMode? autovalidateMode;
  final TextEditingController? controller;
  final Iterable<String>? autoFillHints;

  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText = 'Name',
    this.defaultValue,
    this.isReadOnly = false,
    this.obscureText = false,
    this.suffix,
    this.onTap,
    this.onChange,
    this.onValidate,
    this.autovalidateMode,
    this.controller,
    this.onFieldSubmitted,
    this.autoFillHints,
  });

  OutlineInputBorder _outlineInputBorder({
    required Color color,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
        TextFormField(
          autovalidateMode: autovalidateMode,
          controller: controller,
          onTap: onTap,
          obscureText: obscureText,
          autofillHints: autoFillHints,
          initialValue: defaultValue,
          readOnly: isReadOnly,
          cursorColor: ColorPalette.dReaderYellow100,
          validator: onValidate,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onChanged: (value) {
            if (onChange != null) {
              onChange!(value);
            }
          },
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            hintText: hintText,
            constraints: const BoxConstraints(
              maxHeight: 70,
              minHeight: 70,
            ),
            isDense: true,
            fillColor: ColorPalette.greyscale500,
            filled: true,
            contentPadding: const EdgeInsets.all(12),
            hintStyle: const TextStyle(
              color: ColorPalette.greyscale200,
              fontSize: 16,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: suffix,
            ),
            suffixIconConstraints:
                const BoxConstraints(minWidth: 24, minHeight: 24),
            border: _outlineInputBorder(
              color: ColorPalette.greyscale300,
            ),
            enabledBorder: _outlineInputBorder(
              color: ColorPalette.greyscale300,
            ),
            focusedErrorBorder: _outlineInputBorder(
              color: ColorPalette.dReaderRed,
            ),
            errorBorder: _outlineInputBorder(
              color: ColorPalette.dReaderRed,
            ),
            errorMaxLines: 1,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ColorPalette.greyscale300,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
