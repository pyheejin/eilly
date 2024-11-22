import 'package:eilly/provider/cart_provider.dart';
import 'package:eilly/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class StoreDetailScreen extends ConsumerWidget {
  const StoreDetailScreen({
    super.key,
    required this.productId,
  });

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numberFormat = NumberFormat('###,###,###,###');

    final productDetail = ref.watch(productDetailProvider(productId));

    String imageUrl = '';
    String name = '';
    int price = 0;
    String description = '';

    if (productDetail.value != null) {
      imageUrl = productDetail.value!.imageUrl.toString();
      name = productDetail.value!.name.toString();
      price = productDetail.value!.price;
      description = productDetail.value!.description.toString();
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
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xffF2F2F2),
              child: imageUrl != '' ? Image.network(imageUrl) : null,
            ),
            const SizedBox(height: 30),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${numberFormat.format(price)}원',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          onPressed: () {
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
                  productId,
                );
          },
          child: const Text(
            '장바구니 담기',
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
