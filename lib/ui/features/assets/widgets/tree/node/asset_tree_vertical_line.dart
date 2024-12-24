import 'package:flutter/material.dart';

class VerticalLine extends StatelessWidget {
  const VerticalLine({super.key, required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    if (level == 0) return const SizedBox(width: 0);
    return SizedBox(
      width: 24.0,
      height: 24.0,
      child: Center(
        child: Container(
          width: 1,
          height: 24,
          alignment: Alignment.center,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
