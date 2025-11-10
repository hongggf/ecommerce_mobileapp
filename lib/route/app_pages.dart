import 'package:ecommerce_urban/app/modules/auth/routes/auth_routes.dart';
import 'package:ecommerce_urban/app/modules/bottom_nav/bottom_nav_route.dart';
import 'package:ecommerce_urban/app/modules/home/home_routes.dart';
import 'package:ecommerce_urban/app/modules/splash_screen/routes/slash_screen_routes.dart';
import 'package:ecommerce_urban/app/modules/profile/profile_routes.dart';
import 'package:ecommerce_urban/app/modules/wishlist/wishlist_routes.dart';

class AppPages {
  static final pages = [
    ...splashRoutes,
    ...authRoutes,
    ...homeRoutes,
    ...profileRoutes,
    ...wishlistRoutes,
    ...bottomNavRoute
  ];
}
