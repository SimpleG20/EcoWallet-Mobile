import 'package:eco_wallet/core/constants/transaction_type_data.dart';
import 'package:eco_wallet/core/constants/ui_data.dart';
import 'package:eco_wallet/core/presentation/widgets/sensitive_text.dart';
import 'package:eco_wallet/features/settings/domain/enums/settings_enums.dart';
import 'package:eco_wallet/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eco_wallet/l10n/app_localizations.dart';
import 'package:eco_wallet/core/constants/category_data.dart';

import 'package:eco_wallet/features/transactions/presentation/bloc/transactions_history_bloc.dart';
import 'package:eco_wallet/features/transactions/presentation/bloc/transactions_history_event.dart';
import 'package:eco_wallet/features/transactions/domain/entities/transactions_filter.dart';
import 'package:eco_wallet/core/enums/enums.dart';
import 'package:eco_wallet/core/utils/app_formatters.dart';

class TransactionFilterModal extends StatefulWidget {
  final TransactionFilter currentFilter;

  const TransactionFilterModal({super.key, required this.currentFilter});

  @override
  State<TransactionFilterModal> createState() => _TransactionFilterModalState();
}

class _TransactionFilterModalState extends State<TransactionFilterModal> {
  static const double kMaxAmountLimit = 20000.0;
  final List<ETransactionCategory> _selectedCategories = [];

  late RangeValues _currentRangeValues;

  int _division = 1000;
  double _currentMinAmount = 0;
  double _currentMaxAmount = kMaxAmountLimit;
  ETransactionType? _selectedType;
  DateTimeRange? _selectedDateRange;

  @override
  void didChangeDependencies() {
    var currentFilter = widget.currentFilter;
    _selectedType = currentFilter.type;
    _selectedDateRange = currentFilter.dateRange;
    _selectedCategories.addAll(currentFilter.categories);

    _currentRangeValues = RangeValues(
      currentFilter.minAmount ?? 0,
      currentFilter.maxAmount ?? kMaxAmountLimit,
    );

    _currentMinAmount = _currentRangeValues.start;
    _currentMaxAmount = _currentRangeValues.end;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);

    return BlocBuilder<SettingsBloc, BaseSettingsState>(
      builder: (context, state) {
        if (state is! SettingsLoadedState) {
          return const SizedBox.shrink();
        }

        final appearancePreferences = state.preferences.appearancePreferences;

        return Container(
          height: mediaQuery.size.height * kModalHeightFactor,
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    loc.filterTransactions,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _clearFilters(loc),
                    child: Text(loc.btnClear),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Type
                      _buildTypeSection(theme, loc),
                      const SizedBox(height: 24),

                      // Amount
                      _buildPriceRangeSection(theme, loc, appearancePreferences.currencyFormat),
                      const SizedBox(height: 24),

                      // Date
                      _buildDateSection(theme, loc),
                      const SizedBox(height: 24),

                      // Category
                      _buildCategorySection(theme, loc)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _applyFilters(loc),
                child: Text(loc.btnApply),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildTypeSection(ThemeData theme, AppLocalizations loc) {
    var options = [
      _TransactionEnumData(null, loc.lbAll),
      _TransactionEnumData(ETransactionType.income, TransactionTypeRepository.getLabel(ETransactionType.income, loc)),
      _TransactionEnumData(ETransactionType.expense, TransactionTypeRepository.getLabel(ETransactionType.expense, loc)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(theme, loc.lbType),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              options.length,
              (index) {
                final e = options[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildTypeChip(theme, e.type, e.label),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeChip(ThemeData theme, ETransactionType? type, String label) {
    final isSelected = _selectedType == type;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _selectedType = type;
        });
      },
      checkmarkColor: theme.colorScheme.onPrimaryContainer,
      selectedColor: theme.colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildPriceRangeSection(ThemeData theme, AppLocalizations loc, CurrencyFormat currencyFormat) {
    final startLabel =
        AppFormatters.formatCurrencyWithPreference(_currentRangeValues.start, currencyFormat, loc.localeName);
    final endLabel = _currentRangeValues.end >= kMaxAmountLimit
        ? "$kMaxAmountLimit+"
        : AppFormatters.formatCurrencyWithPreference(_currentRangeValues.end, currencyFormat, loc.localeName);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle(theme, loc.lbAmount),
            const Spacer(),
            if (_currentRangeValues.start != 0 || _currentRangeValues.end != kMaxAmountLimit)
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentRangeValues = RangeValues(0, kMaxAmountLimit);
                    _currentMinAmount = 0;
                    _currentMaxAmount = kMaxAmountLimit;
                    _division = _getDivisions(_currentMaxAmount);
                  });
                },
                child: Text(loc.btnClear),
              ),
          ],
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: _currentRangeValues,
          min: _currentMinAmount,
          max: _currentMaxAmount,
          divisions: _division,
          activeColor: theme.colorScheme.primary,
          inactiveColor: theme.colorScheme.outlineVariant,
          labels: RangeLabels(startLabel, endLabel),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
          onChangeEnd: (value) => {
            setState(() {
              _currentMinAmount = value.start;
              _currentMaxAmount = value.end;
              _division = _getDivisions(_currentMaxAmount);
            })
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppFormatters.formatCurrencyWithPreference(_currentMinAmount, currencyFormat, loc.localeName),
                  style: theme.textTheme.bodySmall),
              SensitiveText(
                text:
                    "${AppFormatters.formatCurrencyWithPreference(_currentMaxAmount, currencyFormat, loc.localeName)}+",
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  int _getDivisions(double maxAmount) {
    if (maxAmount <= 100) return 10;
    if (maxAmount <= 1000) return 100;
    if (maxAmount <= 10000) return 1000;
    return 10000;
  }

  Widget _buildDateSection(ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(theme, loc.lbDate),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: _selectedDateRange,
                builder: (context, child) {
                  return Theme(
                    data: theme.copyWith(
                      colorScheme: theme.colorScheme.copyWith(
                        surface: theme.colorScheme.surfaceContainerHigh,
                      ),
                    ),
                    child: child!,
                  );
                });
            if (picked != null) {
              setState(() => _selectedDateRange = picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  _selectedDateRange == null
                      ? (loc.lbSelectDateRange)
                      : "${AppFormatters.dateOnlyFormatter.format(_selectedDateRange!.start)} - ${AppFormatters.dateOnlyFormatter.format(_selectedDateRange!.end)}",
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(theme, loc.lbCategory),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(CategoryRepository.categoryCount, (index) {
            final category = CategoryRepository.getCategoryByIndex(index);
            final label = CategoryRepository.getLabel(category, loc);
            return _buildCategoryChip(theme, category, label);
          }),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(ThemeData theme, ETransactionCategory category, String label) {
    final isSelected = _selectedCategories.contains(category);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _selectedCategories.add(category);
          } else {
            _selectedCategories.remove(category);
          }
        });
      },
    );
  }

  void _clearFilters(AppLocalizations loc) {
    setState(() {
      _selectedType = null;
      _selectedDateRange = null;
      _selectedCategories.clear();
    });
  }

  void _applyFilters(AppLocalizations loc) {
    final newFilter = TransactionFilter(
      type: _selectedType,
      dateRange: _selectedDateRange,
      categories: List.from(_selectedCategories),
      minAmount: _currentRangeValues.start,
      maxAmount: _currentRangeValues.end >= kMaxAmountLimit ? kMaxAmountLimit : _currentRangeValues.end,
    );

    context.read<TransactionsHistoryBloc>().add(UpdateFiltersEvent(newFilter));
    Navigator.pop(context);
  }
}

class _TransactionEnumData {
  final ETransactionType? type;
  final String label;
  _TransactionEnumData(this.type, this.label);
}
