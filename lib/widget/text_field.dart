import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.text,
    required this.hintText,
  });

  final String text, hintText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 161, 147, 147),
                  width: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
