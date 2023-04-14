import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_address.dart';
import 'package:flutter/material.dart';

class SettingsTextField extends StatelessWidget {
  final String labelText;
  final String? defaultValue;
  final bool isReadOnly;
  final Widget? suffix;
  final Function()? onTap;

  const SettingsTextField({
    super.key,
    required this.labelText,
    this.defaultValue,
    this.isReadOnly = false,
    this.suffix,
    this.onTap,
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
        TextField(
          onTap: onTap,
          readOnly: isReadOnly,
          cursorColor: ColorPalette.dReaderYellow100,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onChanged: (value) {},
          decoration: InputDecoration(
            hintText: defaultValue != null
                ? formatAddress(defaultValue!, 4)
                : 'Wallet name',
            constraints: const BoxConstraints(
              minHeight: 56,
              maxHeight: 56,
            ),
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
                color: Color(0xff414756),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xff414756),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xff414756),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
