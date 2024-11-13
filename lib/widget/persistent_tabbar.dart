import 'package:flutter/material.dart';

class PersistentTabBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.grey.shade200,
            width: 0.5,
          ),
        ),
      ),
      child: const TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        labelPadding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        indicatorColor: Colors.black,
        labelColor: Colors.black,
        tabs: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('구매내역'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('이전 설문 결과'),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 44;

  @override
  double get minExtent => 44;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
