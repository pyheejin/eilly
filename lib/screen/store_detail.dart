import 'package:eilly/database/database.dart';
import 'package:eilly/database/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StoreDetailScreen extends StatefulWidget {
  final int productId;

  const StoreDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  final numberFormat = NumberFormat('###,###,###,###');

  final DatabaseHelper db = DatabaseHelper();

  late Future<ProductModel> product;

  @override
  void initState() {
    super.initState();

    db.initDb();
    product = db.getProductDetail(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
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
            FutureBuilder(
              future: product,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  ProductModel productDetail = snapshot.data as ProductModel;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: const Color(0xffF2F2F2),
                        child: Image.network(productDetail.imageUrl),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        productDetail.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${numberFormat.format(productDetail.price)}원',
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
                              productDetail.description,
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          onPressed: () {},
          child: const Text('구매하기'),
        ),
      ),
    );
  }
}
