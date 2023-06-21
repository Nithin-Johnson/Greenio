import 'package:flutter/material.dart';
import 'package:greenio/src/screens/recycle/components/recycle_screen_components.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recycle Screen')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const EmptySpace(heightFraction: 0.05),
            RecycleScreenComponents.heading(),
            const EmptySpace(heightFraction: 0.05),
            const Divider(thickness: 2),
            Expanded(child: RecycleScreenComponents.recyclableItemsGridView()),
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
