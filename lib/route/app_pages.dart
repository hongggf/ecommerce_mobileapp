import 'package:ecommerce_urban/modules/admin/admin_main/admin_main_route.dart';
import 'package:ecommerce_urban/modules/auth/auth_route.dart';

class AppPages {
  static final pages = [
    ...AuthRoute.pages,
    ...AdminMainRoute.pages,
  ];
}
