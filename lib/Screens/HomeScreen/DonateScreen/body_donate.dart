import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:greenio/Navigation/navigation_bar.dart';
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
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton2<Widget>(
                  hint: const Text(
                    'ADD ITEMS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  items: _items,
                  onChanged: (value) {
                    setState(() {});
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    overlayColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.red),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                    ),
                  ),
                  dropdownStyleData: const DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.green)),
                child: const ListTile(
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  title: Text(
                    'CHECK STATUS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Icon(Icons.hourglass_bottom),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Navigation(
                      index: 1,
                    );
                  }));
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.green)),
                child: const ListTile(
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  title: Text(
                    'DONATION HISTORY',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Icon(Icons.history),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
