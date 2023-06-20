import 'package:flutter/material.dart';

class EmptySpace extends StatelessWidget {
  final double heightFraction;
  final double widthFraction;

  const EmptySpace({
    super.key,
    this.heightFraction = 0,
    this.widthFraction = 0,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: screenSize.height * heightFraction,
      width: screenSize.width * widthFraction,
    );
  }
}
