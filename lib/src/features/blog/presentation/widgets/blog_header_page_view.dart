import 'package:flutter/material.dart';
import '../pages/blog_detail_page.dart';

import '../../../../shared/app_colors.dart';
import '../../../../shared/app_images.dart';
import '../../../../shared/components/bubble_text.dart';
import '../../../../shared/components/firebase_storage_image.dart';
import '../../../../shared/constant.dart';
import '../../../../shared/spaces.dart';
import '../../domain/entities/post.dart';

class BlogHeaderPageView extends StatefulWidget {
  const BlogHeaderPageView({
    Key key,
    @required this.posts,
    @required this.isLogged,
  }) : super(key: key);

  final List<Post> posts;
  final bool isLogged;

  @override
  _BlogHeaderPageViewState createState() => _BlogHeaderPageViewState(posts);
}

class _BlogHeaderPageViewState extends State<BlogHeaderPageView> {
  _BlogHeaderPageViewState(this.posts);

  final List<Post> posts;

  int _pageIndex = 0;

  void _onPageChanged(int index) {
    setState(() => _pageIndex = index);
  }

  void _gotoDetail(Post post) async {
    BlogDetailPage.pushNavigate(
      context,
      args: BlogDetailPageArgs(
          post: post,
          isVisibleLiked: widget.isLogged ?? false
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: _buildPageView()),
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 16.0,
          child: _buildPageIndecator(),
        ),
      ],
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      onPageChanged: _onPageChanged,
      itemCount: widget.posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];

        return InkWell(
          onTap: () => _gotoDetail(post),
          child: Stack(
            children: [
              Positioned.fill(
                child: _buildPicture(post),
              ),
              Positioned.fill(
                child: _buildContent(context, post),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageIndecator() {
    return SizedBox(
      height: 24.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          posts.length,
          ((index) {
            final isCurrent = _pageIndex == index;
            final size = isCurrent ? 12.0 : 8.0;

            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: size,
              height: size,
              margin: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCurrent ? Colors.white : Colors.white.withOpacity(0.5),
              ),
            );
          }),
        ).toList(),
      ),
    );
  }

  Widget _buildPicture(Post post) {
    return Container(
      color: Colors.grey.shade300,
      child: ShaderMask(
        child: FirebaseStorageImage(
          referenceUrl: post.pictureURL,
          fallbackWidget: CircularProgressIndicator(),
          errorWidget: AppImages.defaultImage,
        ),
        shaderCallback: (bounds) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.2),
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(0.8),
            ],
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcATop,
      ),
    );
  }

  Widget _buildContent(BuildContext context, Post post) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: 48.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spacer(),
          Row(
            children: [
              BubbleText(
                post.kind.getLabel(context),
                style: kSmallestTextStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                color: AppColors.red,
                borderRadius: 16,
              ),
              Spacer(),
            ],
          ),
          Spaces.verticalMedium(),
          Text(
            post.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: kMediumTitleStyle.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
