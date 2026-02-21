import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnyTextField extends StatelessWidget {
  const AnyTextField(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.keyboardType,
      this.verticalSpacing = true,
      this.textInputAction = TextInputAction.next,
      this.label,
      this.subtitle,
      this.validator,
      this.outsidePrefixIcon,
      this.inisidePrefixIcon,
      this.hintStyle,
      this.inputFormatters,
      this.onEditingComplete});

  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool verticalSpacing;
  final String? label;
  final String? subtitle;
  final TextStyle? hintStyle;
  final Widget? inisidePrefixIcon;
  final Widget? outsidePrefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    bool onlyLabel = label != null && subtitle == null;
    bool labelAndSubtitle = label != null && subtitle != null;

    final widget = onlyLabel
        ? _onlyLabel(context)
        : labelAndSubtitle
            ? _labelAndSubtitle(context)
            : _noLabel(context);

    return Row(
      children: [
        if (outsidePrefixIcon != null) ...[
          outsidePrefixIcon!,
          const SizedBox(width: 16),
        ],
        Expanded(child: widget),
      ],
    );
  }

  Widget _noLabel(BuildContext context) {
    return _buildTextFormField(context);
  }

  Widget _onlyLabel(BuildContext context) {
    final theme = Theme.of(context);
    return verticalSpacing
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label!,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: hintText,
                  prefixIcon:
                      outsidePrefixIcon != null ? null : inisidePrefixIcon,
                ),
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                controller: controller,
                validator: validator,
              ),
            ],
          )
        : Row(
            children: [
              Text(
                label!,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextFormField(context),
              ),
            ],
          );
  }

  Widget _labelAndSubtitle(BuildContext context) {
    final theme = Theme.of(context);
    final labelAndSubtitle = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
          child: Text(
            subtitle!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
    return verticalSpacing
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              labelAndSubtitle,
              _buildTextFormField(context),
            ],
          )
        : Row(
            children: [
              Expanded(
                flex: 2,
                child: labelAndSubtitle,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextFormField(context),
              ),
            ],
          );
  }

  TextFormField _buildTextFormField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: outsidePrefixIcon != null ? null : inisidePrefixIcon,
      ),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      controller: controller,
      validator: validator,
      onEditingComplete:
          onEditingComplete ?? () => FocusScope.of(context).nextFocus(),
    );
  }
}
