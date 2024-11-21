import 'package:eilly/provider/category_provider.dart';
import 'package:eilly/provider/product_provider.dart';
import 'package:eilly/screen/store_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyResultScreen extends ConsumerWidget {
  const SurveyResultScreen({
    super.key,
    required this.productId,
  });

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productDetail = ref.watch(productDetailProvider(productId));
    final categoryDetail =
        ref.watch(categoryDetailProvider(productDetail.value!.categoryId));

    void onTap() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => StoreDetailScreen(productId: productId),
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
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '건강설문 결과',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${categoryDetail.value!.name}에 관련된 영양제를 추천해드릴게요!',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xffff5c35),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              color: const Color(0xffF2F2F2),
              child: Image.network(productDetail.value!.imageUrl),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                productDetail.value!.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          onPressed: onTap,
          child: const Text(
            '자세히 보러가기',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
