import 'package:eilly/database/database.dart';
import 'package:eilly/database/models.dart';
import 'package:eilly/widget/storage.dart';
import 'package:flutter/material.dart';

class SurveyResultScreen extends StatefulWidget {
  const SurveyResultScreen({
    super.key,
  });

  @override
  State<SurveyResultScreen> createState() => _SurveyResultScreenState();
}

class _SurveyResultScreenState extends State<SurveyResultScreen> {
  final DatabaseHelper db = DatabaseHelper();

  @override
  void initState() {
    super.initState();

    // getStorage('survey');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'eilly',
          style: TextStyle(
            color: Color(0xffff5c35),
            fontSize: 27,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          onPressed: () {},
          child: const Text('구매하기'),
        ),
      ),
    );
  }
}
