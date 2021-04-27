import 'package:flutter/material.dart';

import '../../../../app.dart';
import '../../../core/util/string_util.dart';
import '../../../di/injection_container.dart' as di;
import '../../../features/auth/presentation/profile/pages/profile_page.dart';
import '../../../features/welcome/presentation/page/welcome_page.dart';
import '../../provider/current_user_provider.dart';

enum AppBarMenuOption {
  profile,
  logout,
}

typedef OnMenuSelected = Future Function(AppBarMenuOption);

mixin BaseAppBar {
  @protected
  final avatarKey = GlobalKey();

  String get title;
  bool get hidenAvatar;
  bool get searchExpanded;
  CurrentUserProvider get userProvider;

  String get userPhotoUrl => currentUser?.photoURL ?? "";

  String get userFullName {
    if (currentUser?.nickName?.isNotNullOrNotEmpty ?? false) {
      return currentUser?.nickName ?? "";
    } else {
      return currentUser?.fullName ?? "";
    }
  }

  Future onMenuSelected(AppBarMenuOption option) async {
    switch (option) {
      case AppBarMenuOption.profile:
        await _gotoProfile();

        break;
      case AppBarMenuOption.logout:
        _logout();
        break;
    }
  }

  @protected
  Future gotoSearch(BuildContext context) async {
    //di.sl<MainNavigatorService>().pushNamed(SearchPage.id);
  }

  Future _gotoProfile() async {
    //ProfilePage.pushNavigate(context);
  }

  void _logout() async {
    await userProvider.logout();

    /*di.sl<MainNavigatorService>().pushNamedAndRemoveUntil(
          WelcomePage.id,
          (Route<dynamic> route) => false,
        );*/
  }
}
