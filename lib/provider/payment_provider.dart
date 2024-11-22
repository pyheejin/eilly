import 'package:eilly/database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentListProvider =
    FutureProvider.family<List<Map<String, dynamic>>, int>((ref, userId) async {
  final DatabaseHelper db = DatabaseHelper();
  db.initDb();

  final result = await db.getPaymentList(userId);
  return result;
});
