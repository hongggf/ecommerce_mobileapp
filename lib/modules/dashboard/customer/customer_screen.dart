import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_urban/app/constants/app_fontsizes.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/widgets/category_list_widget.dart';
import 'package:ecommerce_urban/app/widgets/product_card_widget.dart';
import 'package:ecommerce_urban/app/widgets/search_widget.dart';
import 'package:ecommerce_urban/app/widgets/title_widget.dart';
import 'package:ecommerce_urban/modules/bottom_nav/bottom_controller.dart';
import 'package:ecommerce_urban/modules/auth/auth_controller.dart';
import 'package:ecommerce_urban/modules/dashboard/customer/customer_controller.dart';
import 'package:ecommerce_urban/modules/product/product/productList_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final List<Widget> silderIMG = [
    Image.asset("assets/images/slider1.jpg", fit: BoxFit.cover),
    Image.asset("assets/images/slider2.jpg", fit: BoxFit.cover),
  ];

  final CustomerController customerController = Get.find<CustomerController>();
  final BottomNavController bottomController = Get.find<BottomNavController>();
  final AuthController auth = Get.find<AuthController>();

  var currentIndex = 0.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Mart'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.paddingS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchCardNavigation(),
            SizedBox(height: AppSpacing.paddingS),
            _SliderWidget(),
            SizedBox(height: AppSpacing.paddingL),
            _categorySection(),
            SizedBox(height: AppSpacing.paddingL),
            _popularProductSection(),
          ],
        ),
      ),
    );
  }

  Widget _categorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(
          title: "Category",
          icon: Icons.arrow_forward_rounded,
          onIconTap: () {},
        ),
        CategoryListWidget(
          categories: [
            Category(name: "Shoes"),
            Category(name: "Bags"),
            Category(name: "Watches"),
          ],
          selectedIndex: 0,
          onCategoryTap: (index) {
            print("Selected category index: $index");
          },
        ),
      ],
    );
  }

  Widget _popularProductSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Popular Products",
              style: TextStyle(
                fontSize: AppFontSize.titleLarge,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () => {
                Get.to(() => ProductListScreen(
                      categoryName: "All Products",
                    )),
              },
              child: Text("see all",
                  style: TextStyle(
                    fontSize: AppFontSize.bodyLarge,
                    color: Colors.blue,
                  )),
            ),
          ],
        ),
        SizedBox(
          height: 260, // Height of each product card
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 180,
                child: ProductCardWidget(
                  imageUrl: "https://picsum.photos/300",
                  title: "Nike Shoes",
                  description: "Comfortable running shoes for everyday use.",
                  showWishlist: true,
                  isWishlisted: index.isEven,
                  onTap: () => Get.toNamed('/product_detail'),
                  onWishlistTap: () => print("Wishlist clicked $index"),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _SliderWidget() {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) {
              currentIndex.value = index;
            },
          ),
          items: silderIMG.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.amber,
                    child: i,
                  ),
                );
              },
            );
          }).toList(),
        ),

        // ✅ Indicator
        Positioned(
          bottom: 10,
          left: MediaQuery.of(context).size.width * 0.4,
          child: Obx(() => AnimatedSmoothIndicator(
                activeIndex: currentIndex.value,
                count: silderIMG.length,
                effect: const ExpandingDotsEffect(
                  dotWidth: 10,
                  dotHeight: 10,
                  activeDotColor: Colors.white,
                  dotColor: Colors.black54,
                ),
              )),
        ),
      ],
    );
  }
}
