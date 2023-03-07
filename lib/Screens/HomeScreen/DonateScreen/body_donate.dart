import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:greenio/Screens/HomeScreen/DonateScreen/ItemButton/button_items.dart';

class BodyDonate extends StatefulWidget {
  const BodyDonate({super.key});

  @override
  State<BodyDonate> createState() => _BodyDonateState();
}

class _BodyDonateState extends State<BodyDonate> {
  static const List<DropdownMenuItem<Widget>> _items = [
    DropdownMenuItem(
      value: Text('Clothes'),
      child: ButtonItem(itemname: 'Clothes'),
    ),
    DropdownMenuItem(
      value: Text('Books'),
      child: ButtonItem(itemname: 'Books'),
    ),
    DropdownMenuItem(
      value: Text('Kitchenware'),
      child: ButtonItem(itemname: 'Kitchenware'),
    ),
    DropdownMenuItem(
      value: Text('Toys and Games'),
      child: ButtonItem(itemname: 'Toys and Games'),
    ),
    DropdownMenuItem(
      value: Text('Miscellaneous'),
      child: ButtonItem(itemname: 'Miscellaneous'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton2<Widget>(
            hint: const Text('Add items'),
            items: _items,
            onChanged: (value) {
              setState((){});
            },
          ),
        ],
      ),
    );
  }
}
