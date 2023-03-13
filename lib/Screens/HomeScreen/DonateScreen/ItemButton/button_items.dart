import 'package:flutter/material.dart';
import 'package:greenio/Screens/HomeScreen/DonateScreen/ItemDetailsScreen/screen_item_details.dart';

class ButtonItem extends StatelessWidget {
  const ButtonItem({super.key, required this.itemname});

  final String itemname;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.71,
        child: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ScreenItemDetails(itemCategory: itemname)));
          },
          child: Text(
            itemname,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
