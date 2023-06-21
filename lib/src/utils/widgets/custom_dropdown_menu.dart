import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropDownMenu extends StatelessWidget {
  final ValueNotifier<String?> valueNotifier;
  final Map<String, String> items;

  const CustomDropDownMenu({super.key, required this.valueNotifier, required this.items});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            value: value,
            items: items.entries.map((item) {
              return DropdownMenuItem<String>(
                value: item.key,
                child: Text('${item.key}: ${item.value}', style: const TextStyle(color: Colors.white, fontSize: 16)),
              );
            }).toList(),
            onChanged: (value) => valueNotifier.value = value,
            hint: const Text('Select a Ward Number', style: TextStyle(color: Colors.white)),
            isExpanded: true,
            style: const TextStyle(color: Colors.white),
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(color: Colors.green[400], borderRadius: BorderRadius.circular(8)),
              elevation: 2,
              padding: const EdgeInsets.only(left: 5, right: 20),
            ),
            dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.green[300]),
                scrollbarTheme: ScrollbarThemeData(
                  thumbColor: MaterialStateProperty.all(Colors.green),
                  thumbVisibility: MaterialStateProperty.all(true),
                )),
            iconStyleData: const IconStyleData(iconEnabledColor: Colors.white),
          ),
        );
      },
    );
  }
}
