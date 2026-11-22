import 'package:flutter/material.dart';

import '../../../core/utils/money.dart';
import '../../../l10n/l10n.dart';
import '../domain/catalog_filter.dart';
import 'category_label.dart';

/// Возвращает выбранный фильтр или null, если лист закрыт без применения.
Future<CatalogFilter?> showFilterSheet(
  BuildContext context, {
  required CatalogFilter filter,
  required List<String> categories,
}) => showModalBottomSheet<CatalogFilter>(
  context: context,
  // Иначе лист откроется внутри вкладки и окажется под нижней панелью.
  useRootNavigator: true,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => FilterSheet(filter: filter, categories: categories),
);

class FilterSheet extends StatefulWidget {
  const FilterSheet({
    super.key,
    required this.filter,
    required this.categories,
  });

  final CatalogFilter filter;
  final List<String> categories;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late String? _category = widget.filter.category;
  late final _min = TextEditingController(
    text: _initial(widget.filter.minCents),
  );
  late final _max = TextEditingController(
    text: _initial(widget.filter.maxCents),
  );

  static String _initial(int? cents) =>
      cents == null ? '' : (cents / 100).toStringAsFixed(2);

  int? _parse(TextEditingController controller) =>
      controller.text.trim().isEmpty ? null : parseCents(controller.text);

  String? _fieldError(TextEditingController controller) =>
      controller.text.trim().isNotEmpty && parseCents(controller.text) == null
      ? context.l10n.filterAmountInvalid
      : null;

  String? get _rangeError {
    final min = _parse(_min);
    final max = _parse(_max);
    return min != null && max != null && min > max
        ? context.l10n.filterRangeInvalid
        : null;
  }

  bool get _canApply =>
      _fieldError(_min) == null &&
      _fieldError(_max) == null &&
      _rangeError == null;

  @override
  void dispose() {
    _min.dispose();
    _max.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(context.l10n.filtersTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Text(
              context.l10n.filterCategory,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                ChoiceChip(
                  label: Text(context.l10n.filterAll),
                  selected: _category == null,
                  onSelected: (_) => setState(() => _category = null),
                ),
                for (final category in widget.categories)
                  ChoiceChip(
                    label: Text(categoryLabel(context.l10n, category)),
                    selected: _category == category,
                    onSelected: (_) => setState(() => _category = category),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(context.l10n.filterPrice, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _priceField(
                    _min,
                    context.l10n.filterFrom,
                    _fieldError(_min),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _priceField(
                    _max,
                    context.l10n.filterTo,
                    _fieldError(_max) ?? _rangeError,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _canApply
                  ? () => Navigator.pop(
                      context,
                      CatalogFilter(
                        category: _category,
                        minCents: _parse(_min),
                        maxCents: _parse(_max),
                      ),
                    )
                  : null,
              child: Text(context.l10n.filterApply),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pop(context, const CatalogFilter()),
              child: Text(context.l10n.resetFilters),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceField(
    TextEditingController controller,
    String label,
    String? error,
  ) => TextField(
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    onChanged: (_) => setState(() {}),
    decoration: InputDecoration(
      labelText: label,
      errorText: error,
      border: const OutlineInputBorder(),
    ),
  );
}
