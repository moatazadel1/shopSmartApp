import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'title_text.dart';

class TextEffectWidget extends StatelessWidget {
  const TextEffectWidget(
      {super.key, this.fontSize = 30, this.label = 'SmartShoppe'});
  final double fontSize;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 16),
      baseColor: Colors.purple,
      highlightColor: Colors.red,
      child: TitleTextWidget(
        label: label,
        fontSize: fontSize,
      ),
    );
  }
}
