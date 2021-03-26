import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/blog/domain/entities/post.dart';
import 'package:smart_cities/src/features/blog/presentation/pages/blog_detail_page.dart';
import 'package:smart_cities/src/features/blog/presentation/pages/blog_page.dart';
import 'package:smart_cities/src/features/blog/presentation/providers/blog_featured_provider.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/components/bubble_text.dart';
import 'package:smart_cities/src/shared/components/firebase_storage_image.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import 'package:smart_cities/src/core/util/date_util.dart';


class FeatureNews extends StatefulWidget {

  @override
  _FeatureNewsState createState() => _FeatureNewsState();
}

class _FeatureNewsState extends State<FeatureNews> {
  List<Post> posts=[];

  int _pageIndex = 0;
  BlogFeaturedProvider provider;


  void _onPageChanged(int index) {
    setState(() => _pageIndex = index);
  }

  void _gotoDetail(Post post) async {
    BlogDetailPage.pushNavigate(
      context,
      args: BlogDetailPageArgs(
          post: post,
          isVisibleLiked: provider.isLogged ?? false
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return BaseView<BlogFeaturedProvider>(
      onProviderReady: (provider)=> provider.loadData(),
      builder: (context, _provider, child) {

        provider= _provider;

        return GestureDetector(
          onTap: () => BlogPage.pushNavigate(
            context,
            args: BlogPageArgs(),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(strfTime(DateTime.now(), context),
                      textAlign: TextAlign.start,
                      style: kSmallestTextStyle.copyWith(
                        color: AppColors.blueBtnRegister,
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
              Spaces.verticalMedium(),
              InkWell(
                onTap: () => BlogPage.pushNavigate(
                  context,
                  args: BlogPageArgs(),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(S.of(context).noticeFeatureds,
                              style: kMediumTitleStyle.copyWith(
                                color: AppColors.blueBtnRegister,
                                fontWeight: FontWeight.bold,
                              ))),
                      Text(S.of(context).seeAlls.toUpperCase(),
                          style: kSmallestTextStyle.copyWith(
                            color: AppColors.blueBtnRegister,
                            fontWeight: FontWeight.w500,
                          )),
                      Icon(Icons.chevron_right, color: AppColors.blueBtnRegister)
                    ],
                  ),
                ),
              ),
              provider.currentState is Loaded ?
              _buildPost(provider.currentState) : _buildLoadingPost()
            ],
          ),
        );



      }
    );



  }

  Widget _buildLoadingPost(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppImages.defaultImage,
    );
  }

  Widget _buildPost(ViewState currentState) {
    if (currentState is Loaded){
      posts = currentState.value;
      return _buildCarrousel();
    }
    return Container();
  }

  Widget _buildCarrousel() {
    return Container(
      height: 300,
      child: Stack(
        children: [
          Positioned.fill(child: _buildPageView()),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 16.0,
            child: _buildPageIndecator(),
          ),
        ],
      ),
    );
  }


  Widget _buildPageView() {
    return PageView.builder(
      onPageChanged: _onPageChanged,
      itemCount: posts.length,
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
