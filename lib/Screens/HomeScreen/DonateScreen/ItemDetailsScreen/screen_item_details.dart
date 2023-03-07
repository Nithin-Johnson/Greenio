import 'package:flutter/material.dart';

class ScreenItemDetails extends StatefulWidget {
  const ScreenItemDetails({super.key, required this.title});
  final String title;
  @override
  State<ScreenItemDetails> createState() => _ScreenItemDetailsState();
}

class _ScreenItemDetailsState extends State<ScreenItemDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      )
    );
  }
}
