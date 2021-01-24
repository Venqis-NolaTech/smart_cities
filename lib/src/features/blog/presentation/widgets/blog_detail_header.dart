import 'package:flutter/material.dart';

import '../../../../shared/app_colors.dart';
import '../../../../shared/app_images.dart';
import '../../../../shared/components/bubble_text.dart';
import '../../../../shared/components/firebase_storage_image.dart';
import '../../../../shared/constant.dart';
import '../../../../shared/spaces.dart';
import '../../domain/entities/post.dart';

class BlogDetailHeader extends StatelessWidget {
  const BlogDetailHeader({Key key, @required this.post}) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
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
              Colors.black.withOpacity(0.3),
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
            maxLines: 4,
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
