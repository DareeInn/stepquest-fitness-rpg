import 'package:flutter/material.dart';

class XPProgressBar extends StatelessWidget {
  final int currentXP;
  final int xpToNextLevel;
  const XPProgressBar({required this.currentXP, required this.xpToNextLevel});

  @override
  Widget build(BuildContext context) {
    double progress = currentXP / xpToNextLevel;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('XP: $currentXP / $xpToNextLevel'),
          SizedBox(height: 4),
          LinearProgressIndicator(value: progress),
        ],
      ),
    );
  }
}
