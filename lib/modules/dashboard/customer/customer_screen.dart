import 'package:carousel_slider/carousel_slider.dart';

import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/constants/app_widget.dart';
import 'package:ecommerce_urban/app/widgets/product_card_widget.dart';

import 'package:ecommerce_urban/modules/dashboard/customer/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final CustomerController controller = Get.find<CustomerController>();
  final currentIndex = 0.obs;
  final List<Widget> silderIMG = [
    Image.asset("assets/images/slider1.jpg", fit: BoxFit.cover),
    Image.asset("assets/images/slider2.jpg", fit: BoxFit.cover),
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.shopping_bag_rounded,
                color: colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Urban Shop',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
          ],
        ),
        actions: [
          Obx(
            () => Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: colorScheme.onBackground,
                  ),
                  onPressed: () => Get.toNamed('/cart'),
                ),
                if (controller.cartItemCount.value > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${controller.cartItemCount.value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshDashboard,
        color: colorScheme.primary,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingS,
            vertical: AppSpacing.paddingS,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              _buildSearchBar(context),
              SizedBox(height: AppSpacing.paddingM),

              // Promotional Slider
              _sliderWidget(),
              SizedBox(height: AppSpacing.paddingL),

              // Categories Section
              _buildCategorySection(context),
              SizedBox(height: AppSpacing.paddingL),

              // Popular Products Section
              _buildPopularProductSection(context),
              SizedBox(height: AppSpacing.paddingL),

              // Featured Deals Section
              _buildFeaturedDealsSection(context),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => Get.toNamed('/search'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? colorScheme.surface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: colorScheme.onBackground.withOpacity(0.5),
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Search products...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onBackground.withOpacity(0.5),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.tune_rounded,
                color: colorScheme.primary,
                size: AppWidgetSize.iconM,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sliderWidget() {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1,
            autoPlayInterval: const Duration(seconds: 3),
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

  Widget _buildCategorySection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      if (controller.isCategoriesLoading.value) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: colorScheme.primary),
          ),
        );
      }

      if (controller.categories.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categories",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onBackground,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed('/product', arguments: {
                      'categoryName': 'All Categories',
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        "See All",
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: controller.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return GestureDetector(
                  onTap: () => controller.onCategoryTap(index),
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      color: category.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: category.color.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: category.color.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            category.icon,
                            color: category.color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.name,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onBackground,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildPopularProductSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      if (controller.isProductsLoading.value) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: colorScheme.primary),
          ),
        );
      }

      if (controller.popularProducts.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular Products",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onBackground,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.toNamed('/product', arguments: {
                    'categoryName': 'Popular Products',
                  }),
                  child: Row(
                    children: [
                      Text(
                        "See All",
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: controller.popularProducts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final product = controller.popularProducts[index];
                return SizedBox(
                  width: 170,
                  child: ProductCardWidget(
                    imageUrl: product.primaryImageUrl,
                    title: product.name,
                    description: '\$${product.lowestPrice.toStringAsFixed(2)}',
                    showWishlist: true,
                    isWishlisted: product.isWishlisted,
                    onTap: () => controller.goToProductDetail(product),
                    onWishlistTap: () => controller.toggleWishlist(product.id),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildFeaturedDealsSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      if (controller.featuredDeals.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              "Featured Deals",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.featuredDeals.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final product = controller.featuredDeals[index];
              return _buildDealCard(context, product);
            },
          ),
        ],
      );
    });
  }

  Widget _buildDealCard(BuildContext context, product) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => controller.goToProductDetail(product),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.image_outlined,
                    color: colorScheme.primary.withOpacity(0.3),
                    size: 40,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onBackground,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '\$${product.lowestPrice.toStringAsFixed(2)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (product.discount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '-${product.discount}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${product.rating}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${product.reviews})',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onBackground.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => controller.toggleWishlist(product.id),
                  icon: Icon(
                    product.isWishlisted
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: product.isWishlisted ? Colors.red : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
