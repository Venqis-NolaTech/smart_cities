import 'package:flutter/material.dart';

import '../../../../../generated/i18n.dart';
import '../../../../shared/components/base_view.dart';
import '../../../../shared/components/custom_sliver_app_bar.dart';
import '../../domain/entities/post.dart';
import '../providers/blog_provider.dart';
import '../widgets/blog_header.dart';
import '../widgets/blog_list.dart';
import '../widgets/blog_tab_view.dart';
import '../../../../shared/app_colors.dart';

enum BlogTap {
  all,
  news,
  annoumcement,
  training,
}

extension BlogTapExtension on BlogTap {
  int get index {
    switch (this) {
      case BlogTap.news:
        return 1;
      case BlogTap.training:
        return 2;
      case BlogTap.annoumcement:
        return 3;
      case BlogTap.all:
      default:
        return 0;
    }
  }

  String getLabel(BuildContext context) {
    switch (this) {
      case BlogTap.news:
        return S.of(context).news;
      case BlogTap.training:
        return S.of(context).training;
      case BlogTap.annoumcement:
        return S.of(context).announcement;
      case BlogTap.all:
      default:
        return S.of(context).posts;
    }
  }
}

class BlogPageArgs {
  final BlogTap currentTap;

  BlogPageArgs({this.currentTap = BlogTap.all});
}

class BlogPage extends StatefulWidget {
  static const id = "blog_page";

  static pushNavigate(BuildContext context, {BlogPageArgs args}) =>
      Navigator.pushNamed(
        context,
        id,
        arguments: args,
      );

  BlogPage({
    Key key,
    @required this.args,
  }) : super(key: key);

  final BlogPageArgs args;

  @override
  _BlogPageState createState() => _BlogPageState(args);
}

class _BlogPageState extends State<BlogPage>
    with SingleTickerProviderStateMixin {
  static const _headerHight = 250.0;

  TabController _tabController;
  ScrollController _scrollController;

  _BlogPageState(this.args);

  final BlogPageArgs args;

  final _tabWidgets = List<Widget>(BlogTap.values.length);

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: BlogTap.values.length,
      initialIndex: args.currentTap.index,
      vsync: this,
    )..addListener(_onTabListener);

    _scrollController = ScrollController();

    _initTabWidgets();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  void _onTabListener() {
    if (_scrollController.position.pixels >= _headerHight)
      _scrollController.animateTo(
        _headerHight,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
  }

  void _initTabWidgets() {
    _tabWidgets[0] = PostsList(
      args: PostListArgs(
        scrollController: _scrollController,
        onPostPressed: (post) {},
      ),
    );

    _tabWidgets[1] = PostsList(
      args: PostListArgs(
        kind: PostKind.news,
        scrollController: _scrollController,
        onPostPressed: (post) {},
      ),
    );

    _tabWidgets[2] = PostsList(
      args: PostListArgs(
        kind: PostKind.training,
        scrollController: _scrollController,
        onPostPressed: (post) {},
      ),
    );

    _tabWidgets[3] = PostsList(
      args: PostListArgs(
        kind: PostKind.announcement,
        scrollController: _scrollController,
        onPostPressed: (post) {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<BlogProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, _) {
              return [
                _buildAppBar(context),
                _buildBlogHeader(),
                _buildTabBarHeader(),
              ];
            },
            body: _buildTabView(),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return CustomSliverAppBar(
      elevation: 2.0,
      pinned: true,
      title: Text(S.of(context).posts),
      centerTitle: false,
      backgroundColor: AppColors.red,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    );
  }

  Widget _buildBlogHeader() {
    return SliverPersistentHeader(
      pinned: false,
      delegate: BlogHeader(
        expandedHeight: _headerHight,
      ),
    );
  }

  Widget _buildTabBarHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: BlogTabView(
        expandedHeight: kToolbarHeight,
        tabController: _tabController,
      ),
    );
  }

  Widget _buildTabView() {
    return TabBarView(
      controller: _tabController,
      children: _tabWidgets,
    );
  }
}
