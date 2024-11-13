import 'package:eilly/database/database.dart';
import 'package:eilly/database/models.dart';
import 'package:eilly/screen/main_tab_screen.dart';
import 'package:eilly/screen/survey_type_ox.dart';
import 'package:eilly/screen/survey_type_select.dart';
import 'package:eilly/widget/storage.dart';
import 'package:flutter/material.dart';

class SurveyTypeTextScreen extends StatefulWidget {
  final int questionId;

  const SurveyTypeTextScreen({
    super.key,
    required this.questionId,
  });

  @override
  State<SurveyTypeTextScreen> createState() => _SurveyTypeTextScreenState();
}

class _SurveyTypeTextScreenState extends State<SurveyTypeTextScreen> {
  final DatabaseHelper db = DatabaseHelper();

  late Future<List<QuestionModel>> question;

  final TextEditingController _textController = TextEditingController();

  late String _text;

  @override
  void initState() {
    super.initState();

    db.initDb();
    question = db.getQuestionDetail(widget.questionId);

    _textController.addListener(() {
      setState(() {
        if (_textController.text.isEmpty) {
          _text = _textController.text;
        }
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
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

    saveStorage(widget.questionId.toString(), _textController.text);

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
                    return Column(
                      children: [
                        Center(
                          child: Text(
                            questionList[0].title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          controller: _textController,
                          onChanged: (value) {
                            setState(() {
                              _text = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: questionList[0].title,
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 161, 147, 147),
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
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
