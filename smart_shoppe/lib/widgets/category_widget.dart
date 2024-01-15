import 'package:flutter/material.dart';
import 'package:smart_shoppe/screens/search_screen.dart';
import 'package:smart_shoppe/widgets/text/title_text_widget.dart';

class CategortWidget extends StatelessWidget {
  const CategortWidget(
      {super.key, required this.categoryImg, required this.categoryName});

  final String categoryImg;
  final String categoryName;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.pushNamed(
            context,
            SearchScreen.routeName,
            arguments: categoryName,
          );
        },
        child: Column(
          children: [
            Image.asset(
              categoryImg,
              height: 50,
              width: 50,
            ),
            const SizedBox(
              height: 5,
            ),
            TitleTextWidget(
              label: categoryName,
              fontSize: 15,
            ),
          ],
        ),
      ),
    );
  }
}
