enum CheckoutFieldError {
  nameRequired,
  nameTooShort,
  emailRequired,
  emailInvalid,
  phoneRequired,
  phoneInvalid,
  phoneTooShort,
  phoneTooLong,
  addressRequired,
}

abstract final class CheckoutValidators {
  static const minPhoneDigits = 10;
  static const maxPhoneDigits = 15;

  static final _email = RegExp(
    r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$",
  );
  static final _phoneChars = RegExp(r'^\+?[\d\s()-]+$');

  static CheckoutFieldError? name(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return CheckoutFieldError.nameRequired;
    if (trimmed.length < 2) return CheckoutFieldError.nameTooShort;
    return null;
  }

  static CheckoutFieldError? email(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return CheckoutFieldError.emailRequired;
    if (!_email.hasMatch(trimmed) || trimmed.contains('..')) {
      return CheckoutFieldError.emailInvalid;
    }
    return null;
  }

  static CheckoutFieldError? phone(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return CheckoutFieldError.phoneRequired;
    if (!_phoneChars.hasMatch(trimmed)) return CheckoutFieldError.phoneInvalid;
    final digits = trimmed.replaceAll(RegExp(r'\D'), '').length;
    if (digits < minPhoneDigits) return CheckoutFieldError.phoneTooShort;
    if (digits > maxPhoneDigits) return CheckoutFieldError.phoneTooLong;
    return null;
  }

  static CheckoutFieldError? address(String value) =>
      value.trim().isEmpty ? CheckoutFieldError.addressRequired : null;
}
