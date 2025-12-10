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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDark ? Colors.grey[850] : Colors.grey[100],
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _buildImage(isDark),
          ),
        ),
        
        // Primary Badge
        if (asset.isPrimary)
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[600]!, Colors.green[700]!],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Primary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        
        // Delete Button
        Positioned(
          bottom: 10,
          right: 10,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showDeleteDialog(context, isDark),
              borderRadius: BorderRadius.circular(25),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red[600]!, Colors.red[700]!],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.delete_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(bool isDark) {
    if (asset.url == null || asset.url!.isEmpty) {
      return _buildErrorWidget('No image URL', isDark);
    }

    String imageUrl = _fixUrlForEmulator(asset.url.toString());

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        final progress = loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blue[700]!,
                  ),
                ),
              ),
              if (progress != null) ...[
                const SizedBox(height: 12),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        if (error.toString().contains('Connection closed') ||
            error.toString().contains('Connection reset')) {
          return const SizedBox.shrink();
        }

        return _buildErrorWidget('Failed to load', isDark);
      },
    );
  }

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

  Widget _buildErrorWidget(String message, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.broken_image_rounded,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
              size: 36,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              color: isDark ? Colors.grey[500] : Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(width: 12),
            const Text('Delete Image'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this image? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              controller.deleteAsset(asset);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red[700],
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}