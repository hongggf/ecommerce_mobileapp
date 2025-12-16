import 'package:ecommerce_urban/modules/user/user_cart/user_cart_view.dart';
import 'package:ecommerce_urban/modules/user/user_checkout/user_checkout_view.dart';
import 'package:ecommerce_urban/modules/user/user_main/user_main_view.dart';
import 'package:ecommerce_urban/modules/user/user_profile/user_profile_view.dart';
import 'package:ecommerce_urban/modules/user/user_search/user_search_view.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';

class UserRoute {

  static final pages = [

    /// User Main
    GetPage(
      name: AppRoutes.userMain,
      page: () => UserMainView(),
    ),
    GetPage(
      name: AppRoutes.userSearch,
      page: () => UserSearchView(),
    ),
    GetPage(
      name: AppRoutes.userProfile,
      page: () => UserProfileView(),
    ),
    GetPage(
      name: AppRoutes.userCart,
      page: () => UserCartView()
    ),
    GetPage(
        name: AppRoutes.userCheckout,
        page: () => UserCheckoutView()
    ),
  ];

}