// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Ma Boutique';

  @override
  String get productsTab => 'Produits';

  @override
  String get settingsTab => 'Paramètres';

  @override
  String helloUser(String name) {
    return 'Bonjour, $name!';
  }

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
      zero: 'Aucun article',
    );
    return '$_temp0';
  }

  @override
  String totalPrice(Object price) {
    return 'Total: $price';
  }

  @override
  String addedDate(Object date) {
    return 'Ajouté: $date';
  }

  @override
  String get languageLabel => 'Langue';

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String get ukrainian => 'Ukrainien';

  @override
  String get english => 'Anglais';

  @override
  String get polish => 'Polonais';

  @override
  String get french => 'Français';

  @override
  String get arabic => 'Arabe';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get add => 'Ajouter';

  @override
  String get search => 'Rechercher';

  @override
  String get loading => 'Chargement...';

  @override
  String get logout => 'Déconnexion';

  @override
  String get noProductsYet => 'Aucun produit pour l\'instant';

  @override
  String get emptyCart => 'Votre panier est vide';

  @override
  String get outOfStock => 'Rupture de stock';

  @override
  String get nameLabel => 'Nom';

  @override
  String get priceLabel => 'Prix';

  @override
  String get descriptionLabel => 'Description';

  @override
  String languageChanged(String language) {
    return 'Langue changée en $language';
  }

  @override
  String get areYouSure => 'Êtes-vous sûr?';

  @override
  String get confirmDelete => 'Voulez-vous vraiment supprimer ce produit?';

  @override
  String get productAdded => 'Produit ajouté';

  @override
  String get productDeleted => 'Produit supprimé';

  @override
  String get errorGeneric =>
      'Quelque chose s\'est mal passé. Veuillez réessayer.';

  @override
  String get nameRequired => 'Le nom est obligatoire';

  @override
  String get priceRequired => 'Le prix est obligatoire';

  @override
  String get priceInvalid => 'Entrez un prix valide';
}
