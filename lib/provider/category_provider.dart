import 'package:eilly/database/database.dart';
import 'package:eilly/database/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final DatabaseHelper db = DatabaseHelper();
  db.initDb();

  final result = await db.getCategories();
  return result;
});
