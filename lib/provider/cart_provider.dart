import 'package:eilly/database/database.dart';
import 'package:eilly/database/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartCountProvider = StreamProvider<int>((ref) async* {
  final DatabaseHelper db = DatabaseHelper();
  db.initDb();

  // 1초 간격으로 데이터베이스에서 장바구니 개수를 확인
  while (true) {
    final result = await db.getCartCount(1);
    yield result;
    await Future.delayed(const Duration(seconds: 1));
  }
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
