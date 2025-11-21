import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/app/constants/app_fontsizes.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/widgets/product_card_widget.dart';
import 'package:ecommerce_urban/modules/product/product_detail/product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen({super.key});
  final ProductDetailController controller =
      Get.find<ProductDetailController>();
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(controller),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  _buildImageSlider(controller),
                SizedBox(height: AppSpacing.paddingM),
                _buildProductInfo(),
                SizedBox(height: AppSpacing.paddingM),
                _buildSizeSelector(controller),
                SizedBox(height: AppSpacing.paddingM),
                _buildDescription(),
                SizedBox(height: AppSpacing.paddingM),
                _buildReviews(),
                SizedBox(height: AppSpacing.paddingL),
                _buildRelatedProducts(),
                SizedBox(height: 100), // Space for bottom bar
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(controller),
    );
  }

  Widget _buildAppBar(ProductDetailController controller) {
    return Obx(() {
      return SliverAppBar(
        expandedHeight: 400,
        pinned: true,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.arrow_back),
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                controller.isFavorite.value
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
            ),
            onPressed: controller.toggleFavorite,
          ),
          SizedBox(width: 8),
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: PageView.builder(
            controller: pageController,
            onPageChanged: (index) {
              controller.selectedImageIndex.value = index;
            },
            itemCount: controller.productImages.length,
            itemBuilder: (context, index) {
              return Image.network(
                controller.productImages[index],
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      );
    });
  }

  // Widget _buildImageSlider(ProductDetailController controller) {
  //   return Container(
  //     height: 90,
  //     padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
  //     child: Obx(() {
  //       return ListView.separated(
  //         scrollDirection: Axis.horizontal,
  //         itemCount: controller.productImages.length,
  //         separatorBuilder: (_, __) => SizedBox(width: 12),
  //         itemBuilder: (context, index) {
  //           final isSelected = controller.selectedImageIndex.value == index;

  //           return GestureDetector(
  //             onTap: () {
  //               controller.selectedImageIndex.value = index;
  //               pageController.animateToPage(
  //                 index,
  //                 duration: Duration(milliseconds: 300),
  //                 curve: Curves.easeInOut,
  //               );
  //             },
  //             child: AnimatedContainer(
  //               duration: Duration(milliseconds: 200),
  //               width: isSelected ? 85 : 75,
  //               decoration: BoxDecoration(
  //                 border: Border.all(
  //                   color: isSelected ? Colors.blue : Colors.grey.shade300,
  //                   width: isSelected ? 2.5 : 1,
  //                 ),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(10),
  //                 child: Image.network(
  //                   controller.productImages[index],
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     }),
  //   );
  // }

  Widget _buildProductInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Best Seller',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Spacer(),
              Icon(Icons.star, color: Colors.amber, size: 20),
              SizedBox(width: 4),
              Text(
                '4.8',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                ' (120 reviews)',
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Nike Air Max 270',
            style: TextStyle(
              fontSize: AppFontSize.headlineMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                '\$159.99',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary),
              ),
              SizedBox(width: 12),
              Text(
                '\$199.99',
                style: TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '-20%',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSelector(ProductDetailController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Size',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Obx(() => Wrap(
                spacing: 12,
                children: controller.sizes.map((size) {
                  final isSelected = controller.selectedSize.value == size;
                  return GestureDetector(
                    onTap: () => controller.selectSize(size),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          size,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              fontSize: AppFontSize.headlineSmall,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'The Nike Air Max 270 delivers visible cushioning under every step. With a sleek, street-ready silhouette, the foam midsole provides durable comfort. The Air unit is 32mm at its tallest point for max comfort.',
            style: TextStyle(
              // color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews (120)',
                style: TextStyle(
                  fontSize: AppFontSize.headlineSmall,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('See all'),
              ),
            ],
          ),
          SizedBox(height: 8),
          _buildReviewItem(),
        ],
      ),
    );
  }

  Widget _buildReviewItem() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        // color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                child: Text('JD'),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '2 days ago',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Great shoes! Very comfortable and stylish. Highly recommend!',
            // style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
          child: Text(
            'You May Also Like',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
            itemCount: 5,
            separatorBuilder: (_, __) => SizedBox(width: 12),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 180,
                child: ProductCardWidget(
                  imageUrl: "https://picsum.photos/30${index}",
                  title: "Related Product ${index + 1}",
                  description: "Similar style and quality",
                  showWishlist: true,
                  isWishlisted: false,
                  onTap: () {},
                  onWishlistTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(ProductDetailController controller) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        // color: AppColors.darkSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: controller.decrementQuantity,
                  ),
                  Obx(() => Text(
                        '${controller.quantity.value}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: controller.incrementQuantity,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}