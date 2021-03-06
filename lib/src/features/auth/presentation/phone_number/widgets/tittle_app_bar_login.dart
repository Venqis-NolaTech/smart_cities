import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
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
                    color: onRegister !=null ? AppColors.white.withOpacity(0.5) :  AppColors.white,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold)
            )
        ),
        Expanded(
            child: FlatButton(
                onPressed: onLogin,
                child: Text(S.of(context).login,
                    style: TextStyle(
                        color: onLogin !=null ? AppColors.white.withOpacity(0.5) :  AppColors.white,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold)
                )
            )
        ),
      ],
    );
  }
}
