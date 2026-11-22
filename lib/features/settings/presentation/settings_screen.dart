import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/l10n.dart';
import 'locale_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: BlocBuilder<LocaleCubit, Locale?>(
        builder: (context, selected) => ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                l10n.settingsLanguage,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            _LanguageTile(
              title: l10n.languageSystem,
              locale: null,
              selected: selected,
            ),
            _LanguageTile(
              title: l10n.languageRussian,
              locale: const Locale('ru'),
              selected: selected,
            ),
            _LanguageTile(
              title: l10n.languageEnglish,
              locale: const Locale('en'),
              selected: selected,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.locale,
    required this.selected,
  });

  final String title;
  final Locale? locale;
  final Locale? selected;

  @override
  Widget build(BuildContext context) {
    final isSelected = locale == selected;
    return ListTile(
      title: Text(title),
      selected: isSelected,
      trailing: isSelected ? const Icon(Icons.check) : null,
      onTap: () => context.read<LocaleCubit>().select(locale),
    );
  }
}
