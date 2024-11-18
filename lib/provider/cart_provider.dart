import 'package:eilly/database/database.dart';
import 'package:eilly/database/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartCountProvider = FutureProvider<int>((ref) async {
  final DatabaseHelper db = DatabaseHelper();
  db.initDb();

  final result = await db.getCartCount(1);
  return result;
});

class CartNotifier extends StateNotifier<List<CartModel>> {
  CartNotifier() : super([]);

  final DatabaseHelper db = DatabaseHelper();

  void addCart(int userId, int productId) async {
    db.initDb();
    await db.insertCart(userId, productId);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartModel>>(
  (ref) => CartNotifier(),
);
