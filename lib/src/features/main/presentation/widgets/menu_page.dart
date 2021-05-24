import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:smart_cities/src/features/auth/presentation/profile/providers/profile_provider.dart';
import 'package:smart_cities/src/features/main/presentation/widgets/menu_content.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';




class MenuPage extends StatelessWidget {
  final Function onFunctionPickup;
  final Function onFunctionPayment;

  MenuPage({Key key, @required this.onFunctionPickup, this.onFunctionPayment}) : super(key: key);


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
            body: Stack(
              children: [
                _buildBackground(context, screenHeight),

                _buildContent(provider, screenHeight),
              ],
            ),
          ),
        );
      },
    );
  }



  Widget _buildBackground(BuildContext context, double screenHeight) {
    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(AppImagePaths.backgroundProfile), fit: BoxFit.fill),
      ),
      // child: Logo(),
    );
  }


  Widget _buildContent(ProfileProvider provider, double screenHeight) {
    return Container(
      //height: screenHeight,
      child: MenuContent(
        provider: provider,
        onFunctionPickup: onFunctionPickup,
        onFunctionPayment: onFunctionPayment,
      ),
    );
  }
}
