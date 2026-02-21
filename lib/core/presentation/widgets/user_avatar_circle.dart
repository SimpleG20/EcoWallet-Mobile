import 'package:flutter/material.dart';

/// A reusable user avatar widget with fallback to placeholder icon.
///
/// Displays a network image if [imageUrl] is provided, otherwise shows
/// a person icon placeholder. Handles image loading errors gracefully.
class UserAvatarCircle extends StatelessWidget {
  const UserAvatarCircle({
    super.key,
    required this.imageUrl,
    this.radius = 32,
    this.iconSize = 40,
  });

  /// The URL of the user's profile image. Can be null for placeholder.
  final String? imageUrl;

  /// The radius of the avatar circle.
  final double radius;

  /// The size of the placeholder icon.
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.primary.withAlpha(50),
      child: imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.network(
                imageUrl!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder(theme);
                },
              ),
            )
          : _buildPlaceholder(theme),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Icon(
      Icons.person_outline,
      color: theme.colorScheme.primary,
      size: iconSize,
    );
  }
}
