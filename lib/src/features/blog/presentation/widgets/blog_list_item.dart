import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../shared/app_colors.dart';
import '../../../../shared/app_images.dart';
import '../../../../shared/components/bubble_text.dart';
import '../../../../shared/components/circular_button.dart';
import '../../../../shared/components/firebase_storage_image.dart';
import '../../../../shared/constant.dart';
import '../../../../shared/spaces.dart';
import '../../domain/entities/post.dart';

class BlogListItem extends StatefulWidget {
  const BlogListItem({
    Key key,
    @required this.post,
    @required this.onPressed,
    @required this.onLikePressed,
    @required this.onSharePressed,
    this.isFirst = false,
    this.isLast = false,
    this.isVisibleLiked = false,
  }) : super(key: key);

  final Post post;
  final bool isFirst;
  final bool isLast;
  final bool isVisibleLiked;
  final Function onPressed;
  final Function(bool) onLikePressed;
  final Function onSharePressed;

  @override
  _BlogListItemState createState() => _BlogListItemState();
}

class _BlogListItemState extends State<BlogListItem> {
  bool _liked = false;

  @override
  void initState() {
    super.initState();

    _liked = widget.post.liked;
  }

  void _onLikePressed() {
    setState(() {
      _liked = !_liked;

      widget.onLikePressed(_liked);
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemHeight = MediaQuery.of(context).size.height / 4;

    final margin = EdgeInsets.only(
      top: widget.isFirst ? 16.0 : 0.0,
      bottom: widget.isLast ? 16.0 : 0.0,
    );

    return Material(
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          height: itemHeight,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          margin: margin,
          child: Stack(
            children: [
              Positioned.fill(
                child: _buildPicture(widget.post),
              ),
              Positioned.fill(
                child: _buildContent(context),
              ),
            ],
          ),
        ),
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

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spacer(),
          Row(
            children: [
              BubbleText(
                widget.post.kind.getLabel(context),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.post.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: kNormalStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              CircularButton(
                color: Colors.transparent,
                size: 36,
                child: Icon(
                  MdiIcons.shareVariantOutline,
                  color: Colors.white,
                ),
                onPressed: widget.onSharePressed,
              ),
              widget.isVisibleLiked ? CircularButton(
                color: Colors.transparent,
                size: 36,
                child: Icon(
                  _liked ? MdiIcons.heart : MdiIcons.heartOutline,
                  color: Colors.white,
                ),
                onPressed: _onLikePressed,
              ): Container(),
            ],
          ),
        ],
      ),
    );
  }
}
