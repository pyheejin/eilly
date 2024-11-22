import 'package:eilly/provider/question_provider.dart';
import 'package:eilly/screen/main_tab_screen.dart';
import 'package:eilly/screen/survey_type_select.dart';
import 'package:eilly/screen/survey_type_text.dart';
import 'package:eilly/widget/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SurveyTypeOXScreen extends ConsumerWidget {
  const SurveyTypeOXScreen({
    super.key,
    required this.questionId,
  });

  final int questionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int nextQuestionPage = questionId + 1;
    final question = ref.watch(questionDetailProvider(questionId));
    final questionCount = ref.watch(questionCountProvider);

    int isEnd = 0;
    int count = 0;
    int progress = 0;
    int nextType = 10;
    String title = '';
    int isSelected = 0;

    if (question.value != null) {
      title = question.value!.first.title.toString();
      isEnd = question.value!.first.isEnd;
    }

    if (questionCount.value != null) {
      count = questionCount.value!;
      progress = ((questionId / count) * 100).floor();
    }

    void onNextTap() {
      saveStorage(questionId.toString(), isSelected.toString());

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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MainTabScreen(),
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
            const SizedBox(height: 120),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    isSelected = 1;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: isSelected == 1
                              ? const Color(0xffff5c35)
                              : Colors.grey.withOpacity(1)),
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
                    isSelected = -1;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: isSelected == -1
                              ? const Color(0xffff5c35)
                              : Colors.grey.withOpacity(1)),
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
