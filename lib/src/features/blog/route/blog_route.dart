import '../presentation/pages/blog_detail_page.dart';

import '../presentation/pages/blog_page.dart';

import '../../../shared/components/app_router.dart';

initBlog() {
  AppRouter.appRouter
    ..define(
      routePath: BlogPage.id,
      handler: AppRouteHandler(handlerFunc: (arguments) {
        final args = arguments as BlogPageArgs ?? BlogPageArgs();

        return BlogPage(args: args);
      }),
    )
    ..define(
      routePath: BlogDetailPage.id,
      handler: AppRouteHandler(handlerFunc: (arguments) {
        final args = arguments as BlogDetailPageArgs;

        return BlogDetailPage(args: args);
      }),
    );
}
