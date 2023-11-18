//app file

import 'package:chatify_web/screens/dashboard_pages/index/index.dart';
import 'package:chatify_web/widgets/background_list.dart';
import '../config.dart';
import 'route_name.dart';

RouteName _routeName = RouteName();

class AppRoute {
  final List<GetPage> getPages = [

    GetPage(name: _routeName.dashboard, page: () =>const  IndexLayout()),
    GetPage(name: _routeName.backgroundList, page: () => const BackgroundList()),

  ];
}
