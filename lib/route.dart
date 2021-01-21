import 'package:smart_cities/src/features/auth/presentation/selected_municipality/page/selected_municipality_page.dart';
import 'package:smart_cities/src/features/auth/presentation/validate/page/validate_account_page.dart';
import 'package:smart_cities/src/features/blog/presentation/pages/blog_detail_page.dart';
import 'package:smart_cities/src/features/blog/presentation/pages/blog_page.dart';
import 'package:smart_cities/src/features/main/presentation/pages/main_page.dart';
import 'package:smart_cities/src/features/resports/domain/entities/report.dart';
import 'package:smart_cities/src/features/resports/presentation/filter_report/page/filter_page.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/pages/general_report.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/pages/selected_neighborhood_page.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/pages/selected_sector_page.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/providers/create_report_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/report_comments/pages/report_comments_page.dart';
import 'package:smart_cities/src/features/resports/presentation/report_details/pages/report_details_page.dart';

import 'src/features/auth/presentation/base/providers/phone_number_auth_provider.dart';
import 'src/features/auth/presentation/phone_number/pages/phone_number_page.dart';
import 'src/features/auth/presentation/pre_login/page/pre_login.dart';
import 'src/features/auth/presentation/register/pages/register_page.dart';
import 'src/features/auth/presentation/verify_code/pages/verify_code_page.dart';
import 'src/features/auth/presentation/verify_code/providers/verify_code_provider.dart';
import 'src/features/welcome/presentation/page/welcome_page.dart';
import 'src/shared/components/app_router.dart';


class AppRoute {
  static init() {
    AppRouter.appRouter
      ..define(
        routePath: WelcomePage.id,
        handler: AppRouteHandler(handlerFunc: (arguments) => WelcomePage()),
      )
      ..define(
        routePath: PreLogin.id,
        handler: AppRouteHandler(handlerFunc: (arguments) => PreLogin()),
      )
      ..define(
        routePath: RegisterPage.id,
        handler: AppRouteHandler(handlerFunc: (arguments) => RegisterPage()),
      )
      ..define(
        routePath: PhoneNumberPage.id,
        handler: AppRouteHandler(handlerFunc: (arguments) {
          final authMethod = arguments as AuthMethod;
          return PhoneNumberPage(authMethod: authMethod);
        }),
      )
      ..define(
        routePath: VerifyCodePage.id,
        handler: AppRouteHandler(handlerFunc: (arguments) {
          final params = arguments as VerifyCodeParams;

          return VerifyCodePage(params: params);
        }),
      )
      ..define(
        routePath: SelectedMunicipalityPage.id,
        handler: AppRouteHandler(handlerFunc: (arguments) => SelectedMunicipalityPage()),
      )
      ..define(
        routePath: MainPage.id,
        handler: AppRouteHandler(handlerFunc: (arguments) => MainPage()),
      )
      ..define(
        routePath: NewReport.id,
        handler: AppRouteHandler(handlerFunc: (arguments) => NewReport()),
      )
      ..define(
        routePath: ValidateAccountPage.id,
        handler: AppRouteHandler(handlerFunc: (arguments) => ValidateAccountPage()),
      )
      ..define(
        routePath: SelectedSectorPage.id,
        handler: AppRouteHandler(handlerFunc: (arguments) {
          final provider = arguments as CreateReportProvider;
          return SelectedSectorPage(provider: provider);
        }),
      )
      ..define(
        routePath: SelectedNeighborhoodPage.id,
        handler: AppRouteHandler(handlerFunc: (arguments) {
          final provider = arguments as CreateReportProvider;
          return SelectedNeighborhoodPage(provider: provider);
        }),
      )
      ..define(
        routePath: ReportDetailsPage.id,
        handler: AppRouteHandler(handlerFunc: (arguments) {
          final report = arguments as Report;

          return ReportDetailsPage(report: report);
        }),
      )
      ..define(
        routePath: ReportCommentsPage.id,
        handler: AppRouteHandler(handlerFunc: (arguments) {
          final report = arguments as Report;

          return ReportCommentsPage(report: report);
        }),
      )
      ..define(
        routePath: BlogPage.id,
        handler: AppRouteHandler(handlerFunc: (arguments) {
          final args = arguments as BlogPageArgs ?? BlogPageArgs();

          return BlogPage(args: args);
        }),
      )
      ..define(
        routePath: BlogDetailPage.id,
        handler: AppRouteHandler(handlerFunc: (arguments){
          final args = arguments as BlogDetailPageArgs;

          return BlogDetailPage(args: args);
        })
      )
      ..define(
        routePath: FilterReportPage.id,
        handler: AppRouteHandler(handlerFunc: (arguments) {
          //final provider = arguments as GeneralReportProvider;
          return FilterReportPage();
        }),
      );

  }




}
