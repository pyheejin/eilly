import 'package:eilly/database/database.dart';
import 'package:eilly/database/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDetailProvider =
    StreamProvider.family<UserModel, int>((ref, userId) async* {
  final DatabaseHelper db = DatabaseHelper();
  db.initDb();

  while (true) {
    final result = await db.getUserDetail(userId);
    yield result;
    await Future.delayed(const Duration(seconds: 1));
  }
});

class UserDetailNicknameNotifier extends StateNotifier<int> {
  UserDetailNicknameNotifier(this.ref) : super(0);

  final Ref ref;
  final DatabaseHelper db = DatabaseHelper();

  void updateUserDetailNickname(int userId, String nickname) async {
    db.initDb();
    await db.updateUserDetailNickname(userId, nickname);
  }
}

final userDetailNicknameProvider =
    StateNotifierProvider<UserDetailNicknameNotifier, int>(
  (ref) => UserDetailNicknameNotifier(ref),
);
