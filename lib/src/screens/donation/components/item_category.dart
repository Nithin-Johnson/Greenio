import 'package:flutter/material.dart';

class ItemCategory {
  ItemCategory({
    required this.iconImage,
    required this.label,
  });
  final String label;
  final String iconImage;

  static card({
    required ItemCategory itemCategory,
  }) {
    return Ink(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[700]!),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 18, 2, 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(AssetImage(itemCategory.iconImage), color: Colors.white, size: 35),
            Text(
              itemCategory.label,
              style: const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ],
        ),
      ),
    );
  }
}
