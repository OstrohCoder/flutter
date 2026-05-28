// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'متجري';

  @override
  String get productsTab => 'المنتجات';

  @override
  String get settingsTab => 'الإعدادات';

  @override
  String helloUser(String name) {
    return 'مرحباً، $name!';
  }

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منتج',
      many: '$count منتجاً',
      few: '$count منتجات',
      two: 'منتجان',
      one: 'منتج واحد',
      zero: 'لا توجد منتجات',
    );
    return '$_temp0';
  }

  @override
  String totalPrice(Object price) {
    return 'المجموع: $price';
  }

  @override
  String addedDate(Object date) {
    return 'أضيف: $date';
  }

  @override
  String get languageLabel => 'اللغة';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get ukrainian => 'الأوكرانية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get polish => 'البولندية';

  @override
  String get french => 'الفرنسية';

  @override
  String get arabic => 'العربية';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get add => 'إضافة';

  @override
  String get search => 'بحث';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get noProductsYet => 'لا توجد منتجات بعد';

  @override
  String get emptyCart => 'سلة التسوق فارغة';

  @override
  String get outOfStock => 'غير متوفر';

  @override
  String get nameLabel => 'الاسم';

  @override
  String get priceLabel => 'السعر';

  @override
  String get descriptionLabel => 'الوصف';

  @override
  String languageChanged(String language) {
    return 'تم تغيير اللغة إلى $language';
  }

  @override
  String get areYouSure => 'هل أنت متأكد؟';

  @override
  String get confirmDelete => 'هل تريد حقاً حذف هذا المنتج؟';

  @override
  String get productAdded => 'تمت إضافة المنتج';

  @override
  String get productDeleted => 'تم حذف المنتج';

  @override
  String get errorGeneric => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get priceRequired => 'السعر مطلوب';

  @override
  String get priceInvalid => 'أدخل سعراً صحيحاً';
}
