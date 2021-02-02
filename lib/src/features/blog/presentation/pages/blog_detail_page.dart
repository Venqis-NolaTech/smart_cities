import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/src/features/blog/presentation/widgets/blog_list.dart';
import 'package:share/share.dart';

import '../../../../../generated/i18n.dart';
import '../../../../core/util/string_util.dart';
import '../../../../shared/app_colors.dart';
import '../../../../shared/components/base_view.dart';
import '../../../../shared/components/custom_card.dart';
import '../../../../shared/constant.dart';
import '../../../../shared/map_utils.dart';
import '../../../../shared/provider/view_state.dart';
import '../../../../shared/spaces.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/post_training.dart';
import '../providers/blog_detail_provider.dart';
import '../widgets/blog_detail_header.dart';

class BlogDetailPageArgs {
  final Post post;
  final bool isVisibleLiked;
  BlogDetailPageArgs({@required this.post, @required this.isVisibleLiked});
}

class BlogDetailPage extends StatefulWidget {
  static const id = "blog_detail_page";

  static pushNavigate(BuildContext context, {BlogDetailPageArgs args}) =>
      Navigator.pushNamed(
        context,
        id,
        arguments: args,
      );

  BlogDetailPage({Key key, @required this.args}) : super(key: key);

  final BlogDetailPageArgs args;

  @override
  _BlogDetailPageState createState() => _BlogDetailPageState(args);
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _BlogDetailPageState(this.args);

  final BlogDetailPageArgs args;

  Post _post;

  bool _liked = false;

  bool _isLikedPressed = false;

  @override
  void initState() {
    _post = args.post;
    _liked = _post.liked;

    super.initState();
  }

  void _onSharePost() {
    Share.share(_post?.shareLink);
  }

  void _onLikePressed(BlogDetailProvider provider) async {
    _isLikedPressed = true;

    setState(() {
      _liked = !_liked;
    });

    _post = await provider.likePost(_post.id);
  }

  void _onBackPressed() => Navigator.pop(
        context,
        PostListDetailCallback(
          refresh: _isLikedPressed,
          liked: _liked,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BaseView<BlogDetailProvider>(
      onProviderReady: (provider) => provider.loadData(args.post),
      builder: (context, provider, child) {
        final currentState = provider.currentState;

        final isLoading = currentState is Loading;

        var post;

        if (currentState is Loaded) post = currentState.value;

        return WillPopScope(
          onWillPop: () async {
            _onBackPressed();

            return false;
          },
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: _buildAppBar(provider),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BlogDetailHeader(post: args.post),
                  Visibility(
                    visible: isLoading,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !isLoading,
                    child: _buildBody(post),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BlogDetailProvider provider) {
    return AppBar(
      title: Text(S.of(context).posts),
      backgroundColor: AppColors.red,
      actions: [
        IconButton(
          icon: Icon(
            MdiIcons.shareVariantOutline,
            color: Colors.white,
          ),
          onPressed: _onSharePost,
        ),
        args.isVisibleLiked ? IconButton(
          icon: Icon(
            _liked ? MdiIcons.heart : MdiIcons.heartOutline,
            color: Colors.white,
          ),
          onPressed: () => _onLikePressed(provider),
        ) : Container(),
      ],
    );
  }

  Widget _buildBody(var post) {
    if (post == null) return SizedBox.shrink();

    final kind = _post.kind;

    final children = List<Widget>();

    final postNew = post as Post;

    switch (kind) {
      case PostKind.announcement:
      case PostKind.training:
        {
          final postTraining = post as PostTraining;

          children.addAll([
            ..._buildAbout(postNew),
            Spaces.verticalLarge(),
            ..._buildYouLearn(postTraining),
            Spaces.verticalLarge(),
            ..._buildInscription(postTraining),
            Spaces.verticalLarge(),
            _buildTableContent(postTraining),
            Spaces.verticalLarge(),
          ]);
        }

        break;
      case PostKind.news:
      default:
        children.addAll([
          _buildNewsContent(postNew),
          Spaces.verticalMedium(),
        ]);
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _buildNewsContent(Post post) {
    return HtmlWidget(post.contentFormat);
  }

  List<Widget> _buildAbout(Post post) {
    return [
      Text(
        'Acerca de este curso',
        style: kTitleStyle,
      ),
      Spaces.verticalSmall(),
      HtmlWidget(post.contentFormat),
    ];
  }

  List<Widget> _buildYouLearn(PostTraining postTraining) {
    return [
      Text(
        '¿Qué aprenderás?',
        style: kTitleStyle,
      ),
      Spaces.verticalSmall(),
      HtmlWidget(postTraining.youLearnFormat),
    ];
  }

  List<Widget> _buildInscription(PostTraining postTraining) {
    return [
      Text(
        'Inscripción',
        style: kTitleStyle,
      ),
      Spaces.verticalSmall(),
      HtmlWidget(postTraining.inscriptionFormat),
    ];
  }

  Widget _buildTableContent(PostTraining postTraining) {
    final kind = postTraining.kind;

    final facilitadorLabel = S.of(context).facilitador;
    final startDateLabel = S.of(context).startDate;
    final durationLabel = kind == PostKind.training
        ? S.of(context).duration
        : S.of(context).errollmentPeriod;
    final scheduleLabel = S.of(context).schedule;
    final costLabel = S.of(context).cost;
    final areaLabel = S.of(context).area;
    final courseLabel = kind == PostKind.training
        ? S.of(context).courseType
        : S.of(context).announcementType;
    final addressLabel = S.of(context).address;

    final values = {
      facilitadorLabel: postTraining?.facilitator,
      startDateLabel: postTraining?.startDate?.toDateFormated(
        DateFormat.yMMMMd(),
      ),
      durationLabel: postTraining?.duration?.toLowerCase(),
      scheduleLabel: postTraining.schedule,
      costLabel: postTraining.cost,
      areaLabel: postTraining.area,
      courseLabel: postTraining.course,
      addressLabel: postTraining.address,
    }.entries.toList();

    final isValidLocation =
        postTraining.latitude != null && postTraining.longitude != null;

    return CustomCard(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      backgroundColor: Colors.grey.shade200,
      child: ListView.separated(
        shrinkWrap: true,
        primary: false,
        itemCount: values.length,
        itemBuilder: (context, index) {
          final item = values[index];

          return Row(
            children: [
              Expanded(
                  child: Text(
                '${item.key}:',
                style: kNormalStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              )),
              Expanded(
                child: item.key == addressLabel
                    ? Wrap(
                        direction: Axis.vertical,
                        children: [
                          Text(
                            item.value,
                            style: kNormalStyle,
                          ),
                          InkWell(
                            onTap: isValidLocation
                                ? () => MapsUtils.launchOnMaps(
                                      LatLng(
                                        postTraining.latitude,
                                        postTraining.longitude,
                                      ),
                                    )
                                : null,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                S.of(context).getDirection,
                                textAlign: TextAlign.right,
                                style: kNormalStyle.copyWith(
                                  fontWeight: isValidLocation
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isValidLocation
                                      ? AppColors.blueLight
                                      : Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Text(
                        item.value,
                        style: kNormalStyle,
                      ),
              ),
            ],
          );
        },
        separatorBuilder: (_, __) => Divider(),
      ),
    );
  }
}
