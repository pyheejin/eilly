import 'package:eilly/database/database.dart';
import 'package:eilly/database/models.dart';
import 'package:eilly/screen/store_detail.dart';
import 'package:eilly/widget/category.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final numberFormat = NumberFormat('###,###,###,###');

  final DatabaseHelper db = DatabaseHelper();

  late Future<List<CategoryModel>> categories;
  late Future<List<ProductModel>> products;

  int categoryId = 1;

  @override
  void initState() {
    super.initState();

    db.initDb();
    categories = db.getCategories();
    products = db.getProducts(categoryId);
  }

  void _onTap(int id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StoreDetailScreen(productId: id),
      ),
    );
  }

  void _onCartTap(int userId, int productId) async {
    await db.insertCart(userId, productId);
  }

  @override
  Widget build(BuildContext context) {
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
                    const SizedBox(height: 10),
                    FutureBuilder(
                      future: categories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<CategoryModel> categoryList =
                              snapshot.data as List<CategoryModel>;
                          return SizedBox(
                            height: 100,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 1 / 1,
                                crossAxisSpacing: 15,
                              ),
                              itemCount: categoryList.length,
                              itemBuilder: (context, index) {
                                bool isSelected = false;

                                if (categoryList.isNotEmpty) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        products = db.getProducts(
                                            categoryList[index].id!.toInt());

                                        isSelected = true;
                                      });
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
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ];
          },
          body: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '총 10개',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Row(
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
              FutureBuilder(
                future: products,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<ProductModel> productList =
                        snapshot.data as List<ProductModel>;
                    return Expanded(
                      child: GridView.builder(
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
                                _onTap(productList[index].id!.toInt());
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
                                            _onCartTap(
                                              1,
                                              productList[index].id!,
                                            );

                                            Fluttertoast.showToast(
                                              msg: '장바구니에 상품을 담았습니다.',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.white,
                                              textColor:
                                                  const Color(0xffff5c35),
                                              fontSize: 16.0,
                                            );

                                            setState(() {});
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
