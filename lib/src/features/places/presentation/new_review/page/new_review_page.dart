import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/features/places/presentation/new_review/provider/new_review_provider.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/components/info_alert_dialog.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/rating_bar_card.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/place_title_header.dart';

class NewReviewParams{
  final Place place;
  final double ranting;

  NewReviewParams({this.place, this.ranting});
}

class NewReviewPage extends StatelessWidget {
  static const id = "new_review_page";
  NewReviewPage({Key key, this.params}) : super(key: key);

  final NewReviewParams params;
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<NewReviewProvider>(builder: (context, provider, child) {
      final currentState = provider.currentState;

      return ModalProgressHUD(
        inAsyncCall: currentState is Loading,
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).qualify),
            centerTitle: true,
            backgroundColor: AppColors.red,
          ),
          body: SingleChildScrollView(
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spaces.verticalMedium(),
                      Container(
                          padding: EdgeInsets.only(left: 24.0, right: 24.0),
                          child: PlaceTitleHeader(place: params.place)),
                      Container(
                          padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 15),
                          child: RantingBarCard(
                              subtitle: S.of(context).tapStart,
                              initialRating: params.ranting ?? 5,
                              onRatingUpdate: (ranting) =>
                                  provider.qualification = ranting,
                              ignoreGestures: false)),
                    _buildForm(context, provider),
                    btnIniciar(context, provider)
            ]),
          ),
        ),
      );
    });
  }

  Widget _buildForm(BuildContext context, NewReviewProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Text(S.of(context).title,
                      style: kTitleStyle.copyWith(
                          color: AppColors.blueBtnRegister)),
                ],
              ),
              TextFormField(
                maxLines: 1,
                onChanged: (value) {
                  provider.title = value;
                },
                decoration: InputDecoration(
                    border: InputBorder.none),
                textInputAction: TextInputAction.next,
                style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister),
              ),
              Divider(),
              Spaces.verticalSmall(),
              Row(
                children: [
                  Text(S.of(context).review,
                      style: kTitleStyle.copyWith(
                          color: AppColors.blueBtnRegister)),
                ],
              ),
              Spaces.verticalLarge(),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.greyButtom.withOpacity(0.2))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    maxLines: 10,
                    maxLength: 4000,
                    onChanged: (value) {
                      provider.comment = value;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      //hintText: S.of(context).exampleDescription
                    ),
                    textInputAction: TextInputAction.next,
                    style:
                        kTitleStyle.copyWith(color: AppColors.blueBtnRegister),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget btnIniciar(BuildContext context, NewReviewProvider provider) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: RoundedButton(
            color: AppColors.blueBtnRegister,
            title: S.of(context).send.toUpperCase(),
            style: kTitleStyle.copyWith(
                fontWeight: FontWeight.bold, color: AppColors.white),
            onPressed: () async {
              if (provider.validate()) {
                await provider.submitData(params.place.id);
                _process(provider, context);

              } else
                showDialog(
                  context: context,
                  builder: (context) {
                    return InfoAlertDialog(
                      textAlign: TextAlign.center,
                      message: S.of(context).completeData,
                      onConfirm: () {},
                    );
                  },
                );
            }));
  }

  void _process(NewReviewProvider provider, BuildContext context) {

    final currentState = provider.currentState;

    Widget image =  Image.asset(AppImagePaths.createComment, height: 120);
    String title = S.of(context).reviewCreatedSuccessMessage;
    bool sucesss = true;

    if (currentState is Error) {
      title = S.of(context).unexpectedErrorMessage;
      sucesss = false;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return InfoAlertDialog(
            image: sucesss ? image : Container(height: 120),
            title: title,
            message: '',
            onConfirm: sucesss
                ? () {
              Navigator.pop(context, true);
            }
                : null, 
                
          );
        });
  }
}
