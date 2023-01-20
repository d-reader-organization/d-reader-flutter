import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({super.key});

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String dropdownValue = 'price';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        value: dropdownValue,
        onChanged: (value) {
          setState(() {
            dropdownValue = value ?? dropdownValue;
          });
        },
        isExpanded: false,
        icon: const Icon(Icons.arrow_downward_outlined),
        iconSize: 12,
        iconDisabledColor: Colors.white,
        iconEnabledColor: Colors.white,
        buttonHeight: 37,
        buttonPadding: const EdgeInsets.only(right: 8),
        buttonDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: ColorPalette.boxBackground400,
          ),
        ),
        selectedItemBuilder: (context) {
          return [
            const Center(
              child: Text(
                'Sort by: Price',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const Center(
              child: Text(
                'Sort by: Genre',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ];
        },
        dropdownDecoration: const BoxDecoration(
          color: ColorPalette.boxBackground400,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              6,
            ),
          ),
        ),
        items: const [
          DropdownMenuItem<String>(
            value: 'price',
            child: Text(
              'Price',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          DropdownMenuItem<String>(
            value: 'genre',
            child: Text(
              'Genre',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
