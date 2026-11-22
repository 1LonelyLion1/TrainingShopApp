import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horns_and_hooves_shop_app/core/error/app_failure.dart';
import 'package:horns_and_hooves_shop_app/core/error/app_failure_l10n.dart';
import 'package:horns_and_hooves_shop_app/features/checkout/domain/checkout_validators.dart';
import 'package:horns_and_hooves_shop_app/features/checkout/presentation/checkout_error_l10n.dart';
import 'package:horns_and_hooves_shop_app/l10n/l10n.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('ru'));

  test('у каждого типа ошибки своё сообщение', () {
    const failures = <AppFailure>[
      NoConnectionFailure(),
      TimeoutFailure(),
      ServerFailure(503),
      ClientFailure(404),
      EmptyResponseFailure(),
      InvalidDataFailure(),
      UnknownFailure(),
    ];

    final messages = failures.map((f) => f.localized(l10n)).toSet();

    expect(messages, hasLength(failures.length));
    expect(const ServerFailure(503).localized(l10n), contains('503'));
    expect(const ClientFailure(404).localized(l10n), contains('404'));
  });

  test('ошибки телефона склоняются и содержат лимит', () {
    expect(CheckoutFieldError.phoneTooShort.localized(l10n), 'Минимум 10 цифр');
    expect(CheckoutFieldError.phoneTooLong.localized(l10n), 'Максимум 15 цифр');
  });
}
