import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/app_images.dart';
import '../../../../../shared/components/base_view.dart';
import '../../../../../shared/provider/view_state.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_content.dart';

class ProfilePage extends StatelessWidget {
  static const id = "profile_page";

  ProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height -
        (kToolbarHeight + kBottomNavigationBarHeight * 1.5);

    return BaseView<ProfileProvider>(
      onProviderReady: (provider) => provider.getProfile(),
      builder: (context, provider, child) {
        final isLoading = provider.currentState is Loading ||
            provider.profileState is Loading;

        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).menuProfileTitle),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  _buildBackground(context, screenHeight),
                  _buildContent(provider, screenHeight),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackground(BuildContext context, double screenHeight) {
    return Container(
      height: screenHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Image.asset(
              AppImagePaths.defaultImage,
              fit: BoxFit.cover,
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              color: AppColors.midnightBlue70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ProfileProvider provider, double screenHeight) {
    return Container(
      height: screenHeight,
      child: ProfileContent(
        provider: provider,
      ),
    );
  }
}
