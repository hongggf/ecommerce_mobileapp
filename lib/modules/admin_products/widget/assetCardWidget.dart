import 'package:flutter/material.dart';
import 'package:ecommerce_urban/app/constants/constants.dart';
import 'package:ecommerce_urban/modules/admin_products/controller/product_mangement_controller.dart';

class AssetCardWidget extends StatelessWidget {
  final dynamic asset;
  final ProductManagementController controller;

  const AssetCardWidget({
    required this.asset,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade200,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildImage(),
          ),
        ),
        if (asset.isPrimary)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Primary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => _showDeleteDialog(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build image from URL only (no base64 fallback)
  Widget _buildImage() {
    print('🖼️ Asset ID: ${asset.id}');
    print('   URL: ${asset.url}');

    if (asset.url == null || asset.url!.isEmpty) {
      return Center(
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey.shade400,
          size: 48,
        ),
      );
    }

    final url = asset.url.toString();
    
    // Build full URL using ApiConstants
    String finalUrl = url;
    
    if (url.contains('localhost')) {
      // Replace localhost with your API constant
      finalUrl = url.replaceAll('localhost:8000', ApiConstants.baseUrl.replaceAll('/api', ''));
      finalUrl = finalUrl.replaceAll('localhost', ApiConstants.baseUrl.replaceAll('/api', ''));
    } else if (!url.startsWith('http')) {
      // It's a relative path
      finalUrl = ApiConstants.baseUrl.replaceAll('/api', '') + url;
    }

    print('🌐 Loading image from: $finalUrl');

    return Image.network(
      finalUrl,
      fit: BoxFit.cover,
      cacheHeight: 300,  // Add caching
      cacheWidth: 300,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          print('✅ Image loaded successfully');
          return child;
        }
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // Ignore connection retry errors (they're normal)
        if (error.toString().contains('Connection closed')) {
          print('ℹ️ Image retry (ignore this): $error');
          return SizedBox.shrink(); // Return empty while retrying
        }
        
        print('❌ Image load failed: $error');
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image,
                color: Colors.grey.shade400,
                size: 48,
              ),
              const SizedBox(height: 8),
              Text(
                'Failed to load',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Image'),
        content: const Text('Are you sure you want to delete this image?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteAsset(asset);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}