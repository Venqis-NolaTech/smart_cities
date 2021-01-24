import 'package:smart_cities/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'app.dart';
import 'src/di/injection_container.dart' as di;
import 'src/core/util/flavor_config.dart';

void main() async {
  final flavor = Flavor.PROD;

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  await Firebase.initializeApp();

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // Initialize FlutterDownloader
  await FlutterDownloader.initialize(debug: false);

  // load enviroment variables.
  await FlavorConfig.init(flavor);

  // init dependency injection.
  await di.init();

  // init routes.
  AppRoute.init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(App());
  });
}
