import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/auth/presentation/phone_number/pages/phone_number_page.dart';
import 'package:smart_cities/src/features/auth/presentation/register/pages/register_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';

class tittleAppBarLogin extends StatelessWidget {
  final Function onLogin;
  final Function onRegister;


  const tittleAppBarLogin({
    Key key, this.onLogin, this.onRegister,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlatButton(
            onPressed: onRegister,
            child: Text(S.of(context).register,
                style: TextStyle(
                    color: AppColors.white.withOpacity(0.5),
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold)
            )
        ),
        Expanded(
            child: FlatButton(
                onPressed: onLogin,
                child: Text(S.of(context).login,
                    style: TextStyle(
                        color: AppColors.white,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold)
                )
            )
        ),
      ],
    );
  }
}
