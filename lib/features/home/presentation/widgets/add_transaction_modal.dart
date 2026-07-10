import 'package:eco_wallet/core/constants/ui_data.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eco_wallet/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:eco_wallet/features/user/presentation/bloc/user_bloc.dart';
import 'package:eco_wallet/core/utils/app_formatters.dart';
import 'package:eco_wallet/core/utils/app_validators.dart';
import 'package:eco_wallet/core/constants/category_data.dart';
import 'package:eco_wallet/features/wallet/domain/entities/transaction.dart';
import 'package:eco_wallet/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:eco_wallet/core/enums/enums.dart';
import 'package:eco_wallet/l10n/app_localizations.dart';

class AddTransactionModal extends StatefulWidget {
  const AddTransactionModal(
      {super.key, required this.transactionType, this.transactionToEdit});

  final ETransactionType transactionType;
  final Transaction? transactionToEdit;

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  DateTime _selectedDate = DateTime.now();
  String _selectedTransactionCategory = "";
  late ETransactionType _transactionType;

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isInitialized = false;
  bool get isEditing => widget.transactionToEdit != null;

  @override
  void initState() {
    super.initState();
    _transactionType = widget.transactionType;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      if (isEditing) {
        final transaction = widget.transactionToEdit!;
        final loc = AppLocalizations.of(context)!;

        _nameController.text = transaction.name;
        _amountController.text = AppFormatters.formatCurrency(
            transaction.amountAsDouble, loc.localeName,
            noSymbol: true);
        _selectedDate = transaction.date;
        _selectedTransactionCategory =
            CategoryRepository.getLabel(transaction.category, loc);
        _transactionType = transaction.type;
      }

      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom / 2),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * kModalHeightFactor,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildHeader(context),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildSelectTransactionType(context),
                    const SizedBox(height: 16),
                    _buildNameField(loc, theme),
                    const SizedBox(height: 16),
                    _buildAmountField(loc, theme),
                    const SizedBox(height: 16),
                    _buildDatePicker(context),
                    const SizedBox(height: 16),
                    _buildCategoryPicker(context),
                    const SizedBox(height: 24)
                  ],
                ),
              ),
            ),
          ),
          _buildSubmitBtn(context, theme, loc),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.transactionToEdit != null
                  ? loc.editTransaction
                  : loc.addTransaction,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectTransactionType(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final buttonWidth = media.size.width * 0.4;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _buildTypeButton(
            theme,
            ETransactionType.income,
            loc.lbIncome,
            buttonWidth,
            Icons.trending_up,
            theme.colorScheme.primaryContainer,
            theme.colorScheme.outline,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTypeButton(
            theme,
            ETransactionType.expense,
            loc.lbExpense,
            buttonWidth,
            Icons.trending_down,
            theme.colorScheme.errorContainer,
            theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeButton(
    ThemeData theme,
    ETransactionType type,
    String label,
    double width,
    IconData icon,
    Color selectedColor,
    Color unselectedColor,
  ) {
    final isSelected = _transactionType == type;

    return ChoiceChip(
      label: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
      labelStyle: TextStyle(
        color: isSelected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
      ),
      backgroundColor: unselectedColor,
      selectedColor: selectedColor,
      showCheckmark: false,
      selected: isSelected,
      side: BorderSide.none,
      onSelected: (selected) {
        setState(() {
          _transactionType = type;
        });
      },
    );
  }

  Widget _buildNameField(AppLocalizations loc, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.lbName,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: loc.hintTransactionName,
          ),
          controller: _nameController,
          validator: (value) => AppValidators.validateTitle(value, loc),
        )
      ],
    );
  }

  Widget _buildAmountField(AppLocalizations loc, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.lbAmount,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        TextFormField(
            textAlign: TextAlign.center,
            controller: _amountController,
            cursorColor: theme.colorScheme.onSurface,
            style: theme.textTheme.headlineMedium,
            keyboardType: TextInputType.number,
            inputFormatters: [
              CurrencyInputFormatter(locale: loc.localeName),
            ],
            decoration: InputDecoration(
              hintText: _amountController.text.isEmpty ? "0.00" : null,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
              hintStyle: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.outlineVariant,
              ),
            ),
            validator: (value) => AppValidators.validateAmount(loc, value))
      ],
    );
  }

  Widget _buildCategoryPicker(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.lbCategory,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 16),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: CategoryRepository.categoryCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.25),
          itemBuilder: (context, index) {
            final category = CategoryRepository.getCategoryByIndex(index);
            return _buildCategoryItem(
                theme,
                index,
                CategoryRepository.getIcon(category),
                CategoryRepository.getLabel(category, loc));
          },
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
      ThemeData theme, int index, IconData icon, String label) {
    final isSelected = _selectedTransactionCategory == label;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedTransactionCategory = label;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.lbDate,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildSubmitBtn(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: theme.colorScheme.primary,
        ),
        onPressed: () => _submitForm(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.save, color: theme.colorScheme.onPrimary),
            const SizedBox(width: 8),
            Text(
              loc.btnSave,
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: theme.colorScheme.onPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    if (_selectedTransactionCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.errorEmpty),
          margin: const EdgeInsets.all(16.0),
        ),
      );
      return;
    }

    final value =
        AppFormatters.getCurrencyValue(_amountController.text, loc.localeName);
    final amountCents = (value * 100).round();

    final entityType = _transactionType;

    const uuid = Uuid();
    final id = isEditing ? widget.transactionToEdit!.id : uuid.v4();

    // Get current user ID for new transactions
    final userBloc = context.read<UserBloc>();
    final currentUserId = (userBloc.state as UserLoadedState).user.id;
    final userId = isEditing ? widget.transactionToEdit!.userId : currentUserId;

    // Convert category label to enum
    final categoryEnum =
        CategoryRepository.fromLabel(_selectedTransactionCategory, loc);

    final newTransaction = Transaction(
      id: id,
      userId: userId,
      name: _nameController.text,
      amountCents: amountCents,
      date: _selectedDate,
      type: entityType,
      category: categoryEnum,
    );

    final walletBloc = context.read<WalletBloc>();
    final settingsState = context.read<SettingsBloc>().state;
    if (settingsState is! SettingsLoadedState) {
      return;
    }

    if (isEditing) {
      walletBloc.add(UpdateTransactionEvent(newTransaction));
    } else {
      walletBloc.add(AddTransactionEvent(
        settingsState.preferences.budgetPreferences.monthStartDay,
        newTransaction,
        budgetPreferences: settingsState.preferences.budgetPreferences,
      ));
    }

    await walletBloc.stream.firstWhere(
      (state) => state is WalletLoaded || state is WalletError,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
