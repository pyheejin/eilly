import 'package:eilly/database/database.dart';
import 'package:eilly/database/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final surveyResultProvider =
    FutureProvider.family<List<SurveyModel>, int>((ref, userId) async {
  final DatabaseHelper db = DatabaseHelper();
  db.initDb();

  final result = await db.getSurveyList(userId);
  return result;
});

class SaveSurveyResultNotifier extends StateNotifier<int> {
  SaveSurveyResultNotifier(this.ref) : super(0);

  final Ref ref;
  final DatabaseHelper db = DatabaseHelper();

  Future<int> saveSurveyResult(
      int surveyId, List<Map<String, dynamic>> results) async {
    db.initDb();
    final productId = await db.insertSurveyResult(surveyId, results);
    return productId;
  }
}

final saveSurveyResultProvider =
    StateNotifierProvider<SaveSurveyResultNotifier, int>(
  (ref) => SaveSurveyResultNotifier(ref),
);
