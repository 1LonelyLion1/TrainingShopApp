// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Horns & Hooves';

  @override
  String get retry => 'Retry';

  @override
  String get refresh => 'Refresh';

  @override
  String get goToCatalog => 'Go to catalog';

  @override
  String get filtersTooltip => 'Filters';

  @override
  String get navCatalog => 'Catalog';

  @override
  String get navCart => 'Cart';

  @override
  String get navSettings => 'Settings';

  @override
  String get offlineNoData => 'No connection';

  @override
  String get offlineWithCache => 'No connection. Showing saved products.';

  @override
  String get catalogLoadError => 'Couldn\'t load the catalog';

  @override
  String get catalogEmptyTitle => 'The catalog is empty';

  @override
  String get catalogEmptyMessage => 'No products have been added yet.';

  @override
  String get nothingFoundTitle => 'Nothing found';

  @override
  String get nothingFoundMessage => 'Try changing the filters.';

  @override
  String get resetFilters => 'Reset filters';

  @override
  String get filtersTitle => 'Filters';

  @override
  String get filterCategory => 'Category';

  @override
  String get filterAll => 'All';

  @override
  String get filterPrice => 'Price, \$';

  @override
  String get filterFrom => 'From';

  @override
  String get filterTo => 'To';

  @override
  String get filterAmountInvalid => 'Enter an amount';

  @override
  String get filterRangeInvalid => '“From” is greater than “To”';

  @override
  String get filterApply => 'Apply';

  @override
  String get categoryElectronics => 'Electronics';

  @override
  String get categoryJewelery => 'Jewelry';

  @override
  String get categoryMens => 'Men\'s clothing';

  @override
  String get categoryWomens => 'Women\'s clothing';

  @override
  String get categoryNone => 'Uncategorized';

  @override
  String get productNotFound => 'Product not found';

  @override
  String get addToCart => 'Add to cart';

  @override
  String inCart(int quantity) {
    return 'In cart: $quantity';
  }

  @override
  String get goToCart => 'Go to cart';

  @override
  String get cartTitle => 'Cart';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get cartDecrease => 'Decrease';

  @override
  String get cartIncrease => 'Increase';

  @override
  String get cartRemove => 'Remove';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartCheckout => 'Check out';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String checkoutSubmit(String total) {
    return 'Place order · $total';
  }

  @override
  String get fieldName => 'Name';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPhone => 'Phone';

  @override
  String get fieldAddress => 'Address';

  @override
  String get validationNameRequired => 'Enter your name';

  @override
  String get validationNameTooShort => 'Name is too short';

  @override
  String get validationEmailRequired => 'Enter your email';

  @override
  String get validationEmailInvalid => 'Invalid email';

  @override
  String get validationPhoneRequired => 'Enter your phone number';

  @override
  String get validationPhoneInvalid => 'Invalid phone number';

  @override
  String validationPhoneTooShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'At least $count digits',
      one: 'At least $count digit',
    );
    return '$_temp0';
  }

  @override
  String validationPhoneTooLong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'At most $count digits',
      one: 'At most $count digit',
    );
    return '$_temp0';
  }

  @override
  String get validationAddressRequired => 'Enter your address';

  @override
  String get orderSuccessTitle => 'Order placed';

  @override
  String orderNumber(String number) {
    return 'Order number: $number';
  }

  @override
  String get backToCatalog => 'Back to catalog';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get errorNoConnection =>
      'No connection. Check your internet and try again.';

  @override
  String get errorTimeout =>
      'The server is taking too long to respond. Try again.';

  @override
  String errorServer(String code) {
    return 'Server error ($code). Try again later.';
  }

  @override
  String errorClient(String code) {
    return 'The request failed ($code). Update the app or try again later.';
  }

  @override
  String get errorEmptyResponse =>
      'The server returned an empty response. Try again.';

  @override
  String get errorInvalidData =>
      'The server returned data in an invalid format.';

  @override
  String get errorUnknown => 'Something went wrong. Try again.';
}
