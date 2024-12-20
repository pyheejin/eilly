import 'package:eilly/provider/cart_provider.dart';
import 'package:eilly/provider/category_provider.dart';
import 'package:eilly/provider/product_provider.dart';
import 'package:eilly/screen/store_detail.dart';
import 'package:eilly/widget/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class StoreScreen extends ConsumerWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numberFormat = NumberFormat('###,###,###,###');

    final categoryId = ref.watch(categoryTapProvider);
    final categories = ref.watch(categoryProvider);
    final products = ref.watch(productProvider(categoryId));
    final productCount = ref.watch(productCountProvider(categoryId)).value;

    int length = 100;
    if (categories.value != null) {
      if (categories.value!.length <= 4) {
        length = 100;
      } else {
        length = 200;
      }
    }

    void onCategoryTap(int id) {
      ref.read(categoryTapProvider.notifier).update((state) => id);
    }

    void onTap(int id) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => StoreDetailScreen(productId: id),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '고민되는 카테고리를 선택하세요.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: SizedBox(
                        height: length.toDouble(),
                        child: categories.when(
                          data: (categoryList) => GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 1 / 1,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: categoryList.length,
                            itemBuilder: (context, index) {
                              bool isSelected = false;

                              if (categoryList.isNotEmpty) {
                                return GestureDetector(
                                  onTap: () {
                                    onCategoryTap(categoryList[index].id!);
                                  },
                                  child: Category(
                                    text: categoryList[index].name,
                                    isSelected: isSelected,
                                    imageUrl: categoryList[index].imageUrl,
                                    selectedImageUrl:
                                        categoryList[index].selectedImageUrl,
                                  ),
                                );
                              }
                              return null;
                            },
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stack) => Text('카테고리 에러: $error'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '총 $productCount개',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  const Row(
                    children: [
                      Text(
                        '추천순',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(
                        Icons.expand_circle_down_outlined,
                        size: 19,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Expanded(
                child: products.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('카테고리 에러: $error'),
                  data: (productList) => GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 1개의 행에 보여줄 item 개수
                      childAspectRatio: 1 / 1.3, // item의 가로 1, 세로 2 비율
                      mainAxisSpacing: 10, // 수직 Padding
                      crossAxisSpacing: 10,
                    ),
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      if (productList.isNotEmpty) {
                        return GestureDetector(
                          onTap: () {
                            onTap(productList[index].id!);
                          },
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 200,
                                    height: 200,
                                    color: const Color(0xffF2F2F2),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Image.network(
                                          productList[index].imageUrl),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        Fluttertoast.showToast(
                                          msg: '장바구니에 상품을 담았습니다.',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.white,
                                          textColor: const Color(0xffff5c35),
                                          fontSize: 16.0,
                                        );

                                        ref.read(cartProvider.notifier).addCart(
                                              1,
                                              productList[index].id!,
                                            );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Icon(
                                            Icons.shopping_bag_outlined,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(productList[index].name),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${numberFormat.format(productList[index].price)}원',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
