import 'package:flutter/material.dart';

import 'package:eco_wallet/core/utils/app_validators.dart';

import '../../../../l10n/app_localizations.dart';
import '../widgets/settings_sub_page_header.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  bool _isEditing = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _dateBirthController = TextEditingController();

  @override
  void initState() {
    _nameController.text = "Fulano";
    _emailController.text = "fulano@email.com";
    _phoneController.text = "+55 11 91234-5678";
    _addressController.text = "Rua Exemplo, 123, São Paulo";
    _dateBirthController.text = "01/01/1990";
    super.initState();
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

    // 1. Definição da Estrutura dos Campos (Data-Driven)
    final fields = [
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
        validator: (value) => AppValidators.isValidPhoneNumber(loc, value),
      ),
      _ProfileFieldConfig(
        label: loc.lbAddress,
        icon: Icons.location_on_outlined,
        controller: _addressController,
        keyboardType: TextInputType.streetAddress,
        validator: (value) => AppValidators.isValidAddress(loc, value),
      ),
      _ProfileFieldConfig(
        label: loc.lbDateBirth,
        icon: Icons.cake_outlined,
        controller: _dateBirthController,
        keyboardType: TextInputType.datetime,
        validator: (value) => AppValidators.isValidDate(loc, value),
        // Dica: Para datas, idealmente usaríamos um DatePicker e readOnly: true
      ),
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isEditing) {
            if (_submitForm()) {
              setState(() {
                _isEditing = !_isEditing;
              });
            }
          } else {
            setState(() {
              _isEditing = !_isEditing;
            });
          }
        },
        child: Icon(_isEditing ? Icons.check : Icons.edit),
      ),
      body: Column(
        children: [
          SettingsSubPageHeader(
            title: loc.lbPersonalInfo,
            subtitle: loc.personalInfoSubTitle,
            complement: (t, l) => _buildHeaderComplement(theme, loc),
            height: 280,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
              clipBehavior: Clip.hardEdge,
              child: Form(
                key: _formKey,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: fields.length,
                  separatorBuilder: (context, index) => Divider(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                  itemBuilder: (context, index) {
                    final field = fields[index];
                    return _buildTopicItem(theme, field);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

  Widget _buildTopicItem(ThemeData theme, _ProfileFieldConfig field) {
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
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                    child: Text(field.controller.text, style: theme.textTheme.titleSmall),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados atualizados!')),
      );
      // Aqui chamaria o BLoC: context.read<SettingsBloc>().add(UpdateProfile(...));
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

  _ProfileFieldConfig({
    required this.label,
    required this.icon,
    required this.controller,
    required this.keyboardType,
    required this.validator,
  });
}
