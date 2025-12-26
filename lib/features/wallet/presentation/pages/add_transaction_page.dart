import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/utils/app_validators.dart';
import '/core/constants/category_data.dart';
import '/features/wallet/domain/entities/transaction.dart';
import '../bloc/wallet_bloc.dart';
import '../../../../l10n/app_localizations.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key, required this.transactionType});

  final ETransactionType transactionType;

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  DateTime _selectedDate = DateTime.now();
  String _selectedTransactionCategory = "";
  late ETransactionType _transactionType;

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _transactionType = widget.transactionType;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.62,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.addTransaction,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 1,
            width: double.infinity,
            color: theme.colorScheme.outlineVariant,
          ),
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
                    _buildCategoryPicker(context),
                    const SizedBox(height: 16),
                    _buildDatePicker(context),
                    const SizedBox(height: 24)
                  ],
                ),
              ),
            ),
          ),
          _buildSaveButton(theme, loc),
          const SizedBox(height: 20),
        ],
      ),
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
            hintText: loc.formNameHint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(120),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
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
            decoration: InputDecoration(
              hintText: _amountController.text.isEmpty ? "0.00" : null,
              hintStyle: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(120),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
            ),
            validator: (value) => AppValidators.validateAmount(value, loc))
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
                theme, index, CategoryRepository.getIcon(category), CategoryRepository.getLabel(category, loc));
          },
        ),
        if (CategoryRepository.isOthersCategory(_selectedTransactionCategory, loc))
          Column(
            children: [
              const SizedBox(height: 16),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          )
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

  _selectDate(BuildContext context) async {
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

  Widget _buildSaveButton(ThemeData theme, AppLocalizations loc) {
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
        onPressed: () => _submitForm(),
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

  void _submitForm() {
    final loc = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    if (_selectedTransactionCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.errorCategoryEmpty)),
      );
      return;
    }

    String finalCategory = _selectedTransactionCategory;
    if (CategoryRepository.isOthersCategory(_selectedTransactionCategory, loc)) {
      if (_categoryController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.errorCategoryEmpty)),
        );
        return;
      } else {
        finalCategory = _categoryController.text;
      }
    }

    final value = double.tryParse(_amountController.text) ?? 0.0;
    int amount = value.floor();
    int cents = ((value - amount) * 100).round();

    final entityType = _transactionType == ETransactionType.income
        ? ETransactionType.income
        : ETransactionType.expense;

    const uuid = Uuid();
    final id = uuid.v4();

    final newTransaction = Transaction(
      id: id,
      name: _nameController.text,
      amount: amount,
      cents: cents,
      date: _selectedDate,
      type: entityType,
      category: finalCategory,
    );

    context.read<WalletBloc>().add(AddTransactionEvent(newTransaction));

    Navigator.of(context).pop();
  }
}

