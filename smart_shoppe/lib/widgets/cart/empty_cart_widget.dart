import 'package:flutter/material.dart';
import '../text/title_text_widget.dart';
import '../text/subtitle_text_widget.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.buttonText});
  final String imagePath, title, buttonText;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: size.height * 0.35,
              width: double.infinity,
            ),
            const SizedBox(
              height: 5,
            ),
            const TitleTextWidget(
              label: "Whoops!",
              fontSize: 35,
              color: Color.fromARGB(255, 216, 35, 22),
            ),
            const SizedBox(
              height: 25,
            ),
            SubtitleTextWidget(
              label: title,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SubtitleTextWidget(
                label: subtitle,
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                backgroundColor: const Color.fromARGB(255, 216, 35, 22),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                // elevation: 10,
              ),
              onPressed: () {},
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
