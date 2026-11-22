import 'dart:async';

import 'package:horns_and_hooves_shop_app/core/network/connectivity_service.dart';
import 'package:horns_and_hooves_shop_app/core/error/app_failure.dart';
import 'package:horns_and_hooves_shop_app/features/cart/data/cart_api.dart';
import 'package:horns_and_hooves_shop_app/features/cart/data/cart_storage.dart';
import 'package:horns_and_hooves_shop_app/features/cart/domain/cart.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_api.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/data/catalog_cache.dart';
import 'package:horns_and_hooves_shop_app/features/catalog/domain/product.dart';
import 'package:horns_and_hooves_shop_app/features/settings/data/locale_storage.dart';

Product product({
  int id = 1,
  int priceCents = 1000,
  String category = 'electronics',
}) => Product(
  id: id,
  title: 'Товар $id',
  priceCents: priceCents,
  description: 'Описание',
  category: category,
  imageUrl: '',
  rating: 4.5,
  ratingCount: 10,
);

class FakeCatalogApi implements CatalogApi {
  FakeCatalogApi(this.handler);

  Future<List<Product>> Function() handler;
  int calls = 0;

  @override
  Future<List<Product>> fetchProducts() {
    calls++;
    return handler();
  }
}

class FakeCatalogCache implements CatalogCache {
  FakeCatalogCache([this.products = const []]);

  List<Product> products;
  int writes = 0;
  bool failOnWrite = false;

  @override
  Future<List<Product>> read() async => products;

  @override
  Future<void> write(List<Product> value) async {
    if (failOnWrite) throw StateError('disk full');
    writes++;
    products = value;
  }
}

class FakeConnectivity implements ConnectivityService {
  FakeConnectivity({this.online = true});

  bool online;
  final _controller = StreamController<bool>.broadcast(sync: true);

  void set(bool value) {
    online = value;
    _controller.add(value);
  }

  @override
  Future<bool> get isOnline async => online;

  @override
  Stream<bool> get onlineChanges => _controller.stream;
}

class FakeLocaleStorage implements LocaleStorage {
  FakeLocaleStorage([this.saved]);

  String? saved;

  @override
  Future<String?> read() async => saved;

  @override
  Future<void> write(String? languageCode) async => saved = languageCode;
}

class FakeCartStorage implements CartStorage {
  Cart saved = const Cart();
  final List<Cart> history = [];
  int localRevision = 0;
  int? syncedRevision;

  @override
  Future<Cart> read() async => saved;

  @override
  Future<void> write(Cart cart) async {
    saved = cart;
    history.add(cart);
    localRevision++;
  }

  @override
  Future<CartSyncSnapshot> readSyncSnapshot() async => CartSyncSnapshot(
    cart: saved,
    localRevision: localRevision,
    syncedRevision: syncedRevision,
  );

  @override
  Future<void> markSynced(int revision) async => syncedRevision = revision;

  @override
  Future<bool> importRemote(Cart cart) async {
    if (!saved.isEmpty || localRevision != 0 || syncedRevision != null) {
      return false;
    }
    saved = cart;
    syncedRevision = 0;
    return true;
  }
}

class FakeCartApi implements CartApi {
  FakeCartApi({this.remote = const []});

  List<CartLine> remote;
  AppFailure? failure;
  Completer<void>? updateGate;
  int fetchCalls = 0;
  final List<List<CartLine>> updates = [];

  @override
  Future<List<CartLine>> fetchCart(int cartId) async {
    fetchCalls++;
    if (failure != null) throw failure!;
    return remote;
  }

  @override
  Future<void> updateCart(int cartId, List<CartLine> lines) async {
    if (failure != null) throw failure!;
    updates.add(lines);
    await updateGate?.future;
  }
}
