import 'package:eilly/provider/question_provider.dart';
import 'package:eilly/screen/main_tab_screen.dart';
import 'package:eilly/screen/survey_type_ox.dart';
import 'package:eilly/screen/survey_type_select.dart';
import 'package:eilly/screen/survey_type_text.dart';
import 'package:eilly/widget/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyScreen extends ConsumerWidget {
  const SurveyScreen({
    super.key,
    required this.questionId,
  });

  final int questionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController textController = TextEditingController();

    late int nextType;
    int nextQuestionPage = questionId + 1;
    final question = ref.watch(questionDetailProvider(questionId));

    int isEnd = 0;
    String title = '';

    if (question.value != null) {
      title = question.value!.first.title.toString();
      isEnd = question.value!.first.isEnd;
    }

    final nextQuestion = ref.watch(questionDetailProvider(nextQuestionPage));
    if (nextQuestion.value != null) {
      nextType = int.parse(nextQuestion.value!.first.type);
    }

    void onNextTap() {
      saveStorage(questionId.toString(), textController.text);
      textController.clear();

      if (isEnd == 0) {
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
          vertical: 20,
          horizontal: 10,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 60,
                horizontal: 10,
              ),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: textController,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      hintText: title,
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
