import 'package:flutter/material.dart';
import 'text/subtitle_text_widget.dart';

class CustomListTileWidget extends StatelessWidget {
  const CustomListTileWidget(
      {super.key,
      required this.imagePath,
      required this.text,
      required this.function});
  final String imagePath, text;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      leading: Image.asset(
        imagePath,
        height: 30,
      ),
      title: SubtitleTextWidget(label: text),
      trailing: const Icon(Icons.keyboard_arrow_right_rounded),
    );
  }
}
