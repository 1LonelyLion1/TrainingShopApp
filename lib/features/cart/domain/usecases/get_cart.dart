import 'package:injectable/injectable.dart' show injectable;

import '../cart.dart';
import '../cart_repository.dart';

@injectable
class GetCart {
  const GetCart(this._repository);

  final CartRepository _repository;

  Future<Cart> call() => _repository.read();
}
