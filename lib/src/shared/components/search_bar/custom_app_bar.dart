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

class CustomAppBar extends StatelessWidget
    with BaseAppBar
    implements PreferredSizeWidget {
  CustomAppBar({
    Key key,
    this.title,
    this.hidenAvatar = false,
    this.hidenActions = false,
    this.hidenMenu = false,
    this.hidenSearch = false,
    this.searchExpanded = false,
    this.backgroundColor = AppColors.backgroundLight,
    this.userProvider,
    this.actions,
    this.refresh,
  })  : assert(hidenAvatar != null),
        assert(hidenMenu != null),
        assert(hidenSearch != null),
        assert(searchExpanded != null),
        super(key: key);

  final bool hidenAvatar;
  final String title;
  final bool hidenActions;
  final bool hidenMenu;
  final bool hidenSearch;
  final bool searchExpanded;
  final Color backgroundColor;
  final CurrentUserProvider userProvider;
  final Function refresh;
  final List<Widget> actions;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight * (searchExpanded ? 2.4 : 1.4));

  @override
  Widget build(BuildContext context) {
    final currentScreenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = currentScreenWidth <= ScreenSize.small.width;

    return AppBar(
      elevation: 0.0,
      backgroundColor: backgroundColor,
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
      actions: !hidenActions ? _buildActions(context) : null,
      bottom: searchExpanded ? _buildExpandedSearch(context) : null,
    );
  }

  Widget _buildSearch(BuildContext context) {
    return ClipRRect(
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
                color: AppColors.primaryText,
                size: 20,
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
            child: Text(S.of(context).profile),
          ),
          PopupMenuItem(
            value: AppBarMenuOption.logout,
            child: Text(S.of(context).logout),
          )
        ];
      },
    );
  }

  List<Text> _buildTitle(BuildContext context, bool isSmallScreen) {
    final titleBuilded =
        title.isNullOrEmpty ? '${S.of(context).hello},' : title;

    final subtitle = title.isNullOrEmpty ? userFullName : null;

    final titles = List<Text>();

    if (titleBuilded.isNotNullOrNotEmpty) {
      final fontWeight =
          subtitle.isNotNullOrNotEmpty ? FontWeight.w300 : FontWeight.bold;

      titles.add(
        Text(
          titleBuilded ?? "",
          style: isSmallScreen
              ? kTitleStyle.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: fontWeight,
                )
              : kMediumTitleStyle.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: fontWeight,
                ),
        ),
      );
    }

    if (subtitle.isNotNullOrNotEmpty) {
      titles.add(
        Text(
          subtitle ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: isSmallScreen
              ? kTitleStyle.copyWith(
                  color: Colors.black,
                )
              : kMediumTitleStyle.copyWith(
                  color: Colors.black,
                ),
        ),
      );
    }

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
      child: _buildSearchInput(context),
      preferredSize: Size.fromHeight(kToolbarHeight),
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
