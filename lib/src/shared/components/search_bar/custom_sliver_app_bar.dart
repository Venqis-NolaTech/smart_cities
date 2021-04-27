import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../generated/i18n.dart';
import '../../../core/util/string_util.dart';
import '../../../shared/app_colors.dart';
import '../../../shared/constant.dart';
import '../../provider/current_user_provider.dart';
import '../../spaces.dart';
import '../firebase_storage_image.dart';
import 'base_app_bar.dart';

class SliverCustomAppBar extends StatelessWidget
    with BaseAppBar
    implements PreferredSizeWidget {
  SliverCustomAppBar({
    Key key,
    this.pinned = false,
    this.snap = false,
    this.floating = false,
    this.hidenAvatar = false,
    this.hidenWelcome = false,
    this.hidenMenu = false,
    this.hidenSearch = false,
    this.searchExpanded = false,
    this.actions,
    this.title,
    this.userProvider,
    this.refresh,
  })  : assert(pinned != null),
        assert(snap != null),
        assert(floating != null),
        assert(hidenAvatar != null),
        assert(hidenWelcome != null),
        assert(hidenMenu != null),
        assert(hidenSearch != null),
        assert(searchExpanded != null),
        super(
          key: key,
        );

  final bool pinned;
  final bool snap;
  final bool floating;
  final bool hidenWelcome;
  final bool hidenMenu;
  final bool hidenAvatar;
  final bool hidenSearch;
  final bool searchExpanded;
  final List<Widget> actions;

  final String title;
  final CurrentUserProvider userProvider;
  final Function refresh;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight * (searchExpanded ? 2.4 : 1.4));

  @override
  Widget build(BuildContext context) {
    final currentScreenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = currentScreenWidth <= ScreenSize.small.width;

    return SliverAppBar(
      elevation: 0.0,
      pinned: pinned,
      snap: snap,
      floating: floating,
      backgroundColor: AppColors.red,
      leading: !hidenAvatar
          ? FirebaseStoreCircularAvatar(
              key: avatarKey,
              referenceUrl: userPhotoUrl,
              padding: EdgeInsets.all(8.0),
            )
          : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildTitle(context, isSmallScreen),
      ),
      actions: _buildActions(context),
      bottom: searchExpanded ? _buildExpandedSearch(context) : null,
    );
  }

  Widget _buildSearch(BuildContext context) {
    return Opacity(
      opacity: 0.4,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Material(
          color: AppColors.backgroundDark.withAlpha(50),
          child: InkWell(
            onTap: () => gotoSearch(context),
            child: SizedBox(
              width: 40.0,
              height: 40.0,
              child: Center(
                child: Icon(
                  MdiIcons.magnify,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return PopupMenuButton(
      icon: Icon(
        MdiIcons.menu,
        color: Colors.black,
      ),
      onSelected: (option) async {
        if (option == AppBarMenuOption.profile) {
          await onMenuSelected(option);

          if (refresh != null) refresh();
        } else {
          onMenuSelected(option);
        }
      },
      itemBuilder: (context) {
        return <PopupMenuEntry<AppBarMenuOption>>[
          PopupMenuItem(
              value: AppBarMenuOption.profile,
              child: Text(S.of(context).profile)),
          PopupMenuItem(
              value: AppBarMenuOption.logout, child: Text(S.of(context).logout))
        ];
      },
    );
  }

  List<Text> _buildTitle(BuildContext context, bool isSmallScreen) {
    final titles = List<Text>();

    if (!hidenWelcome) {
      titles.add(
        Text(
          '${S.of(context).hello},',
          style: isSmallScreen
              ? kTitleStyle.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w300,
                )
              : kMediumTitleStyle.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w300,
                ),
        ),
      );
    }

    titles.add(
      Text(
        title.isNullOrEmpty ? userFullName : title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: isSmallScreen
            ? kTitleStyle.copyWith(
                color: Colors.white,
              )
            : kMediumTitleStyle.copyWith(
                color: Colors.white,
              ),
      ),
    );

    return titles;
  }

  List<Widget> _buildActions(BuildContext context) {
    final actionsBuilded = actions == null ? List<Widget>() : actions;

    if (!searchExpanded && !hidenSearch) {
      actionsBuilded.add(Center(
        child: _buildSearch(context),
      ));
    }

    if (!hidenMenu) {
      actionsBuilded.add(_buildMenu());
    } else {
      actionsBuilded.add(Spaces.horizontalMedium());
    }

    return actionsBuilded;
  }

  Widget _buildExpandedSearch(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: _buildSearchInput(context),
      ),
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
      child: Material(
        color: AppColors.background,
        child: InkWell(
          onTap: () => gotoSearch(context),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  enabled: false,
                  textInputAction: TextInputAction.search,
                  style: kNormalStyle,
                  decoration: InputDecoration(
                    hintText: '${S.of(context).search}...',
                    contentPadding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                    prefixIcon: Icon(MdiIcons.magnify),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
