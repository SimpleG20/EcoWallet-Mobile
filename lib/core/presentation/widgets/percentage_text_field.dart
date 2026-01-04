import 'package:eco_wallet/core/presentation/widgets/any_text_field.dart';
import 'package:flutter/services.dart';

class PercentageTextField extends AnyTextField {
  PercentageTextField({
    super.key,
    required super.controller,
    super.keyboardType = TextInputType.number,
    super.verticalSpacing = true,
    super.textInputAction = TextInputAction.next,
    super.label,
    super.subtitle,
    super.validator,
    super.outsidePrefixIcon,
    super.inisidePrefixIcon,
    super.hintStyle,
    super.onEditingComplete,
  }) : super(
          hintText: '0%',
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
        );
}
