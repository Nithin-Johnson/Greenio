import 'package:flutter/material.dart';
import 'package:greenio/Screens/HomeScreen/DonateScreen/ItemDetailsScreen/screen_item_details.dart';

class ButtonItem extends StatelessWidget {
  const ButtonItem({super.key, required this.itemname});

  final String itemname;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ScreenItemDetails(title: itemname)));
      },
      child: Text(itemname),
    );
  }
}
