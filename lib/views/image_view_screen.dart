import 'package:flutter/material.dart';

class ImageViewScreen extends StatelessWidget {
  const ImageViewScreen({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 50,
              top: 200,
              child: Column(
                children: [
                  Image.network(
                    imageUrl,
                  ),
                ],
              ),
            ),
            const BackButton()
          ],
        ),
      ),
    );
  }
}
