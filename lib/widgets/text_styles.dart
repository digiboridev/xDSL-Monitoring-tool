import 'package:flutter/material.dart';

abstract class TextStyles {
  // General
  static const TextStyle body = TextStyle(fontSize: 16);
  static const TextStyle title = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const TextStyle subtitle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  // Specific
  static TextStyle f18 = TextStyle(fontSize: 18);
  static TextStyle f18w3 = TextStyle(fontSize: 18, fontWeight: FontWeight.w300);
  static TextStyle f18w6 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static TextStyle f16 = TextStyle(fontSize: 16);
  static TextStyle f16w3 = TextStyle(fontSize: 16, fontWeight: FontWeight.w300);
  static TextStyle f16w6 = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static TextStyle f14 = TextStyle(fontSize: 14);
  static TextStyle f14w3 = TextStyle(fontSize: 14, fontWeight: FontWeight.w300);
  static TextStyle f14w6 = TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
  static TextStyle f12 = TextStyle(fontSize: 12);
  static TextStyle f12w3 = TextStyle(fontSize: 12, fontWeight: FontWeight.w300);
  static TextStyle f12w6 = TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
  static TextStyle f10 = TextStyle(fontSize: 10);
  static TextStyle f10w3 = TextStyle(fontSize: 10, fontWeight: FontWeight.w300);
  static TextStyle f10w6 = TextStyle(fontSize: 10, fontWeight: FontWeight.w600);
  static TextStyle f8 = TextStyle(fontSize: 8);
  static TextStyle f8w3 = TextStyle(fontSize: 8, fontWeight: FontWeight.w300);
  static TextStyle f8w6 = TextStyle(fontSize: 8, fontWeight: FontWeight.w600);

  // Charts
  static TextStyle f8hc100 = TextStyle(fontSize: 8, height: 1, color: Colors.cyan.shade100);
}

extension CS on TextStyle {
  TextStyle get cyan50 => copyWith(color: Colors.cyan.shade50);
  TextStyle get cyan100 => copyWith(color: Colors.cyan.shade100);
  TextStyle get blueGrey900 => copyWith(color: Colors.blueGrey.shade800);
  TextStyle get blueGrey800 => copyWith(color: Colors.blueGrey.shade800);
  TextStyle get blueGrey600 => copyWith(color: Colors.blueGrey.shade600);
  TextStyle get blueGrey400 => copyWith(color: Colors.blueGrey.shade400);
}
