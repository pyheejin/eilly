import 'package:eilly/database/database.dart';
import 'package:eilly/database/models.dart';
import 'package:eilly/screen/main_tab_screen.dart';
import 'package:eilly/screen/survey_result.dart';
import 'package:eilly/screen/survey_type_select.dart';
import 'package:eilly/screen/survey_type_text.dart';
import 'package:eilly/widget/storage.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SurveyTypeOXScreen extends StatefulWidget {
  final int questionId;

  const SurveyTypeOXScreen({
    super.key,
    required this.questionId,
  });

  @override
  State<SurveyTypeOXScreen> createState() => _SurveyTypeOXScreenState();
}

class _SurveyTypeOXScreenState extends State<SurveyTypeOXScreen> {
  final DatabaseHelper db = DatabaseHelper();

  late Future<List<QuestionModel>> question;

  int isSelected = 0;

  @override
  void initState() {
    super.initState();

    db.initDb();
    question = db.getQuestionDetail(widget.questionId);
  }

  Future<String> _nextQuestionType(int id) async {
    final q = await db.getQuestionDetail(id);
    return q.first.type;
  }

  Future<int> _nextQuestionIsEnd(int id) async {
    final q = await db.getQuestionDetail(id);
    return q.first.isEnd;
  }

  void _onNextTap() async {
    final isEnd = await _nextQuestionIsEnd(widget.questionId);

    saveStorage(widget.questionId.toString(), isSelected.toString());

    if (isEnd == 0) {
      final nextQuestionPage = widget.questionId + 1;
      final nextType = await _nextQuestionType(nextQuestionPage);

      if (int.parse(nextType) == 20) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  SurveyTypeSelectScreen(questionId: nextQuestionPage),
            ),
          );
        }
      } else if (int.parse(nextType) == 10) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  SurveyTypeTextScreen(questionId: nextQuestionPage),
            ),
          );
        }
      } else if (int.parse(nextType) == 30) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  SurveyTypeOXScreen(questionId: nextQuestionPage),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SurveyResultScreen(),
          ),
        );

        final questionList = await db.getQuestions();
        for (var q in questionList) {
          getStorage(q.id.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'eilly',
            style: TextStyle(
              color: Color(0xffff5c35),
              fontSize: 27,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Column(
          children: [
            const Center(
              child: Text(
                '생활습관',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinearPercentIndicator(
                  width: 360,
                  lineHeight: 5,
                  percent: 0.2,
                  progressColor: const Color(0xffff5c35),
                  trailing: const Text(
                    '14%',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xffff5c35),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: question,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<QuestionModel> questionList =
                      snapshot.data as List<QuestionModel>;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'Q. ${questionList[0].title}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 120),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected = 1;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(1)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 40,
                        horizontal: 60,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.trip_origin,
                            size: 40,
                            color: Color(0xff3AA3FA),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '네',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected = -1;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(1)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 40,
                        horizontal: 60,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.close_outlined,
                            size: 40,
                            color: Color(0xffFF5050),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '아니요',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(1)),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(
                    Icons.chevron_left,
                    size: 30,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(1)),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  onPressed: _onNextTap,
                  icon: const Icon(
                    Icons.chevron_right,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
