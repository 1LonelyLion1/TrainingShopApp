import '../../../l10n/l10n.dart';

/// API отдаёт категории на английском, неизвестные показываем как есть.
String categoryLabel(AppLocalizations l10n, String category) =>
    switch (category) {
      'electronics' => l10n.categoryElectronics,
      'jewelery' => l10n.categoryJewelery,
      "men's clothing" => l10n.categoryMens,
      "women's clothing" => l10n.categoryWomens,
      '' => l10n.categoryNone,
      _ => category,
    };
