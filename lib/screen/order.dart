import 'package:eilly/database/models.dart';
import 'package:eilly/provider/order_provider.dart';
import 'package:eilly/screen/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numberFormat = NumberFormat('###,###,###,###');

    final products = ref.watch(orderProductProvider(1));

    int sumPrice = 0;
    if (products.value != null) {
      sumPrice = products.value!.first.sumPrice!;
    }

    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final addressDetailController = TextEditingController();
    final deliveryMessageController = TextEditingController();

    void onTap() {
      print('주문완료');
      final List<OrderModel> orders = [];

      final payment = PaymentModel(
        userId: 1,
        name: nameController.text,
        phone: phoneController.text,
        address: addressController.text,
        addressDetail: addressDetailController.text,
        deliveryMessage: deliveryMessageController.text,
        price: sumPrice,
      );

      for (var product in products.value!) {
        orders.add(OrderModel(
          productId: product.productId,
          quantity: product.quantity,
          price: product.price!,
        ));
      }

      ref.read(orderProvider.notifier).addOrder(
            orders,
            payment,
          );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'eilly',
          style: TextStyle(
            color: Color(0xffff5c35),
            fontSize: 27,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            int height = 70;
            if (products.value != null) {
              height = products.value!.length * 70;
            }
            return [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '제품정보',
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
                        height: height.toDouble(),
                        child: products.when(
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stack) => Text('상품 목록 에러: $error'),
                          data: (productList) => ListView.builder(
                            itemCount: productList.length,
                            itemBuilder: (context, index) {
                              int price = 0;
                              if (productList[index].price != null) {
                                price = productList[index].price! *
                                    productList[index].quantity;
                              }
                              return Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 70,
                                              height: 70,
                                              color: const Color(0xffF2F2F2),
                                              child: Image.network(
                                                  productList[index].imageUrl!),
                                            ),
                                            const SizedBox(width: 20),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(productList[index].name!),
                                                Row(
                                                  children: [
                                                    Text(
                                                        '${productList[index].quantity}개'),
                                                    const SizedBox(width: 10),
                                                    const Icon(
                                                      Icons.fiber_manual_record,
                                                      size: 5,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      '${numberFormat.format(price)}원',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '제품합계금액',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${numberFormat.format(sumPrice)}원',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '기본 배송비',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '3,000원',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '총 결제금액',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${numberFormat.format(sumPrice + 3000)}원',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '배송정보',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '수령인 이름',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: '수령인 이름을 입력해주세요.',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 161, 147, 147),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '수령인 연락처',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    hintText: '수령인 연락처를 입력해주세요.',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 161, 147, 147),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '주소',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    hintText: '주소를 입력해주세요.',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 161, 147, 147),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '상세 주소',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: addressDetailController,
                  decoration: const InputDecoration(
                    hintText: '상세 주소를 입력해주세요.',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 161, 147, 147),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '배송 요청사항',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: deliveryMessageController,
                  decoration: const InputDecoration(
                    hintText: '배송 요청사항 입력해주세요.',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 161, 147, 147),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          onPressed: onTap,
          child: const Text(
            '주문하기',
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
