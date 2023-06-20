import 'package:flutter/material.dart';
import 'package:greenio/src/screens/recycle_date/recycle_date_screen.dart';
import 'package:greenio/src/utils/navigation/navigation_utils.dart';
import 'package:greenio/src/utils/widgets/custom_button.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';

class RecycleScreen extends StatefulWidget {
  const RecycleScreen({super.key});

  @override
  State<RecycleScreen> createState() => _RecycleScreenState();
}

class _RecycleScreenState extends State<RecycleScreen> {
  List<String> recyclableItems = [
    "Plastic bags",
    "Bottles (Plastic or Glass)",
    "Newspaper",
    "Paper bags",
    "Toothpaste tubes",
    "Pens",
    "Steel cans",
    "Aluminum cans",
    "Iron scrap",
    "Glass waste",
    "Glass bottles",
    "Footwear",
    "Bags",
    "Styrofoam (Polystyrene)",
    "Synthetic leather (Rexin)",
    "Leather products",
    "Toothbrushes",
    "E-Waste (Electronic waste)",
    "Medicine blister packs",
    "Plastic packaging"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycle Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const EmptySpace(heightFraction: 0.05),
            const Text(
              'List of Recyclable Items',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const EmptySpace(heightFraction: 0.05),
            const Divider(thickness: 2),
            Expanded(
              child: GridView.builder(
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
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              overflow: TextOverflow.visible),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(thickness: 2),
            CustomElevatedButton(
                text: 'Check current date options',
                onPressed: () => NavigationUtils.navigateTo(context, const RecycleDateScreen())),
            const EmptySpace(heightFraction: 0.1),
          ],
        ),
      ),
    );
  }
}
