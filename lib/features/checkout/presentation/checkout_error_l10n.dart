import '../../../l10n/l10n.dart';
import '../domain/checkout_validators.dart';

extension CheckoutFieldErrorL10n on CheckoutFieldError {
  String localized(AppLocalizations l10n) => switch (this) {
    CheckoutFieldError.nameRequired => l10n.validationNameRequired,
    CheckoutFieldError.nameTooShort => l10n.validationNameTooShort,
    CheckoutFieldError.emailRequired => l10n.validationEmailRequired,
    CheckoutFieldError.emailInvalid => l10n.validationEmailInvalid,
    CheckoutFieldError.phoneRequired => l10n.validationPhoneRequired,
    CheckoutFieldError.phoneInvalid => l10n.validationPhoneInvalid,
    CheckoutFieldError.phoneTooShort => l10n.validationPhoneTooShort(
      CheckoutValidators.minPhoneDigits,
    ),
    CheckoutFieldError.phoneTooLong => l10n.validationPhoneTooLong(
      CheckoutValidators.maxPhoneDigits,
    ),
    CheckoutFieldError.addressRequired => l10n.validationAddressRequired,
  };
}
