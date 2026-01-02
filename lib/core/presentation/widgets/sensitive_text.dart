import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';

class SensitiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const SensitiveText({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final hide = context.select((SettingsBloc bloc) {
      final state = bloc.state;
      if (state is SettingsLoadedState) {
        return state.preferences.appearancePreferences.hideValues;
      }
      return false;
    });
    return Text(
      hide ? '*' * max(4, (text.length / 2).round()) : text,
      style: style,
    );
  }
}
