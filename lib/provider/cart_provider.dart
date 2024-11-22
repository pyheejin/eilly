import 'package:eilly/database/database.dart';
import 'package:eilly/database/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartCountProvider = StreamProvider<int>((ref) async* {
  final DatabaseHelper db = DatabaseHelper();
  db.initDb();

  // 1초 간격으로 데이터베이스에서 장바구니 개수를 확인
  while (true) {
    final result = await db.getCartCount(1);
    if (result > 0) {
      yield result;
      await Future.delayed(const Duration(seconds: 1));
    }
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

// 장바구니 수량 증감
class CartProductCountNotifier extends StateNotifier<int> {
  CartProductCountNotifier(this.ref) : super(0);

  final Ref ref;
  final DatabaseHelper db = DatabaseHelper();

  void increment(int userId, int productId) async {
    db.initDb();
    await db.increaseCartItem(userId, productId);
  }

  void decrement(int userId, int productId) async {
    db.initDb();
    await db.decreaseCartItem(userId, productId);
  }

  void delete(int userId, int productId) async {
    db.initDb();
    await db.deleteCart(userId, productId);
  }

  void deleteAll(int userId) async {
    db.initDb();
    await db.deleteCartAll(userId);
  }
}

final cartProductCountProvider =
    StateNotifierProvider<CartProductCountNotifier, int>(
  (ref) => CartProductCountNotifier(ref),
);

final cartProductProvider =
    StreamProvider.family<List<CartModel>, int>((ref, userId) async* {
  final DatabaseHelper db = DatabaseHelper();
  db.initDb();

  // 1초 간격으로 데이터베이스에서 장바구니 개수를 확인
  while (true) {
    final count = await db.getCartCount(1);
    if (count > 0) {
      final result = await db.getCarts(userId);
      yield result;
      await Future.delayed(const Duration(seconds: 1));
    }
  }
});
