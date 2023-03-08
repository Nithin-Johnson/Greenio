import 'package:flutter/material.dart';
import 'package:greenio/Screens/HomeScreen/DonateScreen/ItemDetailsScreen/body_item_details.dart';

class ScreenItemDetails extends StatelessWidget {
  const ScreenItemDetails({super.key, required this.itemCategory});
  final String itemCategory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: BodyItemDetails(
        itemCategory: itemCategory,
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
