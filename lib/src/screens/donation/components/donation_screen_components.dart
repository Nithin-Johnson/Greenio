import 'package:flutter/material.dart';
import 'package:greenio/src/screens/donation/components/donation_screen_item_category.dart';
import 'package:greenio/src/utils/constants/assets_path.dart';

class DonationScreenComponents {
  List<DonationScreenItemCategory> itemCategories = [
    DonationScreenItemCategory(iconImage: clothesIconPath, itemCategoryLabel: 'Clothes'),
    DonationScreenItemCategory(iconImage: booksIconPath, itemCategoryLabel: 'Books'),
    DonationScreenItemCategory(iconImage: toysIconPath, itemCategoryLabel: 'Toys'),
    DonationScreenItemCategory(iconImage: accessoriesIconPath, itemCategoryLabel: 'Accessories'),
    DonationScreenItemCategory(iconImage: householdIconPath, itemCategoryLabel: 'Household'),
    DonationScreenItemCategory(iconImage: miscellaneousIconPath, itemCategoryLabel: 'Miscellaneous'),
  ];

  Map<String, List<String>> itemCategoriesInformation = {
    'Clothes': ["Men's clothing", "Women's clothing", "Children's clothing", "Winter clothing", "Summer clothing"],
    'Books': ["Fiction", "Non-fiction", "Children's books", "Textbooks", "Reference books"],
    'Toys': ["Stuffed animals", "Board games", "Action figures", "Arts and crafts", "Outdoor toys"],
    'Accessories': ["Shoes", "Hats", "Scarves", "Gloves", "Belts", "Bags"],
    'Household': ["Blankets", "Towels", "Sheets", "Kitchenware", "Small appliances"],
    'Miscellaneous': ["Electronics", "Sports equipment", "Musical instruments", "Office supplies", "Pet supplies"],
  };

  Text donationScreenHeading() {
    return const Text(
      'Choose any category of item you wish to donate.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  SizedBox donationScreenItemCategories(
    context, {
    required Size size,
    required Function(String) moveToItemDetailsScreen,
  }) {
    return SizedBox(
      width: size.width * 0.9,
      height: size.height * 0.5,
      child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 28.0,
          children: List.generate(itemCategories.length, (index) {
            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => moveToItemDetailsScreen(itemCategories[index].itemCategoryLabel),
              onDoubleTap: () => showItemCategoryInformation(context, itemCategories[index]),
              child: itemCategoryCard(donationScreenItemCategory: itemCategories[index]),
            );
          })),
    );
  }

  void showItemCategoryInformation(context, DonationScreenItemCategory itemCategory) {
    showDialog(
      context: context,
      builder: (context) {
        List<String> itemCategoryInformation = itemCategoriesInformation[itemCategory.itemCategoryLabel]!;
        return itemCategoryInfoDialog(context, itemCategory, itemCategoryInformation);
      },
    );
  }

  AlertDialog itemCategoryInfoDialog(
  context, DonationScreenItemCategory itemCategory, List<String> itemCategoryInformation) {
  return AlertDialog(
    icon: ImageIcon(AssetImage(itemCategory.iconImage), size: 40),
    title: Text(
      itemCategory.itemCategoryLabel,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
    ),
    content: SingleChildScrollView(
      child: Column(
        children: List.generate(itemCategoryInformation.length, (index) {
          return Card(
            elevation: 3,
            color: Colors.green[300],
            child: ListTile(
                         
              title: Text(
                itemCategoryInformation[index],
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),                
              ),
            ),
          );
        }),
      ),
    ),
    iconColor: Colors.white,
    backgroundColor: Colors.green,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green[400],
        ),
        child: const Text('Close'),
      ),
    ],
  );
}


  ListTile donationScreenHelpText() {
    return const ListTile(
      leading: Icon(Icons.info_outline_rounded),
      subtitle: Text('You can double tap on any of the category to view more information about them.'),
    );
  }
}
