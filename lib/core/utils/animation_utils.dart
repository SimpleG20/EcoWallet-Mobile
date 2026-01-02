import 'package:flutter/animation.dart';

/// Animation utilities that respect user accessibility preferences.
///
/// Provides standardized animation durations and curves that can be
/// disabled based on user settings for accessibility or performance.
class AnimationUtils {
  // Private constructor to prevent instantiation
  const AnimationUtils._();

  // Standard animation durations
  static const Duration fastDuration = Duration(milliseconds: 150);
  static const Duration normalDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 500);
  static const Duration pageTransitionDuration = Duration(milliseconds: 350);

  // No animation duration for accessibility
  static const Duration none = Duration.zero;

  /// Returns the appropriate duration based on user's animation preference.
  ///
  /// If [enableAnimations] is false, returns [Duration.zero] for instant transitions.
  /// Otherwise returns the specified [targetDuration].
  ///
  /// Example usage:
  /// ```dart
  /// AnimatedContainer(
  ///   duration: AnimationUtils.getDuration(
  ///     settings.enableAnimations,
  ///     AnimationUtils.normalDuration,
  ///   ),
  ///   // ...
  /// )
  /// ```
  static Duration getDuration(bool enableAnimations, [Duration? targetDuration]) {
    if (!enableAnimations) return none;
    return targetDuration ?? normalDuration;
  }

  /// Returns fast animation duration (150ms) or zero if animations are disabled.
  static Duration fast(bool enableAnimations) => getDuration(enableAnimations, fastDuration);

  /// Returns normal animation duration (300ms) or zero if animations are disabled.
  static Duration normal(bool enableAnimations) => getDuration(enableAnimations, normalDuration);

  /// Returns slow animation duration (500ms) or zero if animations are disabled.
  static Duration slow(bool enableAnimations) => getDuration(enableAnimations, slowDuration);

  /// Returns page transition duration (350ms) or zero if animations are disabled.
  static Duration pageTransition(bool enableAnimations) => getDuration(enableAnimations, pageTransitionDuration);

  /// Standard curves for consistent animations across the app.
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve sharpCurve = Curves.easeOutCubic;
  static const Curve fadeInCurve = Curves.easeIn;
  static const Curve fadeOutCurve = Curves.easeOut;
}
