import 'package:eilly/database/database.dart';
import 'package:eilly/database/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final questionListProvider = FutureProvider<List<QuestionModel>>((ref) async {
  final DatabaseHelper db = DatabaseHelper();
  db.initDb();

  final result = await db.getQuestions();
  return result;
});

final questionCountProvider = FutureProvider<int>((ref) async {
  final DatabaseHelper db = DatabaseHelper();
  db.initDb();

  final result = await db.getQuestionCount();
  return result;
});

final questionDetailProvider =
    FutureProvider.family<List<QuestionModel>, int>((ref, questionId) async {
  final DatabaseHelper db = DatabaseHelper();
  db.initDb();

  final result = await db.getQuestionDetail(questionId);
  return result;
});

final questionTypeProvider =
    FutureProvider.family<String, int>((ref, questionId) async {
  final DatabaseHelper db = DatabaseHelper();
  db.initDb();

  final result = await db.getQuestionDetail(questionId);
  return result.first.type;
});

final questionIsEndProvider =
    FutureProvider.family<int, int>((ref, questionId) async {
  final DatabaseHelper db = DatabaseHelper();
  db.initDb();

  final result = await db.getQuestionDetail(questionId);
  return result.first.isEnd;
});
