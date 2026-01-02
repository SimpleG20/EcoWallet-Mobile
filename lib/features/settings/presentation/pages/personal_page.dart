import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eco_wallet/core/utils/app_validators.dart';
import 'package:eco_wallet/core/utils/app_formatters.dart';
import 'package:eco_wallet/features/user/presentation/bloc/user_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../user/domain/entities/user.dart';
import '../widgets/settings_widgets.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  bool _isEditing = false;
  bool _fieldsInitialized = false;

  late User _user;
  late List<_ProfileFieldConfig> _fields;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _dateBirthController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentState = context.read<UserBloc>().state;
    if (currentState is UserLoadedState) {
      _user = currentState.user;
      _updateControllers(context, currentState.user);
      _initializeFieldsIfNeeded();
    }
  }

  /// Initializes the fields list once to avoid recreation on rebuild.
  void _initializeFieldsIfNeeded() {
    if (_fieldsInitialized) return;

    final loc = AppLocalizations.of(context)!;
    _fields = [
      _ProfileFieldConfig(
        label: loc.lbName,
        icon: Icons.person_outline,
        controller: _nameController,
        keyboardType: TextInputType.name,
        validator: (value) => AppValidators.isValidName(loc, value),
      ),
      _ProfileFieldConfig(
        label: loc.lbEmail,
        icon: Icons.email_outlined,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) => AppValidators.isValidEmail(loc, value),
      ),
      _ProfileFieldConfig(
        label: loc.lbPhone,
        icon: Icons.phone_outlined,
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.isEmpty) return null;
          return AppValidators.isValidPhoneNumber(loc, value);
        },
        hint: loc.hintPhoneNumber,
      ),
      _ProfileFieldConfig(
        label: loc.lbAddress,
        icon: Icons.location_on_outlined,
        controller: _addressController,
        keyboardType: TextInputType.streetAddress,
        validator: (value) {
          if (value == null || value.isEmpty) return null;
          return AppValidators.isValidAddress(loc, value);
        },
        hint: loc.hintAddress,
      ),
      _ProfileFieldConfig(
        label: loc.lbDateBirth,
        icon: Icons.cake_outlined,
        controller: _dateBirthController,
        keyboardType: TextInputType.datetime,
        validator: (value) {
          if (value == null || value.isEmpty) return null;
          return AppValidators.isValidDate(loc, value);
        },
        hint: loc.hintDateBirth,
      ),
    ];
    _fieldsInitialized = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dateBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primaryContainer,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<UserBloc, BaseUserState>(
        builder: (context, state) {
          if (state is UserLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserErrorState) {
            return Center(
              child: Column(
                children: [
                  Text(
                    state.message ?? loc.errorUnknown,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserBloc>().add(LoadUserEvent(id: _user.id));
                    },
                    child: Text(loc.btnRedo),
                  ),
                ],
              ),
            );
          }

          if (state is UserLoadedState) {
            return Stack(
              children: [
                Column(
                  children: [
                    SettingsSubPageHeader(
                      title: loc.lbPersonalInfo,
                      subtitle: loc.personalInfoSubTitle,
                      complement: (t, l) => _buildHeaderComplement(theme, loc),
                      height: 280,
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SettingsCard(
                        child: Form(
                          key: _formKey,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            itemCount: _fields.length,
                            separatorBuilder: (context, index) => Divider(
                              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                            ),
                            itemBuilder: (context, index) {
                              final field = _fields[index];
                              return _buildTopicItem(context, theme, field);
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SettingsConfirmEditionBtn(onPressed: (ctx) {
                  if (_isEditing) {
                    if (_submitForm(ctx, loc)) {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    }
                  } else {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  }
                })
              ],
            );
          }

          return const Center(
            child: AboutDialog(),
          );
        },
      ),
    );
  }

  void _updateControllers(BuildContext context, User user) {
    _nameController.text = user.fullName;
    _emailController.text = user.email;
    _phoneController.text = user.phoneNumber ?? '';
    _addressController.text = user.address ?? '';
    _dateBirthController.text = user.dateOfBirth != null
        ? AppFormatters.formatDateShort(
            user.dateOfBirth!,
            AppLocalizations.of(context)!.localeName,
          )
        : '';
  }

  Widget _buildHeaderComplement(ThemeData theme, AppLocalizations loc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: _isEditing
                    ? () {
                        // TODO: implemtent image picker
                      }
                    : null,
                icon: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.08),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: theme.colorScheme.primary,
                    size: 48,
                  ),
                ),
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _nameController.text,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _emailController.text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicItem(BuildContext context, ThemeData theme, _ProfileFieldConfig field) {
    final label = field.controller.text.isNotEmpty ? field.controller.text : field.hint ?? '';
    final style = label == field.hint
        ? theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          )
        : theme.textTheme.titleSmall;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            foregroundColor: theme.colorScheme.primary,
            child: Icon(
              size: 28,
              field.icon,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 15,
                  ),
                ),
                if (_isEditing)
                  TextFormField(
                    controller: field.controller,
                    keyboardType: field.keyboardType,
                    style: theme.textTheme.titleSmall,
                    decoration: InputDecoration(
                      hintText: field.hint ?? '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                    validator: (value) {
                      return field.validator(value);
                    },
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      label,
                      style: style,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _submitForm(BuildContext context, AppLocalizations loc) {
    if (_formKey.currentState!.validate()) {
      context.read<UserBloc>().add(
            UpdateUserEvent(
              user: _user.copyWith(
                fullName: _nameController.text,
                email: _emailController.text,
                phoneNumber: _phoneController.text,
                address: _addressController.text,
                dateOfBirth: AppFormatters.parseDate(_dateBirthController.text, loc),
              ),
            ),
          );
      return true;
    }
    return false;
  }
}

class _ProfileFieldConfig {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final String? hint;

  _ProfileFieldConfig({
    required this.label,
    required this.icon,
    required this.controller,
    required this.keyboardType,
    required this.validator,
    this.hint,
  });
}
