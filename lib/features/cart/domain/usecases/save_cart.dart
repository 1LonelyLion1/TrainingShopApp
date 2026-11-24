import 'package:injectable/injectable.dart' show injectable;

import '../cart.dart';
import '../cart_repository.dart';

@injectable
class SaveCart {
  const SaveCart(this._repository);

  final CartRepository _repository;

  Future<void> call(Cart cart) => _repository.write(cart);
}
