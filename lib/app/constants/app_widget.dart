import 'package:ecommerce_urban/app/controller/ratio_controller.dart';

class AppWidgetSize {

  static RatioController get _ratio => RatioController.to;

  /// Icon Sizes
  static double get iconXS => _ratio.scaledSize(12);
  static double get iconS => _ratio.scaledSize(16);
  static double get iconSM => _ratio.scaledSize(20);
  static double get iconM => _ratio.scaledSize(24);
  static double get iconL => _ratio.scaledSize(32);
  static double get iconXL => _ratio.scaledSize(40);
  static double get iconXXL => _ratio.scaledSize(48);

  /// Image Sizes
  static double get imageXS => _ratio.scaledSize(24);
  static double get imageS => _ratio.scaledSize(48);
  static double get imageSM => _ratio.scaledSize(72);
  static double get imageM => _ratio.scaledSize(96);
  static double get imageL => _ratio.scaledSize(120);
  static double get imageXL => _ratio.scaledSize(150);
  static double get imageXXL => _ratio.scaledSize(200);

  /// Logo Sizes (can be separate if needed)
  static double get logoS => _ratio.scaledSize(64);
  static double get logoM => _ratio.scaledSize(96);
  static double get logoL => _ratio.scaledSize(128);
  static double get logoXL => _ratio.scaledSize(160);
}