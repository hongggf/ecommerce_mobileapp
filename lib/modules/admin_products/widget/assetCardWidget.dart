import 'package:flutter/material.dart';
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

  Widget _buildImage() {
    print('🖼️ Asset ${asset.id}: Building image from URL');
    print('   URL: ${asset.url}');

    if (asset.url == null || asset.url!.isEmpty) {
      return _buildErrorWidget('No image URL');
    }

    // Fix URL for Android emulator
    String imageUrl = _fixUrlForEmulator(asset.url.toString());
    print('   Final URL: $imageUrl');

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          print('   ✅ Image loaded successfully');
          return child;
        }
        
        final progress = loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null;
        
        return Center(
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        print('   ❌ Image error: $error');
        
        // Ignore connection retry errors
        if (error.toString().contains('Connection closed') || 
            error.toString().contains('Connection reset')) {
          return const SizedBox.shrink();
        }
        
        return _buildErrorWidget('Failed to load');
      },
    );
  }

  /// Fix URL for Android emulator
  String _fixUrlForEmulator(String url) {
    if (url.contains('10.0.2.2')) {
      return url;
    }
    
    if (url.contains('localhost')) {
      return url.replaceAll('localhost', '10.0.2.2');
    }
    
    if (url.contains('127.0.0.1')) {
      return url.replaceAll('127.0.0.1', '10.0.2.2');
    }
    
    return url;
  }

  Widget _buildErrorWidget(String message) {
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
            message,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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