import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart' show injectable;

import '../../cart/presentation/cart_cubit.dart';
import '../domain/checkout_validators.dart';
import '../domain/usecases/place_order.dart';

enum CheckoutField { name, email, phone, address }

class CheckoutState extends Equatable {
  const CheckoutState({
    this.values = const {},
    this.touched = const {},
    this.orderNumber,
  });

  final Map<CheckoutField, String> values;
  final Set<CheckoutField> touched;
  final String? orderNumber;

  CheckoutFieldError? _validate(CheckoutField field) {
    final value = values[field] ?? '';
    return switch (field) {
      CheckoutField.name => CheckoutValidators.name(value),
      CheckoutField.email => CheckoutValidators.email(value),
      CheckoutField.phone => CheckoutValidators.phone(value),
      CheckoutField.address => CheckoutValidators.address(value),
    };
  }

  /// Ошибка показывается только после взаимодействия с полем.
  CheckoutFieldError? errorFor(CheckoutField field) =>
      touched.contains(field) ? _validate(field) : null;

  bool get isValid =>
      CheckoutField.values.every((field) => _validate(field) == null);

  @override
  List<Object?> get props => [values, touched, orderNumber];
}

@injectable
class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit(this._cart, this._placeOrder) : super(const CheckoutState());

  final CartCubit _cart;
  final PlaceOrder _placeOrder;
  bool _isSubmitting = false;

  void changed(CheckoutField field, String value) {
    emit(
      CheckoutState(
        values: {...state.values, field: value},
        touched: {...state.touched, field},
      ),
    );
  }

  void blurred(CheckoutField field) {
    if (state.touched.contains(field)) return;
    emit(
      CheckoutState(values: state.values, touched: {...state.touched, field}),
    );
  }

  Future<void> submit() async {
    if (_isSubmitting ||
        !state.isValid ||
        state.orderNumber != null ||
        _cart.state.isEmpty) {
      return;
    }
    _isSubmitting = true;
    try {
      final number = await _placeOrder(_cart.state);
      if (isClosed) return;
      emit(
        CheckoutState(
          values: state.values,
          touched: state.touched,
          orderNumber: number,
        ),
      );
      await _cart.clear();
    } finally {
      _isSubmitting = false;
    }
  }
}
