import 'package:eilly/database/models.dart';
import 'package:eilly/provider/cart_provider.dart';
import 'package:eilly/screen/home.dart';
import 'package:eilly/screen/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numberFormat = NumberFormat('###,###,###,###');
    final products = ref.watch(cartProductProvider(1));

    int sumPrice = 0;
    if (products.value != null) {
      sumPrice = products.value!.first.sumPrice!;
    }

    void onOrderTap() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const OrderScreen(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('장바구니'),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                    left: 10,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(cartProductCountProvider.notifier)
                              .deleteAll(1);
                        },
                        child: const Text(
                          '전체삭제',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            children: [
              ProductList(
                products: products,
                numberFormat: numberFormat,
                ref: ref,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  color: const Color(0xffF2F2F2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '전체금액',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${numberFormat.format(sumPrice)}원',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          onPressed: onOrderTap,
          child: const Text(
            '구매하기',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.products,
    required this.numberFormat,
    required this.ref,
  });

  final AsyncValue<List<CartModel>> products;
  final NumberFormat numberFormat;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    void onHomeTap() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }

    try {
      return Expanded(
        child: products.when(
          loading: () {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 100,
              ),
              child: Column(
                children: [
                  const Text(
                    '장바구니에 담겨있는 제품이 없어요.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '영양추천을 통해',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    '나에게 필요한 영양성분을 알아보세요:)',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xffff5c35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                    onPressed: onHomeTap,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 20,
                      ),
                      child: Text(
                        '영양추천 받으러 가기',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stack) => Text('카테고리 에러: $error'),
          data: (productList) => ListView.builder(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              int price = 0;
              if (productList[index].price != null) {
                price = productList[index].price! * productList[index].quantity;
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 55,
                                      height: 55,
                                      color: const Color(0xffF2F2F2),
                                      child: Image.network(
                                          productList[index].imageUrl!),
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 2),
                                        Text(
                                          productList[index].name!,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  ref
                                                      .read(
                                                          cartProductCountProvider
                                                              .notifier)
                                                      .decrement(
                                                        1,
                                                        productList[index]
                                                            .productId,
                                                      );
                                                },
                                                child: const Icon(Icons.remove),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(productList[index]
                                                  .quantity
                                                  .toString()),
                                              const SizedBox(width: 5),
                                              GestureDetector(
                                                onTap: () {
                                                  ref
                                                      .read(
                                                          cartProductCountProvider
                                                              .notifier)
                                                      .increment(
                                                        1,
                                                        productList[index]
                                                            .productId,
                                                      );
                                                },
                                                child: const Icon(Icons.add),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${numberFormat.format(price)}원',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          ref
                                              .read(cartProductCountProvider
                                                  .notifier)
                                              .delete(
                                                1,
                                                productList[index].productId,
                                              );
                                        },
                                        child: const Text(
                                          '삭제',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    } finally {
      const Text('no data');
    }
  }
}
