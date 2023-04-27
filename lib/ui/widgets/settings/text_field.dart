import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsTextField extends StatelessWidget {
  final String labelText, hintText;
  final String? defaultValue;
  final bool isReadOnly;
  final Widget? suffix;
  final Function()? onTap;
  final Function(String value)? onChange;
  final String? Function(String? value)? onValidate;
  final AutovalidateMode? autovalidateMode;

  const SettingsTextField({
    super.key,
    required this.labelText,
    this.hintText = 'Wallet name',
    this.defaultValue,
    this.isReadOnly = false,
    this.suffix,
    this.onTap,
    this.onChange,
    this.onValidate,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          autovalidateMode: autovalidateMode,
          onTap: onTap,
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
          decoration: InputDecoration(
            hintText: hintText,
            constraints: const BoxConstraints(
              minHeight: 90,
              maxHeight: 90,
            ),
            fillColor: ColorPalette.boxBackground200,
            filled: true,
            hintStyle: TextStyle(
              color: isReadOnly ? ColorPalette.greyscale200 : Colors.white,
              fontSize: 16,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: suffix,
            ),
            suffixIconConstraints:
                const BoxConstraints(minWidth: 24, minHeight: 24),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ColorPalette.boxBackground400,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ColorPalette.boxBackground400,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ColorPalette.dReaderRed,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ColorPalette.dReaderRed,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ColorPalette.boxBackground400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
