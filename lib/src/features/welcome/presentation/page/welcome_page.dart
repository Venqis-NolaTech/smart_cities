import 'package:smart_cities/src/features/auth/presentation/sign_in/pages/sign_in_page.dart';
import 'package:smart_cities/src/features/welcome/presentation/widget/step_view.dart';
import 'package:smart_cities/src/features/welcome/presentation/widget/welcome_content.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import '../../../../../generated/i18n.dart';
import '../../../../shared/app_colors.dart';
import '../../../../shared/app_images.dart';

class WelcomePage extends StatefulWidget {
  static const id = "welcome_page";

  WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _stepController = PageController();
  final length= 4;
  int _stepIndex = 0;
  int _previewStepIndex = 0;

  int get stepIndex => _stepIndex;



  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final steps = _generateViews();

    return Scaffold(
      backgroundColor: AppColors.white,
      body:   Container(
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Expanded(
              child: Container(
                color: Colors.white,
                child: WelcomeContent(
                  steps: steps,
                  controller: _stepController,
                  stepOnChanged: (step) => _stepOnChanged(step),
                ),
              ),
            ),

            Container(
              color: Colors.white,
              child: DotsIndicator(
                dotsCount: steps.length,
                position: _stepIndex.toDouble(),
                decorator: DotsDecorator(
                  activeColor: AppColors.blueBtnRegister,
                ),
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 60),
          curve: Curves.fastOutSlowIn,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              FlatButton(onPressed: _onPressSkip, child: Text(S.of(context).skip, style: TextStyle(color: AppColors.primaryTextLight, fontFamily: 'Roboto', fontWeight: FontWeight.w300))),
              Expanded(child: SizedBox(width: 4.0),),
              FlatButton(onPressed: _onPressNext, child: Text(S.of(context).next, style: TextStyle(color: AppColors.red, fontFamily: 'Roboto', fontWeight: FontWeight.bold),)),
            ],
          ),
        ),
      ),


    );
  }


  void _stepOnChanged(int step) {

    _stepIndex=step;
    setState(() {

    });

  }

  List<Widget> _generateViews() {


    return List<Widget>.generate(length, (index) {
      switch(index){
        case 0:
          return StepView(image:  AppImages.step1, text: S.of(context).textWelcome);
        case 1:
          return StepView(
              image: AppImages.step2,
              icon: Image.asset(
                AppImagePaths.iconPay,
                fit: BoxFit.contain,
                height: 90,
              ),
              text: S.of(context).textPay,
              tittle: S.of(context).pay.toUpperCase());
        case 2:
          return StepView(
              image: AppImages.step3,
              icon: Image.asset(
                AppImagePaths.iconCar,
                fit: BoxFit.contain,
                height: 90,
              ),
              text: S.of(context).textPickup,
              tittle: S.of(context).pickup.toUpperCase());
        case 3:
          return StepView(
              image: AppImages.step4,
              icon: Image.asset(
                AppImagePaths.iconReports,
                fit: BoxFit.contain,
                height: 90,
              ),
              text: S.of(context).textReport,
              tittle: S.of(context).report.toUpperCase());
        default:
          return Container();
      }
    });
  }


  @override
  void dispose() {
    _stepController?.dispose();
    super.dispose();
  }


  void _onPressSkip() {
    Navigator.pushReplacementNamed(context, SignInPage.id);
  }

  void _onPressNext() {
    if (_stepController.page.toInt() < length - 1) {
      _stepController.nextPage(
        duration: Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
      );
    } else if (_stepIndex == (length- 1)) {
      Navigator.pushReplacementNamed(context, SignInPage.id);
    }
  }

}