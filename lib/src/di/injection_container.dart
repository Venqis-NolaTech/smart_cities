import 'package:get_it/get_it.dart';

import '../features/auth/di/auth_di.dart';
import '../features/blog/di/blog_di.dart';
import '../features/resports/di/report_di.dart';
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

  await initExternal(sl);
}
