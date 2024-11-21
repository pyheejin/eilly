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

final productDetailProvider =
    FutureProvider.family<ProductModel, int>((ref, productId) async {
  final DatabaseHelper db = DatabaseHelper();
  db.initDb();

  final result = await db.getProductDetail(productId);
  return result;
});

final productCountProvider =
    FutureProvider.family<int, int>((ref, categoryId) async {
  final DatabaseHelper db = DatabaseHelper();
  db.initDb();

  final result = await db.getProductCount(categoryId);
  return result;
});
