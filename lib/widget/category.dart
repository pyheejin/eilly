import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  const Category({
    super.key,
    required this.text,
    required this.isSelected,
    required this.imageUrl,
    required this.selectedImageUrl,
  });

  final String text, imageUrl, selectedImageUrl;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromARGB(44, 255, 149, 122)
                    : const Color(0xffF2F2F2),
                borderRadius: BorderRadius.circular(23),
              ),
              child: isSelected
                  ? Image.network(selectedImageUrl)
                  : Image.network(imageUrl),
            ),
            const SizedBox(height: 5),
            Text(
              text,
              style: TextStyle(
                  color: isSelected ? const Color(0xffff5c35) : Colors.black),
            ),
          ],
        ),
        const SizedBox(width: 25),
      ],
    );
  }
}
