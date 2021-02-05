import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/providers/profile_provider.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/firebase_storage_image.dart';
import 'package:smart_cities/src/shared/image_utils.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';


class UserPhoto extends StatelessWidget {
  final ProfileProvider provider;

  const UserPhoto({Key key, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final visible = provider.profileState is Loaded ||
        provider.profileState is Idle;

    return Container(
      padding: EdgeInsets.only(top: 16.0),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          Container(
            width: 116,
            height: 116,
            padding: EdgeInsets.all(8.0),
            child: ClipOval(
              child: Visibility(
                visible: visible,
                child: FirebaseStorageImage(
                  referenceUrl: provider?.user?.photoURL,
                  fallbackWidget: CircularProgressIndicator(),
                  errorWidget: AppImages.defaultImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          FloatingActionButton(
              mini: true,
              backgroundColor: AppColors.greyButtom,
              child: Icon(Icons.add),
              onPressed: () => ImageUtil.showPhotoDialog(
                context, (image) {
                if (image != null) provider.photo = image;
                provider.state = Loaded();
              },
                loadingBuilder:  () => provider.state = Loading(),
              )
          ),
        ],
      ),
    );
  }
}
