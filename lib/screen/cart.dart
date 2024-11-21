import 'package:eilly/database/models.dart';
import 'package:eilly/provider/cart_provider.dart';
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
              Expanded(
                child: products.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('카테고리 에러: $error'),
                  data: (productList) => ListView.builder(
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      int price = productList[index].price != null
                          ? productList[index].price! *
                              productList[index].quantity
                          : 0;
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 55,
                                                  height: 55,
                                                  color:
                                                      const Color(0xffF2F2F2),
                                                  child: Image.network(
                                                      productList[index]
                                                          .imageUrl!),
                                                ),
                                                const SizedBox(width: 20),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      productList[index].name!,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              ref
                                                                  .read(cartProductCountProvider
                                                                      .notifier)
                                                                  .decrement(
                                                                    1,
                                                                    productList[
                                                                            index]
                                                                        .productId,
                                                                  );
                                                            },
                                                            child: const Icon(
                                                                Icons.remove),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                              productList[index]
                                                                  .quantity
                                                                  .toString()),
                                                          const SizedBox(
                                                              width: 5),
                                                          GestureDetector(
                                                            onTap: () {
                                                              ref
                                                                  .read(cartProductCountProvider
                                                                      .notifier)
                                                                  .increment(
                                                                    1,
                                                                    productList[
                                                                            index]
                                                                        .productId,
                                                                  );
                                                            },
                                                            child: const Icon(
                                                                Icons.add),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${numberFormat.format(price)}원',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  GestureDetector(
                                                    onTap: () {
                                                      ref
                                                          .read(
                                                              cartProductCountProvider
                                                                  .notifier)
                                                          .delete(
                                                            1,
                                                            productList[index]
                                                                .productId,
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
                      );
                    },
                  ),
                ),
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
