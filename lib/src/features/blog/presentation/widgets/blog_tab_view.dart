import 'package:flutter/material.dart';
import '../pages/blog_page.dart';
import '../../../../shared/app_colors.dart';
import '../../../../shared/constant.dart';

class BlogTabView extends SliverPersistentHeaderDelegate {
  BlogTabView({
    @required this.expandedHeight,
    @required this.tabController,
  });

  final double expandedHeight;
  final TabController tabController;

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: expandedHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: tabController,
        labelColor: AppColors.red,
        unselectedLabelColor: Colors.grey,
        isScrollable: true,
        labelStyle: kNormalStyle.copyWith(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: kNormalStyle.copyWith(
          fontWeight: FontWeight.normal,
        ),
        tabs: BlogTap.values
            .map((tap) => Tab(text: tap.getLabel(context)))
            .toList(),
      ),
    );
  }
}
