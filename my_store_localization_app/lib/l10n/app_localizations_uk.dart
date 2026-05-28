// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Мій Магазин';

  @override
  String get productsTab => 'Товари';

  @override
  String get settingsTab => 'Налаштування';

  @override
  String helloUser(String name) {
    return 'Привіт, $name!';
  }

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товарів',
      few: '$count товари',
      one: '1 товар',
      zero: 'Немає товарів',
    );
    return '$_temp0';
  }

  @override
  String totalPrice(Object price) {
    return 'Разом: $price';
  }

  @override
  String addedDate(Object date) {
    return 'Додано: $date';
  }

  @override
  String get languageLabel => 'Мова';

  @override
  String get selectLanguage => 'Оберіть мову';

  @override
  String get ukrainian => 'Українська';

  @override
  String get english => 'Англійська';

  @override
  String get polish => 'Польська';

  @override
  String get french => 'Французька';

  @override
  String get arabic => 'Арабська';

  @override
  String get save => 'Зберегти';

  @override
  String get cancel => 'Скасувати';

  @override
  String get delete => 'Видалити';

  @override
  String get edit => 'Редагувати';

  @override
  String get add => 'Додати';

  @override
  String get search => 'Пошук';

  @override
  String get loading => 'Завантаження...';

  @override
  String get logout => 'Вийти';

  @override
  String get noProductsYet => 'Товарів ще немає';

  @override
  String get emptyCart => 'Ваш кошик порожній';

  @override
  String get outOfStock => 'Немає в наявності';

  @override
  String get nameLabel => 'Назва';

  @override
  String get priceLabel => 'Ціна';

  @override
  String get descriptionLabel => 'Опис';

  @override
  String languageChanged(String language) {
    return 'Мову змінено на $language';
  }

  @override
  String get areYouSure => 'Ви впевнені?';

  @override
  String get confirmDelete => 'Ви дійсно хочете видалити цей товар?';

  @override
  String get productAdded => 'Товар додано';

  @override
  String get productDeleted => 'Товар видалено';

  @override
  String get errorGeneric => 'Щось пішло не так. Спробуйте ще раз.';

  @override
  String get nameRequired => 'Назва обов\'язкова';

  @override
  String get priceRequired => 'Ціна обов\'язкова';

  @override
  String get priceInvalid => 'Введіть коректну ціну';
}
