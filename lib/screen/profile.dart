import 'package:eilly/provider/payment_provider.dart';
import 'package:eilly/provider/survey_provider.dart';
import 'package:eilly/provider/user_provider.dart';
import 'package:eilly/screen/store_detail.dart';
import 'package:eilly/widget/persistent_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surveys = ref.watch(surveyResultProvider(1));
    final user = ref.watch(userDetailProvider(1));
    final payments = ref.watch(paymentListProvider(1));

    String imageUrl = '';
    String nickname = '';
    late String newNickname;

    if (user.value != null) {
      imageUrl = user.value!.imageUrl.toString();
      nickname = user.value!.nickname.toString();
    }

    final TextEditingController newNicknameController = TextEditingController();

    void onUpdateNickname(int id, String nickname) {
      ref
          .read(userDetailNicknameProvider.notifier)
          .updateUserDetailNickname(id, nickname);
      newNicknameController.clear();
      Navigator.of(context).pop(true);
    }

    void onUpdateNicknameDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 35,
                  horizontal: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: newNicknameController,
                      onChanged: (value) {
                        newNickname = value;
                      },
                      decoration: const InputDecoration(
                        hintText: '변경할 닉네임을 입력해주세요',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 161, 147, 147),
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xffff5c35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                      onPressed: () {
                        onUpdateNickname(1, newNickname);
                      },
                      child: const Text(
                        '닉네임 변경',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            foregroundImage: NetworkImage(imageUrl),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '@$nickname',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: onUpdateNicknameDialog,
                            child: const Icon(
                              Icons.edit,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  delegate: PersistentTabBar(),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [
                payments.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('주문 목록 에러: $error'),
                  data: (paymentList) => ListView.builder(
                    itemCount: paymentList.length,
                    itemBuilder: (context, index) {
                      String name = paymentList[index]['name'];
                      if (paymentList[index]['count'] > 1) {
                        name =
                            '${paymentList[index]['name']} 외 ${paymentList[index]['count']}개';
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 5,
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    color: const Color(0xffF2F2F2),
                                    child: Image.network(
                                        paymentList[index]['imageUrl']),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                surveys.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('설문 목록 에러: $error'),
                  data: (surveyList) => ListView.builder(
                    itemCount: surveyList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 5,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => StoreDetailScreen(
                                    productId: surveyList[index].productId),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    color: const Color(0xffF2F2F2),
                                    child: Image.network(
                                        surveyList[index].imageUrl),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    surveyList[index].name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
