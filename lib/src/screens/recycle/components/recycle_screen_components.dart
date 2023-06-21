import 'package:flutter/material.dart';

class RecycleScreenComponents {
  static List<String> recyclableItems = [
    "Plastic Bags",
    "Bottles (Plastic or Glass)",
    "Newspaper",
    "Paper Bags",
    "Tooth Paste Tubes",
    "Pens",
    "Steel Cans",
    "Aluminum Cans",
    "Iron Scrap",
    "Glass Waste",
    "Glass Bottles",
    "Footwear",
    "Bags",
    "Styrofoam (Polystyrene)",
    "Synthetic Leather (Rexin)",
    "Leather Products",
    "Tooth Brushes",
    "E-Waste (Electronic waste)",
    "Medicine Blister Packs",
    "Plastic Packaging"
  ];

  static Text heading() {
    return const Text('List of Recyclable Items', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
  }

  static GridView recyclableItemsGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      shrinkWrap: true,
      itemCount: recyclableItems.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.green[400],
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Center(
              child: Text(
                recyclableItems[index],
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white, overflow: TextOverflow.visible),
              ),
            ),
          ),
        );
      },
    );
  }
}
