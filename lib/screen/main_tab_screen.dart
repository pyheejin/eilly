import 'package:eilly/database/database.dart';
import 'package:eilly/database/models.dart';
import 'package:eilly/screen/cart.dart';
import 'package:eilly/screen/home.dart';
import 'package:eilly/screen/profile.dart';
import 'package:eilly/screen/store.dart';
import 'package:eilly/widget/nav_tab.dart';
import 'package:eilly/widget/storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  final DatabaseHelper db = DatabaseHelper();

  late Future<List<CartModel>> carts;
  late Future<int> cartLength;

  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();

    db.initDb();
    carts = db.getCarts(1);
    cartLength = db.getCartCount(1);
  }

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCartTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CartScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          actions: [
            Stack(
              children: [
                GestureDetector(
                  onTap: _onCartTap,
                  child: const SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: Icon(
                        Icons.shopping_cart,
                        size: 25,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 1,
                  left: 17,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FutureBuilder(
                      future: cartLength,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          int cartLength = snapshot.data!;
                          return Center(
                            child: Text(
                              cartLength.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
          title: const Text(
            'eilly',
            style: TextStyle(
              color: Color(0xffff5c35),
              fontSize: 27,
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 1,
        ),
        child: Stack(
          children: [
            Offstage(
              offstage: _selectedIndex != 0,
              child: const HomeScreen(),
            ),
            Offstage(
              offstage: _selectedIndex != 1,
              child: const StoreScreen(),
            ),
            Offstage(
              offstage: _selectedIndex != 2,
              child: const ProfileScreen(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NavTab(
              text: '홈',
              isSelected: _selectedIndex == 0,
              icon: Icons.house,
              selectedIcon: Icons.house,
              onTap: () => _onTap(0),
              selectedIndex: _selectedIndex,
            ),
            NavTab(
              text: '스토어',
              isSelected: _selectedIndex == 1,
              icon: Icons.store,
              selectedIcon: Icons.store,
              onTap: () => _onTap(1),
              selectedIndex: _selectedIndex,
            ),
            NavTab(
              text: '마이페이지',
              isSelected: _selectedIndex == 2,
              icon: Icons.person,
              selectedIcon: Icons.person,
              onTap: () => _onTap(2),
              selectedIndex: _selectedIndex,
            ),
          ],
        ),
      ),
    );
  }
}
