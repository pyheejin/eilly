import 'package:eilly/database/database.dart';
import 'package:eilly/database/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider =
    FutureProvider.family<List<ProductModel>, int>((ref, categoryId) async {
  final DatabaseHelper db = DatabaseHelper();
  db.initDb();

  final result = await db.getProducts(categoryId);
  return result;
});
