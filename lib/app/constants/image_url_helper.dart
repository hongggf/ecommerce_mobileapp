import 'package:ecommerce_urban/app/constants/constants.dart';

/// Helper class to build full image URLs from relative paths
class ImageUrlHelper {
  /// Convert any image URL to full HTTP URL
  static String buildImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      return '';
    }

    String finalUrl = url;

    // Handle localhost URLs
    if (url.contains('localhost')) {
      final baseUrl = ApiConstants.baseUrl.replaceAll('/api', '');
      finalUrl = url.replaceAll('localhost:8000', baseUrl);
      finalUrl = finalUrl.replaceAll('localhost', baseUrl);
    }
    // Handle relative paths (starting with /)
    else if (!url.startsWith('http')) {
      finalUrl = ApiConstants.baseUrl.replaceAll('/api', '') + url;
    }

    return finalUrl;
  }

  /// Get primary image or first image from assets list
  static String? getPrimaryImageUrl(dynamic assetsList) {
    if (assetsList == null || assetsList.isEmpty) {
      return null;
    }

    try {
      // Try to find primary asset
      final primaryAsset = assetsList.firstWhere(
        (a) => a.isPrimary == true,
        orElse: () => null,
      );

      if (primaryAsset != null) {
        return buildImageUrl(primaryAsset.url);
      }

      // Fallback to first asset
      return buildImageUrl(assetsList.first.url);
    } catch (e) {
      print('Error getting primary image: $e');
      return null;
    }
  }
}
//"I need to display product images. Can you create a [screen name] widget that shows images using ImageUrlHelper?