import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

mixin ProductColumns on Table {
  IntColumn get productId => integer()();
  TextColumn get title => text()();
  IntColumn get priceCents => integer()();
  TextColumn get description => text()();
  TextColumn get category => text()();
  TextColumn get imageUrl => text()();
  RealColumn get rating => real()();
  IntColumn get ratingCount => integer()();

  /// Сохраняет порядок, в котором товары показываются пользователю.
  IntColumn get position => integer()();

  @override
  Set<Column> get primaryKey => {productId};
}

@DataClassName('CatalogProductRow')
class CatalogProducts extends Table with ProductColumns {}

/// Хранит снимок товара, чтобы позиция пережила его удаление из каталога.
@DataClassName('CartItemRow')
class CartItems extends Table with ProductColumns {
  IntColumn get quantity => integer()();
}

@DataClassName('AppSettingRow')
class AppSettings extends Table {
  TextColumn get settingKey => text()();
  TextColumn get settingValue => text()();

  @override
  Set<Column> get primaryKey => {settingKey};
}

@DriftDatabase(tables: [CatalogProducts, CartItems, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'horns_and_hooves'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) await migrator.createTable(appSettings);
    },
  );
}
