import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';

import '../../../../../generated/i18n.dart';
import '../../../../core/error/failure.dart';
import '../../../../shared/app_images.dart';
import '../../../../shared/components/base_view.dart';
import '../../../../shared/components/info_view.dart';
import '../../../../shared/components/loading_indicator.dart';
import '../../../../shared/constant.dart';
import '../../../../shared/provider/view_state.dart';
import '../../../../shared/spaces.dart';
import '../../domain/entities/post.dart';
import '../pages/blog_detail_page.dart';
import '../providers/blog_list_provider.dart';
import 'blog_list_item.dart';

class PostListArgs {
  final PostKind kind;

  final ScrollController scrollController;
  final Function(Post) onPostPressed;

  PostListArgs({
    this.kind,
    this.scrollController,
    this.onPostPressed,
  });
}

class PostListDetailCallback {
  final bool refresh;
  final bool liked;

  PostListDetailCallback({
    this.refresh,
    this.liked,
  });
}

class PostsList extends StatefulWidget {
  PostsList({
    Key key,
    @required this.args,
  }) : super(key: key);

  final PostListArgs args;

  @override
  _PostsListState createState() => _PostsListState(args);
}

class _PostsListState extends State<PostsList> {
  _PostsListState(this.args);

  final PostListArgs args;

  BlogListProvider _provider;

  @override
  void initState() {
    super.initState();

    args.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (args.scrollController.position.pixels ==
        args.scrollController.position.maxScrollExtent) {
      _provider?.fetchData();
    }
  }

  void _gotoDetail(Post post) async {
    final detailCallback = (await BlogDetailPage.pushNavigate(
      context,
      args: BlogDetailPageArgs(post: post, isVisibleLiked: _provider.isLogged ?? false),
    )) as PostListDetailCallback;

    if (detailCallback != null && detailCallback.refresh)
      _provider.updatePostOnList(Post.from(post, liked: detailCallback.liked));
  }

  void _onLikePost(Post post, bool liked) {
    _provider?.likePost(post.id);
  }

  void _onSharePost(Post post) {
    Share.share(post?.shareLink);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<BlogListProvider>(
      onProviderReady: (provider) => provider.loadData(args.kind),
      builder: (context, provider, child) {
        _provider = provider;

        final currentState = provider.currentState;

        if (currentState is Error) {
          final failure = currentState.failure;

          return _buildErrorView(provider, failure);
        }

        return IndexedStack(
          index: currentState is Loading ? 0 : 1,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.6,
              child: LoadingIndicator(),
            ),
            _buildPosts(_provider),
          ],
        );
      },
    );
  }

  Widget _buildPosts(BlogListProvider provider) {
    return StreamBuilder<List<Post>>(
      stream: provider.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return _buildEmptyView();
          } else {
            final posts = snapshot.data;
            return Stack(
              children: <Widget>[
                _buildList(posts, provider),
              ],
            );
          }
        } else if (snapshot.hasError) {
          return _buildErrorView(provider, snapshot.error);
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildLoadingIndicator(bool isLoading) {
    return isLoading ? LoadingIndicator() : SizedBox.shrink();
  }

  Widget _buildList(List<Post> posts, BlogListProvider provider) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final post = posts[index];
        final bool isFirst = index == 0;
        final bool isLast = index == posts.length - 1;

        final blogItem = BlogListItem(
          key: ValueKey(post),
          post: post,
          isFirst: isFirst,
          isLast: isLast,
          isVisibleLiked: provider.isLogged ?? false,
          onPressed: () => _gotoDetail(post),
          onLikePressed: (liked) => _onLikePost(post, liked),
          onSharePressed: () => _onSharePost(post),
        );

        if (isLast) {
          return Wrap(
            children: [
              blogItem,
              _buildLoadingIndicator(provider.isLoading),
            ],
          );
        }

        return blogItem;
      },
      separatorBuilder: (_, __) => Spaces.verticalMedium(),
    );
  }

  Widget _buildEmptyView() {
    return Container(
        height: MediaQuery.of(context).size.height / 1.5,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImagePaths.defaultImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.08),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Text(
          "", //S.of(context).blogEmptyMessage,
          textAlign: TextAlign.center,
          style: kTitleStyle,
        ));
  }

  Widget _buildErrorView(BlogListProvider provider, Failure failure) {
    String message = failure is NotConnectionFailure
        ? S.of(context).noConnectionMessage
        : S.of(context).unexpectedErrorMessage;

    Icon image = Icon(
      failure is NotConnectionFailure
          ? MdiIcons.lanDisconnect
          : MdiIcons.alertCircle,
      size: 48,
    );

    return InfoView(
      title: message,
      image: image,
      titleAction: S.of(context).tryAgain,
      actionPressed: () => provider.refreshData(),
    );
  }
}
