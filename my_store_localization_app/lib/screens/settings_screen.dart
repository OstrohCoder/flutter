import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_store_localization_app/l10n/app_localizations.dart';
import '../models/language_model.dart';
import '../providers/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTab)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.languageLabel),
            subtitle: Text(l10n.selectLanguage),
          ),
          const Divider(),

          // Список мов
          ...LanguageModel.languages.map((language) {
            final isSelected =
                localeProvider.locale.languageCode == language.code;

            return RadioListTile<String>(
              value: language.code,
              groupValue: localeProvider.locale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  localeProvider.setLocale(Locale(value));

                  // Показати SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.languageChanged(language.name)),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
              title: Row(
                children: [
                  Text(language.flag, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Text(language.name),
                ],
              ),
              selected: isSelected,
            );
          }),
        ],
      ),
    );
  }
}
