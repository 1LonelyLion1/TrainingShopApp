// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Рога и копыта';

  @override
  String get retry => 'Повторить';

  @override
  String get refresh => 'Обновить';

  @override
  String get goToCatalog => 'Перейти в каталог';

  @override
  String get filtersTooltip => 'Фильтры';

  @override
  String get navCatalog => 'Каталог';

  @override
  String get navCart => 'Корзина';

  @override
  String get navSettings => 'Настройки';

  @override
  String get offlineNoData => 'Нет соединения';

  @override
  String get offlineWithCache => 'Нет соединения. Показаны сохранённые товары.';

  @override
  String get catalogLoadError => 'Не удалось загрузить каталог';

  @override
  String get catalogEmptyTitle => 'Каталог пуст';

  @override
  String get catalogEmptyMessage => 'Товары пока не добавлены.';

  @override
  String get nothingFoundTitle => 'Ничего не найдено';

  @override
  String get nothingFoundMessage => 'Измените условия фильтра.';

  @override
  String get resetFilters => 'Сбросить фильтры';

  @override
  String get filtersTitle => 'Фильтры';

  @override
  String get filterCategory => 'Категория';

  @override
  String get filterAll => 'Все';

  @override
  String get filterPrice => 'Цена, \$';

  @override
  String get filterFrom => 'От';

  @override
  String get filterTo => 'До';

  @override
  String get filterAmountInvalid => 'Введите сумму';

  @override
  String get filterRangeInvalid => '«От» больше, чем «до»';

  @override
  String get filterApply => 'Применить';

  @override
  String get categoryElectronics => 'Электроника';

  @override
  String get categoryJewelery => 'Украшения';

  @override
  String get categoryMens => 'Мужская одежда';

  @override
  String get categoryWomens => 'Женская одежда';

  @override
  String get categoryNone => 'Без категории';

  @override
  String get productNotFound => 'Товар не найден';

  @override
  String get addToCart => 'В корзину';

  @override
  String inCart(int quantity) {
    return 'В корзине: $quantity';
  }

  @override
  String get goToCart => 'В корзину';

  @override
  String get cartTitle => 'Корзина';

  @override
  String get cartEmpty => 'Корзина пуста';

  @override
  String get cartDecrease => 'Уменьшить';

  @override
  String get cartIncrease => 'Увеличить';

  @override
  String get cartRemove => 'Удалить';

  @override
  String get cartTotal => 'Итого';

  @override
  String get cartCheckout => 'Оформить заказ';

  @override
  String get checkoutTitle => 'Оформление заказа';

  @override
  String checkoutSubmit(String total) {
    return 'Оформить · $total';
  }

  @override
  String get fieldName => 'Имя';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPhone => 'Телефон';

  @override
  String get fieldAddress => 'Адрес';

  @override
  String get validationNameRequired => 'Укажите имя';

  @override
  String get validationNameTooShort => 'Имя слишком короткое';

  @override
  String get validationEmailRequired => 'Укажите email';

  @override
  String get validationEmailInvalid => 'Некорректный email';

  @override
  String get validationPhoneRequired => 'Укажите телефон';

  @override
  String get validationPhoneInvalid => 'Некорректный номер телефона';

  @override
  String validationPhoneTooShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Минимум $count цифры',
      many: 'Минимум $count цифр',
      few: 'Минимум $count цифры',
      one: 'Минимум $count цифра',
    );
    return '$_temp0';
  }

  @override
  String validationPhoneTooLong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Максимум $count цифры',
      many: 'Максимум $count цифр',
      few: 'Максимум $count цифры',
      one: 'Максимум $count цифра',
    );
    return '$_temp0';
  }

  @override
  String get validationAddressRequired => 'Укажите адрес';

  @override
  String get orderSuccessTitle => 'Заказ оформлен';

  @override
  String orderNumber(String number) {
    return 'Номер заказа: $number';
  }

  @override
  String get backToCatalog => 'Вернуться в каталог';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get languageSystem => 'Системный';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get errorNoConnection =>
      'Нет соединения. Проверьте интернет и повторите.';

  @override
  String get errorTimeout => 'Сервер долго не отвечает. Попробуйте ещё раз.';

  @override
  String errorServer(String code) {
    return 'Ошибка на стороне сервера ($code). Попробуйте позже.';
  }

  @override
  String errorClient(String code) {
    return 'Не удалось выполнить запрос ($code). Обновите приложение или попробуйте позже.';
  }

  @override
  String get errorEmptyResponse =>
      'Сервер вернул пустой ответ. Попробуйте ещё раз.';

  @override
  String get errorInvalidData => 'Сервер вернул данные в неверном формате.';

  @override
  String get errorUnknown => 'Что-то пошло не так. Попробуйте ещё раз.';
}
