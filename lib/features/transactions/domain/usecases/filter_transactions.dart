import '../../../wallet/domain/entities/transaction.dart';

class FilterTransactions {
  List<Transaction> call(FilterParams params) {
    if (params.filters.isEmpty) return params.allTransactions;

    return params.allTransactions.where((t) {
      // Exemplo: Filtros são "income", "expense".
      // Verificamos se o tipo da transação está na lista de filtros ativos.
      return params.filters
          .contains(t.type.toString()); // Ajuste conforme seu Enum
    }).toList();
  }
}

class FilterParams {
  final List<Transaction> allTransactions;
  final List<String> filters;

  FilterParams({
    required this.allTransactions,
    required this.filters,
  });
}
