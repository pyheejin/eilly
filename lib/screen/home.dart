import 'package:eilly/screen/survey.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _onSurveyTap() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SurveyScreen(questionId: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          children: [
            Image.network(
                'https://pilly.kr/images/survey/start/img-survey-start-bg-03.jpg'),
            Container(
              width: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Column(
                  children: [
                    Text(
                      '섭취관리',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '올바른 영양제 섭취를 위해',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '개인별 필요 성분과 제품을 알려드려요',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xffff5c35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.red),
            ),
          ),
          onPressed: _onSurveyTap,
          child: const Text(
            '건강설문 시작',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
