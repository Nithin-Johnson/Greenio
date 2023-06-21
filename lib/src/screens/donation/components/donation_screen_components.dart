import 'package:flutter/material.dart';
import 'package:greenio/src/screens/donation/components/item_category.dart';
import 'package:greenio/src/utils/constants/assets_path.dart';

class DonationScreenComponents {
  static List<ItemCategory> categoriesList = [
    ItemCategory(iconImage: clothesIconPath, label: 'Clothes'),
    ItemCategory(iconImage: booksIconPath, label: 'Books'),
    ItemCategory(iconImage: toysIconPath, label: 'Toys'),
    ItemCategory(iconImage: accessoriesIconPath, label: 'Accessories'),
    ItemCategory(iconImage: householdIconPath, label: 'Household'),
    ItemCategory(iconImage: miscellaneousIconPath, label: 'Miscellaneous'),
  ];

  static Map<String, List<String>> categoriesMap = {
    'Clothes': ["Men's clothing", "Women's clothing", "Children's clothing", "Winter clothing", "Summer clothing"],
    'Books': ["Fiction", "Non-fiction", "Children's books", "Textbooks", "Reference books"],
    'Toys': ["Stuffed animals", "Board games", "Action figures", "Arts and crafts", "Outdoor toys"],
    'Accessories': ["Shoes", "Hats", "Scarves", "Gloves", "Belts", "Bags"],
    'Household': ["Blankets", "Towels", "Sheets", "Kitchenware", "Small appliances"],
    'Miscellaneous': ["Electronics", "Sports equipment", "Musical instruments", "Office supplies", "Pet supplies"],
  };

  static Widget profileNotCompleteWarning() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.warning, size: 60, color: Colors.red),
        Text(
          'Your profile is not complete! Please update your profile and try again.\nGo to More -> Profile',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  static Text heading() {
    return const Text(
      'Choose any category of item you wish to donate.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  static GridView itemCategories(context, {required Function(String) goToItemUploadScreen}) {
    return GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 28.0,
        shrinkWrap: true,
        children: List.generate(categoriesList.length, (index) {
          final ItemCategory itemCategory = categoriesList[index];
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => goToItemUploadScreen(categoriesList[index].label),
            onDoubleTap: () => showItemCategoryDetails(context, itemCategory),
            child: ItemCategory.card(itemCategory: itemCategory),
          );
        }));
  }

  static void showItemCategoryDetails(context, ItemCategory itemCategory) {
    showDialog(
      context: context,
      builder: (context) {
        List<String> categoryInfo = categoriesMap[itemCategory.label]!;
        return detailsDialog(context, itemCategory, categoryInfo);
      },
    );
  }

  static AlertDialog detailsDialog(context, ItemCategory itemCategory, List<String> categoryInfo) {
    return AlertDialog(
      icon: ImageIcon(AssetImage(itemCategory.iconImage), size: 40),
      title: Text(
        itemCategory.label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: List.generate(categoryInfo.length, (index) {
            return Card(
              elevation: 3,
              color: Colors.green[300],
              child: ListTile(
                dense: true,
                title: Text(
                  categoryInfo[index],
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.green[400]),
          child: const Text('Close'),
        ),
      ],
    );
  }

  static ListTile helpText() {
    return const ListTile(
      leading: Icon(Icons.info_outline_rounded),
      subtitle: Text('You can double tap on any of the category to view more information about them.'),
    );
  }
}
