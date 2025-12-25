import 'package:flutter/material.dart';

@immutable
class ExtraColors extends ThemeExtension<ExtraColors> {
  final Color? sidebar;
  final Color? sidebarForeground;
  final Color? sidebarPrimary;
  final Color? sidebarPrimaryForeground;
  final Color? sidebarBorder;
  final Color? ring;
  final Color? chart1;
  final Color? chart2;
  final Color? chart3;
  final Color? chart4;
  final Color? chart5;

  const ExtraColors({
    required this.sidebar,
    required this.sidebarForeground,
    required this.sidebarPrimary,
    required this.sidebarPrimaryForeground,
    required this.sidebarBorder,
    required this.ring,
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
  });

  @override
  ExtraColors copyWith({
    Color? sidebar,
    Color? sidebarForeground,
    Color? sidebarPrimary,
    Color? sidebarPrimaryForeground,
    Color? sidebarBorder,
    Color? ring,
    Color? chart1,
    Color? chart2,
    Color? chart3,
    Color? chart4,
    Color? chart5,
  }) {
    return ExtraColors(
      sidebar: sidebar ?? this.sidebar,
      sidebarForeground: sidebarForeground ?? this.sidebarForeground,
      sidebarPrimary: sidebarPrimary ?? this.sidebarPrimary,
      sidebarPrimaryForeground:
          sidebarPrimaryForeground ?? this.sidebarPrimaryForeground,
      sidebarBorder: sidebarBorder ?? this.sidebarBorder,
      ring: ring ?? this.ring,
      chart1: chart1 ?? this.chart1,
      chart2: chart2 ?? this.chart2,
      chart3: chart3 ?? this.chart3,
      chart4: chart4 ?? this.chart4,
      chart5: chart5 ?? this.chart5,
    );
  }

  @override
  ExtraColors lerp(ThemeExtension<ExtraColors>? other, double t) {
    if (other is! ExtraColors) return this;
    return ExtraColors(
      sidebar: Color.lerp(sidebar, other.sidebar, t),
      sidebarForeground:
          Color.lerp(sidebarForeground, other.sidebarForeground, t),
      sidebarPrimary: Color.lerp(sidebarPrimary, other.sidebarPrimary, t),
      sidebarPrimaryForeground: Color.lerp(
          sidebarPrimaryForeground, other.sidebarPrimaryForeground, t),
      sidebarBorder: Color.lerp(sidebarBorder, other.sidebarBorder, t),
      ring: Color.lerp(ring, other.ring, t),
      chart1: Color.lerp(chart1, other.chart1, t),
      chart2: Color.lerp(chart2, other.chart2, t),
      chart3: Color.lerp(chart3, other.chart3, t),
      chart4: Color.lerp(chart4, other.chart4, t),
      chart5: Color.lerp(chart5, other.chart5, t),
    );
  }
}
