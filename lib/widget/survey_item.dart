import 'package:flutter/material.dart';

class SurveyItemWidget extends StatefulWidget {
  const SurveyItemWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  State<SurveyItemWidget> createState() => _SurveyItemWidgetState();
}

class _SurveyItemWidgetState extends State<SurveyItemWidget> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(1),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                  activeColor: const Color(0xffff5c35),
                  side: BorderSide(
                    color: Colors.grey.withOpacity(1),
                    width: 1,
                  ),
                ),
                Text(
                  widget.text,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
