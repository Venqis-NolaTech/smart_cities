import 'package:smart_cities/src/shared/components/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/i18n.dart';
import 'src/core/entities/catalog_item.dart';
import 'src/features/auth/domain/entities/user.dart';
import 'src/features/splash/presentation/pages/splash_page.dart';
import 'src/shared/app_colors.dart';


Map<String, dynamic> remoteParams;
User currentUser;
CatalogItem municipalityOptional;
Map<String, String> authHeaders;

final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        primaryColor: AppColors.blueBtnRegister,
        primaryColorDark: AppColors.blueDark,
        accentColor: AppColors.blueBtnRegister,
        backgroundColor: AppColors.background,
        toggleableActiveColor: AppColors.blueBtnRegister,
        appBarTheme: AppBarTheme(
          color: AppColors.red,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: AppColors.blueBtnRegister,
          unselectedLabelColor: AppColors.blueBtnRegister.withAlpha(100),
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 2.0,
              color: AppColors.blueBtnRegister,
            ),
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.black.withOpacity(0),
        ),
      ),
      home: SplashPage(), //TODO
      onGenerateRoute: (settings) => AppRouter.appRouter.matchRoute(
        settings.name,
        routeSettings: settings,
      ),
    );
  }
}
