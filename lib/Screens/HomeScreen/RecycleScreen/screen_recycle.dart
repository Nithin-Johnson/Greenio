import 'package:flutter/material.dart';
import 'package:greenio/Screens/HomeScreen/RecycleScreen/body_recycle.dart';

class ScreenRecycle extends StatelessWidget {
  const ScreenRecycle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycle'),
      ),
      body: const BodyRecycle(),
    );
  }
}
