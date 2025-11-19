// import 'package:carousel_slider/carousel_slider.dart';
// // import 'package:ecommerce_urban/modules/home/controller/slider_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//
// class SliderWidget extends StatelessWidget {
//   // final SliderController sliderController = Get.put(SliderController());
//
//   final List<Widget> silderIMG = [
//     Image.asset("assets/images/slider1.jpg", fit: BoxFit.cover),
//     Image.asset("assets/images/slider2.jpg", fit: BoxFit.cover),
//   ];
//
//   SliderWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         CarouselSlider(
//           options: CarouselOptions(
//             height: 220,
//             autoPlay: true,
//             enlargeCenterPage: true,
//             viewportFraction: 1,
//             autoPlayInterval: const Duration(seconds: 4),
//             onPageChanged: (index, reason) {
//               sliderController.currentIndex.value = index;
//             },
//           ),
//           items: silderIMG.map((i) {
//             return Builder(
//               builder: (BuildContext context) {
//                 return ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     color: Colors.amber,
//                     child: i,
//                   ),
//                 );
//               },
//             );
//           }).toList(),
//         ),
//
//         // ✅ Indicator
//         Positioned(
//           bottom: 10,
//           left: MediaQuery.of(context).size.width * 0.4,
//           child: Obx(() => AnimatedSmoothIndicator(
//                 activeIndex: sliderController.currentIndex.value,
//                 count: silderIMG.length,
//                 effect: const ExpandingDotsEffect(
//                   dotWidth: 10,
//                   dotHeight: 10,
//                   activeDotColor: Colors.white,
//                   dotColor: Colors.black54,
//                 ),
//               )),
//         ),
//       ],
//     );
//   }
// }
