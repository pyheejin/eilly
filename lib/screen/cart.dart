import 'package:eilly/database/database.dart';
import 'package:eilly/database/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final numberFormat = NumberFormat('###,###,###,###');

  final DatabaseHelper db = DatabaseHelper();

  late Future<List<CartModel>> carts;
  late Future<int> _cartLength;

  @override
  void initState() {
    super.initState();

    db.initDb();
    carts = db.getCarts(1);
    _cartLength = db.getCartCount(1);
  }

  bool _isAllChecked = false;
  final List<int> _cart = [];

  void _onIncreaseCount(int userId, int productId) async {
    await db.increaseCartItem(userId, productId);
    print('증가');
  }

  void _onDecreaseCount(int userId, int productId) async {
    await db.decreaseCartItem(userId, productId);
    print('감소');
  }

  void _onDeleteCartTap(int userId, int productId) async {
    await db.deleteCart(userId, productId);
    print('삭제완료');
  }

  @override
  Widget build(BuildContext context) {
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
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _isAllChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                _isAllChecked = value!;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            activeColor: const Color(0xffff5c35),
                            side: const BorderSide(
                              color: Color(0xffff5c35),
                              width: 1,
                            ),
                          ),
                          const Text('전체'),
                        ],
                      ),
                      const Text(
                        '전체삭제',
                        style: TextStyle(
                          color: Colors.red,
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
          child: FutureBuilder(
              future: carts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<CartModel> cartList = snapshot.data as List<CartModel>;
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: cartList.length,
                          itemBuilder: (context, index) {
                            bool isChecked = false;
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Checkbox(
                                                      value: isChecked,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked = value!;
                                                          _cart.add(index);

                                                          if (_cart.length ==
                                                              _cartLength) {
                                                            _isAllChecked =
                                                                true;
                                                          } else {
                                                            _isAllChecked =
                                                                false;
                                                          }
                                                        });
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      activeColor: const Color(
                                                          0xffff5c35),
                                                      side: const BorderSide(
                                                        color:
                                                            Color(0xffff5c35),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Container(
                                                      width: 55,
                                                      height: 55,
                                                      color: const Color(
                                                          0xffF2F2F2),
                                                      child: Image.network(
                                                          cartList[index]
                                                              .imageUrl!),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                            height: 2),
                                                        Text(
                                                          cartList[index].name!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.3),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    _onDecreaseCount(
                                                                        1,
                                                                        cartList[index]
                                                                            .productId);
                                                                  });
                                                                },
                                                                child: const Icon(
                                                                    Icons
                                                                        .remove),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Text(cartList[
                                                                      index]
                                                                  .quantity
                                                                  .toString()),
                                                              const SizedBox(
                                                                  width: 5),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    _onIncreaseCount(
                                                                        1,
                                                                        cartList[index]
                                                                            .productId);
                                                                  });
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '${numberFormat.format(cartList[index].price)}원',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _onDeleteCartTap(
                                                              1,
                                                              cartList[index]
                                                                  .productId,
                                                            );
                                                          });
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
                            });
                          },
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '전체금액',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${numberFormat.format(cartList[0].sumPrice)}원',
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
                  );
                }
              }),
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
