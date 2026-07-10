import 'package:eco_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:eco_wallet/features/wallet/domain/entities/transaction.dart';
import 'package:eco_wallet/core/enums/enums.dart';
import 'package:eco_wallet/core/constants/transaction_type_data.dart';
import 'package:eco_wallet/core/constants/category_data.dart';

class TransactionFilter {
  final ETransactionType? type;
  final List<ETransactionCategory> categories;
  final DateTimeRange? dateRange;
  final double? minAmount;
  final double? maxAmount;

  const TransactionFilter({
    this.type,
    this.categories = const [],
    this.dateRange,
    this.minAmount,
    this.maxAmount,
  });

  bool get isEmpty {
    return type == null && categories.isEmpty && dateRange == null && minAmount == null && maxAmount == null;
  }

  int get length {
    int count = 0;
    if (type != null) count++;
    count += categories.length;
    if (dateRange != null) count++;
    if (minAmount != null) count++;
    if (maxAmount != null) count++;
    return count;
  }

  factory TransactionFilter.empty() => const TransactionFilter();

  TransactionFilter copyWith({
    ETransactionType? type,
    List<ETransactionCategory>? categories,
    DateTimeRange? dateRange,
    double? minAmount,
    double? maxAmount,
  }) {
    return TransactionFilter(
      type: type ?? this.type,
      categories: categories ?? this.categories,
      dateRange: dateRange ?? this.dateRange,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
    );
  }

  bool apply(Transaction t) {
    if (type != null && t.type != type) return false;

    if (categories.isNotEmpty && !categories.contains(t.category)) return false;

    if (dateRange != null) {
      if (t.date.isBefore(dateRange!.start) || t.date.isAfter(dateRange!.end)) {
        return false;
      }
    }

    double absAmount = t.amountAsDouble;
    if (minAmount != null && absAmount < minAmount!) return false;
    if (maxAmount != null && absAmount > maxAmount!) return false;

    return true;
  }

  List<String> getFilters(AppLocalizations loc) {
    final filters = <String>[];

    if (type != null) {
      filters.add(TransactionTypeRepository.getLabel(type!, loc));
    }

    if (categories.isNotEmpty) {
      for (final category in categories) {
        filters.add(CategoryRepository.getLabel(category, loc));
      }
    }

    if (dateRange != null) {
      filters.add(
          '${dateRange!.start.toLocal().toString().split(' ')[0]} / ${dateRange!.end.toLocal().toString().split(' ')[0]}');
    }

    if (minAmount != null) {
      filters.add('Min: $minAmount');
    }

    if (maxAmount != null) {
      filters.add('Max: $maxAmount');
    }

    return filters;
  }

  TransactionFilter deleteFilter(String filter, AppLocalizations loc) {
    // Find category by label
    ETransactionCategory? categoryToRemove;
    for (final category in categories) {
      if (CategoryRepository.getLabel(category, loc) == filter) {
        categoryToRemove = category;
        break;
      }
    }

    return copyWith(
      type: (type != null && TransactionTypeRepository.getLabel(type!, loc) == filter) ? null : type,
      categories: categoryToRemove != null
          ? categories.where((c) => c != categoryToRemove).toList()
          : categories,
      dateRange: (dateRange != null && '${dateRange!.start.toLocal()} - ${dateRange!.end.toLocal()}' == filter)
          ? null
          : dateRange,
    );
  }
}

