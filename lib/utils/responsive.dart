import 'dart:ui';


/// Small responsive utility for Sizes

extension Responsive on num{

  /// Returns width multiplied by the multiplier's percentage.
  double pw(Size size){
    return this/100 * size.width;
  }

  /// Returns height multiplied by the multiplier's percentage.
  double ph(Size size){
    return this/100 * size.height;
  }

}