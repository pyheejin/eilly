import 'dart:async';
import 'package:eilly/database/database.dart';
import 'package:eilly/database/models.dart';
import 'package:eilly/screen/main_tab_screen.dart';
import 'package:eilly/screen/survey_type_ox.dart';
import 'package:eilly/screen/survey_type_text.dart';
import 'package:eilly/widget/storage.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SurveyTypeSelectScreen extends StatefulWidget {
  final int questionId;

  const SurveyTypeSelectScreen({
    super.key,
    required this.questionId,
  });

  @override
  State<SurveyTypeSelectScreen> createState() => _SurveyTypeSelectScreenState();
}

class _SurveyTypeSelectScreenState extends State<SurveyTypeSelectScreen> {
  final DatabaseHelper db = DatabaseHelper();

  late Future<List<QuestionModel>> question;

  List<int> answerIds = [];

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

  Future<String> _getStorage(String id) async {
    final result = await getStorage(id);
    return result;
  }

  void _onNextTap() async {
    final isEnd = await _nextQuestionIsEnd(widget.questionId);

    saveStorage(widget.questionId.toString(), answerIds.join(','));

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
      final questionList = await db.getQuestions();
      final List<Map<String, dynamic>> results = [];
      for (var q in questionList) {
        // 10(text), 20(select), 30(o/x)
        results.add({
          'questionId': q.id.toString(),
          'questionType': q.type,
          'answerId':
              q.type == '20' ? await _getStorage(q.id.toString()) : null,
          'description':
              q.type != '20' ? await _getStorage(q.id.toString()) : '',
        });
      }
      final surveyId = await _getStorage('surveyId');
      db.insertSurveyResult(int.parse(surveyId), results);

      removeStorage('survey');
      removeStorage('surveyId');

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MainTabScreen(),
          ),
        );
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
        child: FutureBuilder(
          future: question,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<QuestionModel> questionList =
                  snapshot.data as List<QuestionModel>;
              bool isChecked = false;
              return Column(
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
                          '2%',
                          style: TextStyle(
                            fontSize: 17,
                            color: Color(0xffff5c35),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
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
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      for (var data in questionList)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          // child: SurveyItemWidget(text: data.answer.toString()),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(1),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Row(
                                    children: [
                                      Checkbox(
                                        value: isChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isChecked = value!;

                                            if (isChecked) {
                                              answerIds.add(data.answerId!);
                                            } else {
                                              answerIds.remove(data.answerId!);
                                            }

                                            print(answerIds);
                                          });
                                        },
                                        activeColor: const Color(0xffff5c35),
                                        side: BorderSide(
                                          color: Colors.grey.withOpacity(1),
                                          width: 1,
                                        ),
                                      ),
                                      Text(
                                        data.answer.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            }
          },
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
