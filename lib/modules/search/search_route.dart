import 'package:ecommerce_urban/modules/search/search_binding.dart';
import 'package:ecommerce_urban/modules/search/search_screen.dart';
import 'package:get/get.dart';

final searchRoute=[
  GetPage(
    name: '/search',
    page: () => const SearchScreen(),
    binding: SearchBinding(),
  ),
];