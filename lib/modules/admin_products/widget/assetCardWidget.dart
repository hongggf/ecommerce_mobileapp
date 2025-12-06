import 'dart:convert';
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

  /// Build image with proper URL and base64 handling
  Widget _buildImage() {
    // Check what data we have
    print('🖼️ Asset ID: ${asset.id}');
    print('   URL: ${asset.url}');
    print('   Has base64: ${asset.base64File != null && asset.base64File!.isNotEmpty}');

    // Try multiple URL approaches
    if (asset.url != null && asset.url!.isNotEmpty) {
      final url = asset.url.toString();
      
      // Approach 1: Try with full URL
      if (!url.startsWith('http')) {
        // It's a path, construct the URL
        return _tryLoadUrl('http://10.0.2.2:8000$url');
      } else {
        // Already a full URL
        return _tryLoadUrl(url);
      }
    }

    // Fallback to base64
    print('📥 Using base64 image');
    return _buildBase64Image();
  }

  /// Try to load image from URL with proper error handling
  Widget _tryLoadUrl(String url) {
    print('🌐 Attempting to load from: $url');
    
    return Image.network(
      url,
      fit: BoxFit.cover,
      headers: {
        'Accept': 'image/*',
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          print('✅ Image loaded successfully from: $url');
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
        print('❌ Network load failed for $url');
        print('   Error: $error');
        print('   Falling back to base64...');
        return _buildBase64Image();
      },
    );
  }

  /// Build image from base64
  Widget _buildBase64Image() {
    try {
      if (asset.base64File == null || asset.base64File!.isEmpty) {
        print('⚠️ No base64 data available');
        return Center(
          child: Icon(
            Icons.image_not_supported,
            color: Colors.grey.shade400,
            size: 48,
          ),
        );
      }

      String base64String = asset.base64File!;

      // Remove data URL prefix if present
      if (base64String.startsWith('data:')) {
        final parts = base64String.split(',');
        if (parts.length > 1) {
          base64String = parts[1];
          print('📦 Removed data URL prefix');
        }
      }

      // Clean whitespace
      base64String = base64String.replaceAll('\n', '').replaceAll('\r', '');

      print('📥 Decoding base64 (${base64String.length} chars)');

      final bytes = base64Decode(base64String);
      print('✅ Base64 decoded: ${bytes.length} bytes');

      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('❌ Base64 decode failed: $error');
          return Center(
            child: Icon(
              Icons.image_not_supported,
              color: Colors.grey.shade400,
              size: 48,
            ),
          );
        },
      );
    } catch (e) {
      print('❌ Base64 error: $e');
      return Center(
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey.shade400,
          size: 48,
        ),
      );
    }
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