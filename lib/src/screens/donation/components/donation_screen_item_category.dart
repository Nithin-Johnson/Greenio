import 'package:flutter/material.dart';

class DonationScreenItemCategory {
  DonationScreenItemCategory({
    required this.iconImage,
    required this.itemCategoryLabel,
  });
  final String itemCategoryLabel;
  final String iconImage;
}

itemCategoryCard({
  required DonationScreenItemCategory donationScreenItemCategory,
}) {
  return Ink(
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.green[700]!),
    ),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(2, 18, 2, 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageIcon(
            AssetImage(donationScreenItemCategory.iconImage),
            color: Colors.white,
            size: 35,
          ),
          Text(
            donationScreenItemCategory.itemCategoryLabel,
            style: const TextStyle(
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            softWrap: false,
          ),
        ],
      ),
    ),
  );
}
