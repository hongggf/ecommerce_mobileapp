import 'package:ecommerce_urban/modules/admin/admin_route.dart';
import 'package:ecommerce_urban/modules/auth/auth_route.dart';

class AppPages {
  static final pages = [
    ...AuthRoute.pages,
    ...AdminRoute.pages
  ];
}