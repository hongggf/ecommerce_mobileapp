import 'dart:io';
import 'package:ecommerce_urban/modules/admin_products/widget/assetCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce_urban/modules/admin_products/controller/product_mangement_controller.dart';


class AssetsSectionWidget extends StatelessWidget {
  final ProductManagementController controller;
  final ImagePicker picker;

  const AssetsSectionWidget({
    required this.controller,
    required this.picker,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.selectedVariant.value == null) {
        return Center(
          child: Text(
            'Select a variant to manage assets',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        );
      }

      final variant = controller.selectedVariant.value!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Product Images'),
                  const SizedBox(height: 4),
                  Text(
                    'Variant: ${variant.name}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showUploadOptions(context),
                icon: const Icon(Icons.add_a_photo, size: 18),
                label: const Text('Upload'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            print('🎯 Assets count: ${controller.assets.length}');
            print('📂 Loading assets: ${controller.isLoadingAssets.value}');

            if (controller.isLoadingAssets.value) {
              return _buildAssetsShimmer();
            }

            if (controller.assets.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No images yet',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Upload images to get started',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: controller.assets.length,
              itemBuilder: (context, index) {
                final asset = controller.assets[index];
                print('📷 Building asset card: ${asset.id}');
                return AssetCardWidget(
                  asset: asset,
                  controller: controller,
                );
              },
            );
          }),
        ],
      );
    });
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Slow shimmer loading for assets
  Widget _buildAssetsShimmer() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _buildSlowShimmerBox();
      },
    );
  }

  Widget _buildSlowShimmerBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade300,
      ),
      child: ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade300,
              Colors.grey.shade100,
              Colors.grey.shade300,
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(bounds);
        },
        child: Container(
          color: Colors.white,
        ),
      ),
    );
  }

  void _showUploadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: Colors.blue.shade700,
              ),
              title: const Text('Take Photo'),
              subtitle: const Text('Capture image with camera'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile =
                    await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  print('📷 Uploading from camera: ${pickedFile.path}');
                  await controller.uploadAsset(File(pickedFile.path));
                }
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.image,
                color: Colors.blue.shade700,
              ),
              title: const Text('Choose from Gallery'),
              subtitle: const Text('Select from your device'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  print('🖼️ Uploading from gallery: ${pickedFile.path}');
                  await controller.uploadAsset(File(pickedFile.path));
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}