import 'package:meta/meta.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/home/presentation/provider/home_provider.dart';
import 'package:smart_cities/src/features/home/presentation/widgets/news_widget.dart';
import 'package:smart_cities/src/features/home/presentation/widgets/payment_widget.dart';
import 'package:smart_cities/src/features/home/presentation/widgets/report_widget.dart';
import 'package:smart_cities/src/features/home/presentation/widgets/route_widget.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import 'package:smart_cities/app.dart';



class HomePage extends StatelessWidget {
  final Function toProfile;
  final Function toRoute;
  final Function moveToPayment;

  HomePage({Key key, @required this.toProfile, @required this.toRoute, this.moveToPayment}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final screenWidth= MediaQuery.of(context).size.width;

    return BaseView<HomeProvider>(
      onProviderReady: (provider) => provider.loadData(),
      builder: (context, provider,child){
        return Stack(
          children: [

            Positioned(
              top: -120,
              right: -30,
              left: -30,
              child: Image.asset(AppImagePaths.ellipseHome, fit: BoxFit.cover),
            ),

            Container(
              width: double.infinity,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Spaces.verticalMedium(),
                        Row(
                          children: [
                            Text(
                              currentUser?.firstName  ?? '¡Hola!',
                              textAlign: TextAlign.left,
                              style: kBigTitleStyle.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Spaces.verticalSmall(),
                        Row(
                          children: [
                            Text(
                              'Este es tu acceso a tu municipio',
                              textAlign: TextAlign.left,
                              style: kNormalStyle.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Spaces.verticalMedium(),
                        Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [

                              Image.asset(AppImagePaths.photo, width: double.infinity, fit: BoxFit.fill),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Una vuelta por Antón',
                                          textAlign: TextAlign.left,
                                          style: kTitleStyle.copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '24 lugares esenciales',
                                          textAlign: TextAlign.left,
                                          style: kSmallTextStyle.copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Row(
                                children: [
                                  Expanded(child: SizedBox()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                    child: Image.asset(AppImagePaths.iconMap),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Spaces.verticalMedium(),

                        PaymentWidget(moveToPayment: moveToPayment),
                        Spaces.verticalMedium(),
                        Row(
                          children: [
                            Expanded(child: ReportWidget(provider: provider)),
                            Expanded(child: RouteWidget(
                              provider: provider,
                              onAddSector: toProfile,
                              onSelectedSector: toRoute) ),
                          ],
                        ),
                        Spaces.verticalMedium(),
                        FeatureNews(),
                        Spaces.verticalMedium(),
                        Spaces.verticalMedium(),
                      ],
                    ),
                  ),
                ),
              ),
            )




          ],
        );
      },
    );




  }





}
