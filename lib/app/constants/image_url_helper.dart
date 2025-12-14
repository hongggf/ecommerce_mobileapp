//
// import 'package:ecommerce_urban/app/constants/app_constant.dart';
//
// /// Helper class to build full image URLs from relative paths / dev hosts / maps
// class ImageUrlHelper {
//   /// Convert any image URL to a full HTTP/HTTPS URL.
//   ///
//   /// Returns empty string if url is null/empty or cannot be normalized.
//   static String buildImageUrl(String? url) {
//     if (url == null) return '';
//
//     final raw = url.trim();
//     if (raw.isEmpty) return '';
//
//     // If already absolute with scheme, normalize and return (but rewrite dev hosts)
//     if (_hasScheme(raw)) {
//       return _rewriteDevHosts(raw);
//     }
//
//     // Relative path: join with base (remove '/api' from base)
//     final base = ApiConstants.baseUrl.replaceAll('/api', '').trim();
//     if (base.isEmpty) return raw; // fallback
//
//     return _join(base, raw);
//   }
//
//   /// Build an image URL but ask for a resized width via query parameter (if your server/CDN accepts it).
//   /// Example: buildSizedImageUrl('/storage/img.jpg', width: 320) -> 'https://.../storage/img.jpg?w=320'
//   /// If width is null or <= 0 this falls back to buildImageUrl(url).
//   static String buildSizedImageUrl(String? url, {int? width}) {
//     final full = buildImageUrl(url);
//     if (full.isEmpty || width == null || width <= 0) return full;
//
//     try {
//       final uri = Uri.parse(full);
//       // Preserve existing query parameters
//       final newQuery = Map<String, String>.from(uri.queryParameters)..putIfAbsent('w', () => width.toString());
//       final resized = uri.replace(queryParameters: newQuery);
//       return resized.toString();
//     } catch (e) {
//       // If parsing fails, fall back to naive append
//       final sep = full.contains('?') ? '&' : '?';
//       return '$full${sep}w=$width';
//     }
//   }
//
//   /// Get primary image or first image from assets list.
//   ///
//   /// assetsList may be: List<ProductAsset>, List<Map<String,dynamic>>, or any Iterable with `.url` and optional `.isPrimary`.
//   /// Returns null if no usable URL found.
//   static String? getPrimaryImageUrl(dynamic assetsList) {
//     if (assetsList == null) return null;
//
//     try {
//       final iterable = _toIterable(assetsList);
//       if (iterable.isEmpty) return null;
//
//       // Try to find primary asset
//       final primary = iterable.firstWhere((a) => _isPrimary(a), orElse: () => null);
//       final chosen = primary ?? iterable.first;
//
//       final url = _extractUrl(chosen);
//       if (url == null || url.trim().isEmpty) return null;
//       return buildImageUrl(url);
//     } catch (e) {
//       // keep safe: return null on any error
//       if (const bool.fromEnvironment('dart.vm.product') == false) {
//         // debug print only in non-release builds
//         // ignore: avoid_print
//         print('ImageUrlHelper.getPrimaryImageUrl error: $e');
//       }
//       return null;
//     }
//   }
//
//   /* -------------------- private helpers -------------------- */
//
//   static bool _hasScheme(String s) {
//     final lower = s.toLowerCase();
//     return lower.startsWith('http://') || lower.startsWith('https://');
//   }
//
//   // Replace emulator/dev hosts with ApiConstants.baseUrl (without '/api')
//   static String _rewriteDevHosts(String url) {
//     final base = ApiConstants.baseUrl.replaceAll('/api', '').trim();
//
//     // Map several dev host forms
//     String out = url;
//     out = out.replaceFirst('http://10.0.2.2:8000', base);
//     out = out.replaceFirst('http://10.0.2.2', base);
//     out = out.replaceFirst('http://localhost:8000', base);
//     out = out.replaceFirst('http://localhost', base);
//     out = out.replaceFirst('https://localhost:8000', base);
//     out = out.replaceFirst('https://localhost', base);
//
//     // If base was used above, ensure we return a valid URI string
//     if (_hasScheme(out)) return out;
//
//     // If rewrite produced a non-scheme string, join with base properly
//     if (base.isNotEmpty) return _join(base, out);
//
//     return out;
//   }
//
//   // Safe join of base + path ensuring single slash
//   static String _join(String base, String path) {
//     final b = base.trim();
//     var p = path.trim();
//
//     // if path already contains a scheme, return it
//     if (_hasScheme(p)) return p;
//
//
//     // ensure path starts with '/'
//     if (!p.startsWith('/')) p = '/$p';
//
//     // remove trailing slash from base
//     final cleanedBase = b.endsWith('/') ? b.substring(0, b.length - 1) : b;
//     return '$cleanedBase$p';
//   }
//
//   // Convert dynamic list input to List<dynamic>
//   static List<dynamic> _toIterable(dynamic assetsList) {
//     if (assetsList is Iterable) return assetsList.toList();
//     if (assetsList is Map) return [assetsList];
//     // Unknown single object
//     return [assetsList];
//   }
//
//   // Extract url field from either Map or object with .url
//   static String? _extractUrl(dynamic asset) {
//     if (asset == null) return null;
//
//     try {
//       if (asset is Map && asset.containsKey('url')) return asset['url']?.toString();
//       // Try property access via noSuchMethod: common model classes expose .url
//       final val = (asset as dynamic).url;
//       return val?.toString();
//     } catch (_) {
//       return null;
//     }
//   }
//
//   // Determine if asset is primary. Accepts bool, int '1', or string '1'/'true'
//   static bool _isPrimary(dynamic asset) {
//     if (asset == null) return false;
//     try {
//       if (asset is Map && asset.containsKey('isPrimary')) {
//         final v = asset['isPrimary'];
//         return _truthy(v);
//       }
//       if (asset is Map && asset.containsKey('is_primary')) {
//         final v = asset['is_primary'];
//         return _truthy(v);
//       }
//       final dynamic v = (asset as dynamic).isPrimary;
//       return _truthy(v);
//     } catch (_) {
//       return false;
//     }
//   }
//
//   static bool _truthy(dynamic v) {
//     if (v == null) return false;
//     if (v is bool) return v;
//     if (v is num) return v != 0;
//     final s = v.toString().toLowerCase();
//     return s == '1' || s == 'true' || s == 'yes';
//   }
// }
