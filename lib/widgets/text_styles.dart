import 'package:flutter/material.dart';
import 'package:xdslmt/widgets/app_colors.dart';

abstract class TextStyles {
  // General
  static const TextStyle body = TextStyle(fontSize: 16);
  static const TextStyle title = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const TextStyle subtitle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  // Specific
  static const TextStyle f18 = TextStyle(fontSize: 18);
  static const TextStyle f18w3 = TextStyle(fontSize: 18, fontWeight: FontWeight.w300);
  static const TextStyle f18w6 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const TextStyle f16 = TextStyle(fontSize: 16);
  static const TextStyle f16w3 = TextStyle(fontSize: 16, fontWeight: FontWeight.w300);
  static const TextStyle f16w6 = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const TextStyle f14 = TextStyle(fontSize: 14);
  static const TextStyle f14w3 = TextStyle(fontSize: 14, fontWeight: FontWeight.w300);
  static const TextStyle f14w6 = TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
  static const TextStyle f12 = TextStyle(fontSize: 12);
  static const TextStyle f12w3 = TextStyle(fontSize: 12, fontWeight: FontWeight.w300);
  static const TextStyle f12w6 = TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
  static const TextStyle f10 = TextStyle(fontSize: 10);
  static const TextStyle f10w3 = TextStyle(fontSize: 10, fontWeight: FontWeight.w300);
  static const TextStyle f10w6 = TextStyle(fontSize: 10, fontWeight: FontWeight.w600);
  static const TextStyle f8 = TextStyle(fontSize: 8);
  static const TextStyle f8w3 = TextStyle(fontSize: 8, fontWeight: FontWeight.w300);
  static const TextStyle f8w6 = TextStyle(fontSize: 8, fontWeight: FontWeight.w600);

  // Charts
  static TextStyle f8hc100 = const TextStyle(fontSize: 8, height: 1, color: AppColors.cyan100);
}

extension CS on TextStyle {
  TextStyle get cyan50 => copyWith(color: AppColors.cyan50);
  TextStyle get cyan100 => copyWith(color: AppColors.cyan100);
  TextStyle get cyan400 => copyWith(color: AppColors.cyan400);
  TextStyle get blueGrey400 => copyWith(color: AppColors.blueGrey400);
  TextStyle get blueGrey600 => copyWith(color: AppColors.blueGrey600);
  TextStyle get blueGrey800 => copyWith(color: AppColors.blueGrey800);
  TextStyle get blueGrey900 => copyWith(color: AppColors.blueGrey900);
}
