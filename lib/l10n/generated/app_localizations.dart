import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'Рога и копыта'**
  String get appTitle;

  /// No description provided for @retry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// No description provided for @refresh.
  ///
  /// In ru, this message translates to:
  /// **'Обновить'**
  String get refresh;

  /// No description provided for @goToCatalog.
  ///
  /// In ru, this message translates to:
  /// **'Перейти в каталог'**
  String get goToCatalog;

  /// No description provided for @filtersTooltip.
  ///
  /// In ru, this message translates to:
  /// **'Фильтры'**
  String get filtersTooltip;

  /// No description provided for @navCatalog.
  ///
  /// In ru, this message translates to:
  /// **'Каталог'**
  String get navCatalog;

  /// No description provided for @navCart.
  ///
  /// In ru, this message translates to:
  /// **'Корзина'**
  String get navCart;

  /// No description provided for @navSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get navSettings;

  /// No description provided for @offlineNoData.
  ///
  /// In ru, this message translates to:
  /// **'Нет соединения'**
  String get offlineNoData;

  /// No description provided for @offlineWithCache.
  ///
  /// In ru, this message translates to:
  /// **'Нет соединения. Показаны сохранённые товары.'**
  String get offlineWithCache;

  /// No description provided for @catalogLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить каталог'**
  String get catalogLoadError;

  /// No description provided for @catalogEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Каталог пуст'**
  String get catalogEmptyTitle;

  /// No description provided for @catalogEmptyMessage.
  ///
  /// In ru, this message translates to:
  /// **'Товары пока не добавлены.'**
  String get catalogEmptyMessage;

  /// No description provided for @nothingFoundTitle.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get nothingFoundTitle;

  /// No description provided for @nothingFoundMessage.
  ///
  /// In ru, this message translates to:
  /// **'Измените условия фильтра.'**
  String get nothingFoundMessage;

  /// No description provided for @resetFilters.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить фильтры'**
  String get resetFilters;

  /// No description provided for @filtersTitle.
  ///
  /// In ru, this message translates to:
  /// **'Фильтры'**
  String get filtersTitle;

  /// No description provided for @filterCategory.
  ///
  /// In ru, this message translates to:
  /// **'Категория'**
  String get filterCategory;

  /// No description provided for @filterAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get filterAll;

  /// No description provided for @filterPrice.
  ///
  /// In ru, this message translates to:
  /// **'Цена, \$'**
  String get filterPrice;

  /// No description provided for @filterFrom.
  ///
  /// In ru, this message translates to:
  /// **'От'**
  String get filterFrom;

  /// No description provided for @filterTo.
  ///
  /// In ru, this message translates to:
  /// **'До'**
  String get filterTo;

  /// No description provided for @filterAmountInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Введите сумму'**
  String get filterAmountInvalid;

  /// No description provided for @filterRangeInvalid.
  ///
  /// In ru, this message translates to:
  /// **'«От» больше, чем «до»'**
  String get filterRangeInvalid;

  /// No description provided for @filterApply.
  ///
  /// In ru, this message translates to:
  /// **'Применить'**
  String get filterApply;

  /// No description provided for @categoryElectronics.
  ///
  /// In ru, this message translates to:
  /// **'Электроника'**
  String get categoryElectronics;

  /// No description provided for @categoryJewelery.
  ///
  /// In ru, this message translates to:
  /// **'Украшения'**
  String get categoryJewelery;

  /// No description provided for @categoryMens.
  ///
  /// In ru, this message translates to:
  /// **'Мужская одежда'**
  String get categoryMens;

  /// No description provided for @categoryWomens.
  ///
  /// In ru, this message translates to:
  /// **'Женская одежда'**
  String get categoryWomens;

  /// No description provided for @categoryNone.
  ///
  /// In ru, this message translates to:
  /// **'Без категории'**
  String get categoryNone;

  /// No description provided for @productNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Товар не найден'**
  String get productNotFound;

  /// No description provided for @addToCart.
  ///
  /// In ru, this message translates to:
  /// **'В корзину'**
  String get addToCart;

  /// No description provided for @inCart.
  ///
  /// In ru, this message translates to:
  /// **'В корзине: {quantity}'**
  String inCart(int quantity);

  /// No description provided for @goToCart.
  ///
  /// In ru, this message translates to:
  /// **'В корзину'**
  String get goToCart;

  /// No description provided for @cartTitle.
  ///
  /// In ru, this message translates to:
  /// **'Корзина'**
  String get cartTitle;

  /// No description provided for @cartEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Корзина пуста'**
  String get cartEmpty;

  /// No description provided for @cartDecrease.
  ///
  /// In ru, this message translates to:
  /// **'Уменьшить'**
  String get cartDecrease;

  /// No description provided for @cartIncrease.
  ///
  /// In ru, this message translates to:
  /// **'Увеличить'**
  String get cartIncrease;

  /// No description provided for @cartRemove.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get cartRemove;

  /// No description provided for @cartTotal.
  ///
  /// In ru, this message translates to:
  /// **'Итого'**
  String get cartTotal;

  /// No description provided for @cartCheckout.
  ///
  /// In ru, this message translates to:
  /// **'Оформить заказ'**
  String get cartCheckout;

  /// No description provided for @checkoutTitle.
  ///
  /// In ru, this message translates to:
  /// **'Оформление заказа'**
  String get checkoutTitle;

  /// No description provided for @checkoutSubmit.
  ///
  /// In ru, this message translates to:
  /// **'Оформить · {total}'**
  String checkoutSubmit(String total);

  /// No description provided for @fieldName.
  ///
  /// In ru, this message translates to:
  /// **'Имя'**
  String get fieldName;

  /// No description provided for @fieldEmail.
  ///
  /// In ru, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// No description provided for @fieldPhone.
  ///
  /// In ru, this message translates to:
  /// **'Телефон'**
  String get fieldPhone;

  /// No description provided for @fieldAddress.
  ///
  /// In ru, this message translates to:
  /// **'Адрес'**
  String get fieldAddress;

  /// No description provided for @validationNameRequired.
  ///
  /// In ru, this message translates to:
  /// **'Укажите имя'**
  String get validationNameRequired;

  /// No description provided for @validationNameTooShort.
  ///
  /// In ru, this message translates to:
  /// **'Имя слишком короткое'**
  String get validationNameTooShort;

  /// No description provided for @validationEmailRequired.
  ///
  /// In ru, this message translates to:
  /// **'Укажите email'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Некорректный email'**
  String get validationEmailInvalid;

  /// No description provided for @validationPhoneRequired.
  ///
  /// In ru, this message translates to:
  /// **'Укажите телефон'**
  String get validationPhoneRequired;

  /// No description provided for @validationPhoneInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Некорректный номер телефона'**
  String get validationPhoneInvalid;

  /// No description provided for @validationPhoneTooShort.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{Минимум {count} цифра} few{Минимум {count} цифры} many{Минимум {count} цифр} other{Минимум {count} цифры}}'**
  String validationPhoneTooShort(int count);

  /// No description provided for @validationPhoneTooLong.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{Максимум {count} цифра} few{Максимум {count} цифры} many{Максимум {count} цифр} other{Максимум {count} цифры}}'**
  String validationPhoneTooLong(int count);

  /// No description provided for @validationAddressRequired.
  ///
  /// In ru, this message translates to:
  /// **'Укажите адрес'**
  String get validationAddressRequired;

  /// No description provided for @orderSuccessTitle.
  ///
  /// In ru, this message translates to:
  /// **'Заказ оформлен'**
  String get orderSuccessTitle;

  /// No description provided for @orderNumber.
  ///
  /// In ru, this message translates to:
  /// **'Номер заказа: {number}'**
  String orderNumber(String number);

  /// No description provided for @backToCatalog.
  ///
  /// In ru, this message translates to:
  /// **'Вернуться в каталог'**
  String get backToCatalog;

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In ru, this message translates to:
  /// **'Системный'**
  String get languageSystem;

  /// No description provided for @languageRussian.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In ru, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @errorNoConnection.
  ///
  /// In ru, this message translates to:
  /// **'Нет соединения. Проверьте интернет и повторите.'**
  String get errorNoConnection;

  /// No description provided for @errorTimeout.
  ///
  /// In ru, this message translates to:
  /// **'Сервер долго не отвечает. Попробуйте ещё раз.'**
  String get errorTimeout;

  /// No description provided for @errorServer.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка на стороне сервера ({code}). Попробуйте позже.'**
  String errorServer(String code);

  /// No description provided for @errorClient.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось выполнить запрос ({code}). Обновите приложение или попробуйте позже.'**
  String errorClient(String code);

  /// No description provided for @errorEmptyResponse.
  ///
  /// In ru, this message translates to:
  /// **'Сервер вернул пустой ответ. Попробуйте ещё раз.'**
  String get errorEmptyResponse;

  /// No description provided for @errorInvalidData.
  ///
  /// In ru, this message translates to:
  /// **'Сервер вернул данные в неверном формате.'**
  String get errorInvalidData;

  /// No description provided for @errorUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Что-то пошло не так. Попробуйте ещё раз.'**
  String get errorUnknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
