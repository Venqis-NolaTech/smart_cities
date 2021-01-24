import 'package:flutter/material.dart';

import '../../../../core/util/list_util.dart';
import '../../../../shared/app_images.dart';
import '../../../../shared/components/base_view.dart';
import '../../../../shared/components/fade_indexed_stack.dart';
import '../../../../shared/provider/view_state.dart';
import '../providers/blog_header_provider.dart';
import 'blog_header_page_view.dart';

class BlogHeader extends SliverPersistentHeaderDelegate {
  BlogHeader({
    @required this.expandedHeight,
  });

  final double expandedHeight;

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return BaseView<BlogHeaderProvider>(
      onProviderReady: (provider) => provider.loadData(),
      builder: (context, provider, child) {
        final isLoading = provider.currentState is Loading;

        return FadeIndexedStack(
          index: isLoading ? 0 : 1,
          children: [
            Center(child: CircularProgressIndicator()),
            Stack(
              fit: StackFit.expand,
              overflow: Overflow.visible,
              children: [
                Positioned(
                  top: -shrinkOffset,
                  left: 0.0,
                  right: 0.0,
                  child: _buildHeaderSection(context, provider),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeaderSection(
      BuildContext context, BlogHeaderProvider provider) {
    return Container(
      height: expandedHeight,
      child: provider.lastPosts.isNullOrEmpty
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                AppImagePaths.defaultImage,
                fit: BoxFit.cover,
              ),
            )
          : BlogHeaderPageView(
              posts: provider.lastPosts,
            ),
    );
  }
}
