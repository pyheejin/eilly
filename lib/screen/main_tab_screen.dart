import 'package:eilly/provider/cart_provider.dart';
import 'package:eilly/provider/main_tap_provider.dart';
import 'package:eilly/screen/cart.dart';
import 'package:eilly/screen/home.dart';
import 'package:eilly/screen/profile.dart';
import 'package:eilly/screen/store.dart';
import 'package:eilly/widget/nav_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainTabScreen extends ConsumerWidget {
  const MainTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartCountProvider).value;

    int selectedIndex = ref.watch(mainTapProvider);

    void onTap(int index) {
      ref.read(mainTapProvider.notifier).update((state) => index);
    }

    void onCartTap() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const CartScreen(),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          actions: [
            Stack(
              children: [
                GestureDetector(
                  onTap: onCartTap,
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
                    child: Center(
                      child: Text(
                        cartCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
              offstage: selectedIndex != 0,
              child: const HomeScreen(),
            ),
            Offstage(
              offstage: selectedIndex != 1,
              child: const StoreScreen(),
            ),
            Offstage(
              offstage: selectedIndex != 2,
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
              isSelected: selectedIndex == 0,
              icon: Icons.house,
              selectedIcon: Icons.house,
              onTap: () => onTap(0),
              selectedIndex: selectedIndex,
            ),
            NavTab(
              text: '스토어',
              isSelected: selectedIndex == 1,
              icon: Icons.store,
              selectedIcon: Icons.store,
              onTap: () => onTap(1),
              selectedIndex: selectedIndex,
            ),
            NavTab(
              text: '마이페이지',
              isSelected: selectedIndex == 2,
              icon: Icons.person,
              selectedIcon: Icons.person,
              onTap: () => onTap(2),
              selectedIndex: selectedIndex,
            ),
          ],
        ),
      ),
    );
  }
}
