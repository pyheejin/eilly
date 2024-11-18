import 'package:eilly/database/database.dart';
import 'package:eilly/database/models.dart';
import 'package:eilly/screen/store_detail.dart';
import 'package:eilly/widget/persistent_tabbar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseHelper db = DatabaseHelper();

  late Future<UserModel> user;
  late Future<List<SurveyModel>> surveys;

  final int userId = 1;

  late final TextEditingController _nicknameController =
      TextEditingController();
  late String _nickname;
  late int cartLength;

  @override
  void initState() {
    super.initState();

    db.initDb();
    user = db.getUserDetail(userId);
    surveys = db.getSurveyList(userId);

    _nicknameController.addListener(() {
      setState(() {
        if (_nicknameController.text.isEmpty) {
          _nickname = _nicknameController.text;
        }
      });
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _onUpdateNickname(int id, String nickname) async {
    await db.updateUserDetailNickname(id, nickname);
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  void _onUpdateNicknameDialog() {
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
                    controller: _nicknameController,
                    onChanged: (value) {
                      setState(() {
                        _nickname = value;
                      });
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
                      _onUpdateNickname(userId, _nickname);
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
    ).then((onValue) {
      user = db.getUserDetail(userId);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                      future: user,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          UserModel userDetail = snapshot.data as UserModel;
                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                foregroundImage: NetworkImage(
                                    userDetail.imageUrl.toString()),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '@${userDetail.nickname}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: _onUpdateNicknameDialog,
                                child: const Icon(
                                  Icons.edit,
                                  size: 18,
                                ),
                              ),
                            ],
                          );
                        }
                      },
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
              ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('item $index'),
                    trailing: const Icon(Icons.arrow_forward),
                    selected: index < 1,
                    onTap: () {},
                  );
                },
              ),
              FutureBuilder(
                future: surveys,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<SurveyModel> surveyList =
                        snapshot.data as List<SurveyModel>;
                    return ListView.builder(
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
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
