import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/home/di/home_di.dart';
import 'package:smart_cities/src/features/payments/di/payments_module.dart';
import 'package:smart_cities/src/features/places/di/places_di.dart';
import 'package:smart_cities/src/features/route/di/route_di.dart';
import 'package:smart_cities/src/features/surveys/di/surveys_di.dart';

import '../features/auth/di/auth_di.dart';
import '../features/blog/di/blog_di.dart';
import '../features/reports/di/report_di.dart';
import 'core_module.dart';
import 'external_module.dart';
import 'global_module.dart';

final sl = GetIt.instance;

init() async {
  initCore(sl);
  initGlobal(sl);

  // features.
  initAuthModule(sl);
  initReportModule(sl);
  initBlogModule(sl);
  initPlacesModule(sl);
  initRouteModule(sl);

  initHomeModule(sl);
  initPaymentsModule(sl);
  initSurveysModule(sl);

  await initExternal(sl);
}
