import 'package:eilly/provider/question_provider.dart';
import 'package:eilly/provider/survey_provider.dart';
import 'package:eilly/screen/main_tab_screen.dart';
import 'package:eilly/screen/survey_result.dart';
import 'package:eilly/screen/survey_type_ox.dart';
import 'package:eilly/screen/survey_type_text.dart';
import 'package:eilly/widget/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SurveyTypeSelectScreen extends ConsumerWidget {
  const SurveyTypeSelectScreen({
    super.key,
    required this.questionId,
  });

  final int questionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int nextQuestionPage = questionId + 1;
    final questions = ref.watch(questionListProvider);
    final question = ref.watch(questionDetailProvider(questionId));
    final questionCount = ref.watch(questionCountProvider);

    int isEnd = 0;
    int count = 0;
    int progress = 0;
    int nextType = 10;
    String title = '';
    List<int> answerIds = [];

    if (question.value != null) {
      title = question.value!.first.title.toString();
      isEnd = question.value!.first.isEnd;
    }

    if (questionCount.value != null) {
      count = questionCount.value!;
      progress = ((questionId / count) * 100).floor();
    }

    Future<String> getStorageDetail(String id) async {
      final result = await getStorage(id);
      return result;
    }

    void onNextTap() async {
      saveStorage(questionId.toString(), answerIds.toSet().join(','));

      if (isEnd == 0) {
        final nextQuestion =
            ref.watch(questionDetailProvider(nextQuestionPage));

        if (nextQuestion.value != null) {
          nextType = int.parse(nextQuestion.value!.first.type);
        }

        if (nextType == 20) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  SurveyTypeSelectScreen(questionId: nextQuestionPage),
            ),
          );
        } else if (nextType == 10) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  SurveyTypeTextScreen(questionId: nextQuestionPage),
            ),
          );
        } else if (nextType == 30) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  SurveyTypeOXScreen(questionId: nextQuestionPage),
            ),
          );
        }
      } else {
        int productId = 1;
        List<Map<String, dynamic>> results = [];

        if (questions.value != null) {
          for (var q in questions.value!) {
            // 10(text), 20(select), 30(o/x)
            results.add({
              'questionId': q.id.toString(),
              'questionType': q.type,
              'answerId': q.type == '20'
                  ? await getStorageDetail(q.id.toString())
                  : null,
              'description':
                  q.type != '20' ? await getStorageDetail(q.id.toString()) : '',
            });
          }

          final surveyId = await getStorageDetail('surveyId');
          productId = await ref
              .read(saveSurveyResultProvider.notifier)
              .saveSurveyResult(int.parse(surveyId), results);

          removeStorage('survey');
          removeStorage('surveyId');
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SurveyResultScreen(productId: productId),
          ),
        );
      }
    }

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
                  percent: progress.toDouble() / 100,
                  progressColor: const Color(0xffff5c35),
                  trailing: Text(
                    '$progress%',
                    style: const TextStyle(
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
                    'Q. $title',
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
                for (var data in question.value!)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                          builder:
                              (BuildContext context, StateSetter setState) {
                            bool isChecked = answerIds.contains(data.answerId!);
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
                  onPressed: onNextTap,
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
