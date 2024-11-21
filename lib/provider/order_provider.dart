import 'package:eilly/database/database.dart';
import 'package:eilly/database/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderNotifier extends StateNotifier<List<OrderModel>> {
  OrderNotifier() : super([]);

  final DatabaseHelper db = DatabaseHelper();

  void addOrder(List<OrderModel> orders, PaymentModel payment) async {
    db.initDb();
    await db.insertOrder(orders, payment);
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, List<OrderModel>>(
  (ref) => OrderNotifier(),
);

final orderProductProvider =
    FutureProvider.family<List<CartModel>, int>((ref, userId) async {
  final DatabaseHelper db = DatabaseHelper();
  db.initDb();

  final result = await db.getCarts(userId);
  return result;
});
