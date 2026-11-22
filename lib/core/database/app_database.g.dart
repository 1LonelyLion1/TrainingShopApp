// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CatalogProductsTable extends CatalogProducts
    with TableInfo<$CatalogProductsTable, CatalogProductRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceCentsMeta = const VerificationMeta(
    'priceCents',
  );
  @override
  late final GeneratedColumn<int> priceCents = GeneratedColumn<int>(
    'price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratingCountMeta = const VerificationMeta(
    'ratingCount',
  );
  @override
  late final GeneratedColumn<int> ratingCount = GeneratedColumn<int>(
    'rating_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    productId,
    title,
    priceCents,
    description,
    category,
    imageUrl,
    rating,
    ratingCount,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogProductRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('price_cents')) {
      context.handle(
        _priceCentsMeta,
        priceCents.isAcceptableOrUnknown(data['price_cents']!, _priceCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_priceCentsMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('rating_count')) {
      context.handle(
        _ratingCountMeta,
        ratingCount.isAcceptableOrUnknown(
          data['rating_count']!,
          _ratingCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ratingCountMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productId};
  @override
  CatalogProductRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogProductRow(
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      priceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_cents'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      )!,
      ratingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating_count'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $CatalogProductsTable createAlias(String alias) {
    return $CatalogProductsTable(attachedDatabase, alias);
  }
}

class CatalogProductRow extends DataClass
    implements Insertable<CatalogProductRow> {
  final int productId;
  final String title;
  final int priceCents;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int ratingCount;

  /// Сохраняет порядок, в котором товары показываются пользователю.
  final int position;
  const CatalogProductRow({
    required this.productId,
    required this.title,
    required this.priceCents,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.ratingCount,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_id'] = Variable<int>(productId);
    map['title'] = Variable<String>(title);
    map['price_cents'] = Variable<int>(priceCents);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    map['image_url'] = Variable<String>(imageUrl);
    map['rating'] = Variable<double>(rating);
    map['rating_count'] = Variable<int>(ratingCount);
    map['position'] = Variable<int>(position);
    return map;
  }

  CatalogProductsCompanion toCompanion(bool nullToAbsent) {
    return CatalogProductsCompanion(
      productId: Value(productId),
      title: Value(title),
      priceCents: Value(priceCents),
      description: Value(description),
      category: Value(category),
      imageUrl: Value(imageUrl),
      rating: Value(rating),
      ratingCount: Value(ratingCount),
      position: Value(position),
    );
  }

  factory CatalogProductRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogProductRow(
      productId: serializer.fromJson<int>(json['productId']),
      title: serializer.fromJson<String>(json['title']),
      priceCents: serializer.fromJson<int>(json['priceCents']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      rating: serializer.fromJson<double>(json['rating']),
      ratingCount: serializer.fromJson<int>(json['ratingCount']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<int>(productId),
      'title': serializer.toJson<String>(title),
      'priceCents': serializer.toJson<int>(priceCents),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'rating': serializer.toJson<double>(rating),
      'ratingCount': serializer.toJson<int>(ratingCount),
      'position': serializer.toJson<int>(position),
    };
  }

  CatalogProductRow copyWith({
    int? productId,
    String? title,
    int? priceCents,
    String? description,
    String? category,
    String? imageUrl,
    double? rating,
    int? ratingCount,
    int? position,
  }) => CatalogProductRow(
    productId: productId ?? this.productId,
    title: title ?? this.title,
    priceCents: priceCents ?? this.priceCents,
    description: description ?? this.description,
    category: category ?? this.category,
    imageUrl: imageUrl ?? this.imageUrl,
    rating: rating ?? this.rating,
    ratingCount: ratingCount ?? this.ratingCount,
    position: position ?? this.position,
  );
  CatalogProductRow copyWithCompanion(CatalogProductsCompanion data) {
    return CatalogProductRow(
      productId: data.productId.present ? data.productId.value : this.productId,
      title: data.title.present ? data.title.value : this.title,
      priceCents: data.priceCents.present
          ? data.priceCents.value
          : this.priceCents,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      rating: data.rating.present ? data.rating.value : this.rating,
      ratingCount: data.ratingCount.present
          ? data.ratingCount.value
          : this.ratingCount,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogProductRow(')
          ..write('productId: $productId, ')
          ..write('title: $title, ')
          ..write('priceCents: $priceCents, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rating: $rating, ')
          ..write('ratingCount: $ratingCount, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    productId,
    title,
    priceCents,
    description,
    category,
    imageUrl,
    rating,
    ratingCount,
    position,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogProductRow &&
          other.productId == this.productId &&
          other.title == this.title &&
          other.priceCents == this.priceCents &&
          other.description == this.description &&
          other.category == this.category &&
          other.imageUrl == this.imageUrl &&
          other.rating == this.rating &&
          other.ratingCount == this.ratingCount &&
          other.position == this.position);
}

class CatalogProductsCompanion extends UpdateCompanion<CatalogProductRow> {
  final Value<int> productId;
  final Value<String> title;
  final Value<int> priceCents;
  final Value<String> description;
  final Value<String> category;
  final Value<String> imageUrl;
  final Value<double> rating;
  final Value<int> ratingCount;
  final Value<int> position;
  const CatalogProductsCompanion({
    this.productId = const Value.absent(),
    this.title = const Value.absent(),
    this.priceCents = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rating = const Value.absent(),
    this.ratingCount = const Value.absent(),
    this.position = const Value.absent(),
  });
  CatalogProductsCompanion.insert({
    this.productId = const Value.absent(),
    required String title,
    required int priceCents,
    required String description,
    required String category,
    required String imageUrl,
    required double rating,
    required int ratingCount,
    required int position,
  }) : title = Value(title),
       priceCents = Value(priceCents),
       description = Value(description),
       category = Value(category),
       imageUrl = Value(imageUrl),
       rating = Value(rating),
       ratingCount = Value(ratingCount),
       position = Value(position);
  static Insertable<CatalogProductRow> custom({
    Expression<int>? productId,
    Expression<String>? title,
    Expression<int>? priceCents,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? imageUrl,
    Expression<double>? rating,
    Expression<int>? ratingCount,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
      if (title != null) 'title': title,
      if (priceCents != null) 'price_cents': priceCents,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (imageUrl != null) 'image_url': imageUrl,
      if (rating != null) 'rating': rating,
      if (ratingCount != null) 'rating_count': ratingCount,
      if (position != null) 'position': position,
    });
  }

  CatalogProductsCompanion copyWith({
    Value<int>? productId,
    Value<String>? title,
    Value<int>? priceCents,
    Value<String>? description,
    Value<String>? category,
    Value<String>? imageUrl,
    Value<double>? rating,
    Value<int>? ratingCount,
    Value<int>? position,
  }) {
    return CatalogProductsCompanion(
      productId: productId ?? this.productId,
      title: title ?? this.title,
      priceCents: priceCents ?? this.priceCents,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (priceCents.present) {
      map['price_cents'] = Variable<int>(priceCents.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (ratingCount.present) {
      map['rating_count'] = Variable<int>(ratingCount.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogProductsCompanion(')
          ..write('productId: $productId, ')
          ..write('title: $title, ')
          ..write('priceCents: $priceCents, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rating: $rating, ')
          ..write('ratingCount: $ratingCount, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $CartItemsTable extends CartItems
    with TableInfo<$CartItemsTable, CartItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CartItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceCentsMeta = const VerificationMeta(
    'priceCents',
  );
  @override
  late final GeneratedColumn<int> priceCents = GeneratedColumn<int>(
    'price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratingCountMeta = const VerificationMeta(
    'ratingCount',
  );
  @override
  late final GeneratedColumn<int> ratingCount = GeneratedColumn<int>(
    'rating_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    productId,
    title,
    priceCents,
    description,
    category,
    imageUrl,
    rating,
    ratingCount,
    position,
    quantity,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cart_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CartItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('price_cents')) {
      context.handle(
        _priceCentsMeta,
        priceCents.isAcceptableOrUnknown(data['price_cents']!, _priceCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_priceCentsMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('rating_count')) {
      context.handle(
        _ratingCountMeta,
        ratingCount.isAcceptableOrUnknown(
          data['rating_count']!,
          _ratingCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ratingCountMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productId};
  @override
  CartItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CartItemRow(
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      priceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_cents'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      )!,
      ratingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating_count'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
    );
  }

  @override
  $CartItemsTable createAlias(String alias) {
    return $CartItemsTable(attachedDatabase, alias);
  }
}

class CartItemRow extends DataClass implements Insertable<CartItemRow> {
  final int productId;
  final String title;
  final int priceCents;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int ratingCount;

  /// Сохраняет порядок, в котором товары показываются пользователю.
  final int position;
  final int quantity;
  const CartItemRow({
    required this.productId,
    required this.title,
    required this.priceCents,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.ratingCount,
    required this.position,
    required this.quantity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_id'] = Variable<int>(productId);
    map['title'] = Variable<String>(title);
    map['price_cents'] = Variable<int>(priceCents);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    map['image_url'] = Variable<String>(imageUrl);
    map['rating'] = Variable<double>(rating);
    map['rating_count'] = Variable<int>(ratingCount);
    map['position'] = Variable<int>(position);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  CartItemsCompanion toCompanion(bool nullToAbsent) {
    return CartItemsCompanion(
      productId: Value(productId),
      title: Value(title),
      priceCents: Value(priceCents),
      description: Value(description),
      category: Value(category),
      imageUrl: Value(imageUrl),
      rating: Value(rating),
      ratingCount: Value(ratingCount),
      position: Value(position),
      quantity: Value(quantity),
    );
  }

  factory CartItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CartItemRow(
      productId: serializer.fromJson<int>(json['productId']),
      title: serializer.fromJson<String>(json['title']),
      priceCents: serializer.fromJson<int>(json['priceCents']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      rating: serializer.fromJson<double>(json['rating']),
      ratingCount: serializer.fromJson<int>(json['ratingCount']),
      position: serializer.fromJson<int>(json['position']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<int>(productId),
      'title': serializer.toJson<String>(title),
      'priceCents': serializer.toJson<int>(priceCents),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'rating': serializer.toJson<double>(rating),
      'ratingCount': serializer.toJson<int>(ratingCount),
      'position': serializer.toJson<int>(position),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  CartItemRow copyWith({
    int? productId,
    String? title,
    int? priceCents,
    String? description,
    String? category,
    String? imageUrl,
    double? rating,
    int? ratingCount,
    int? position,
    int? quantity,
  }) => CartItemRow(
    productId: productId ?? this.productId,
    title: title ?? this.title,
    priceCents: priceCents ?? this.priceCents,
    description: description ?? this.description,
    category: category ?? this.category,
    imageUrl: imageUrl ?? this.imageUrl,
    rating: rating ?? this.rating,
    ratingCount: ratingCount ?? this.ratingCount,
    position: position ?? this.position,
    quantity: quantity ?? this.quantity,
  );
  CartItemRow copyWithCompanion(CartItemsCompanion data) {
    return CartItemRow(
      productId: data.productId.present ? data.productId.value : this.productId,
      title: data.title.present ? data.title.value : this.title,
      priceCents: data.priceCents.present
          ? data.priceCents.value
          : this.priceCents,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      rating: data.rating.present ? data.rating.value : this.rating,
      ratingCount: data.ratingCount.present
          ? data.ratingCount.value
          : this.ratingCount,
      position: data.position.present ? data.position.value : this.position,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CartItemRow(')
          ..write('productId: $productId, ')
          ..write('title: $title, ')
          ..write('priceCents: $priceCents, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rating: $rating, ')
          ..write('ratingCount: $ratingCount, ')
          ..write('position: $position, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    productId,
    title,
    priceCents,
    description,
    category,
    imageUrl,
    rating,
    ratingCount,
    position,
    quantity,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartItemRow &&
          other.productId == this.productId &&
          other.title == this.title &&
          other.priceCents == this.priceCents &&
          other.description == this.description &&
          other.category == this.category &&
          other.imageUrl == this.imageUrl &&
          other.rating == this.rating &&
          other.ratingCount == this.ratingCount &&
          other.position == this.position &&
          other.quantity == this.quantity);
}

class CartItemsCompanion extends UpdateCompanion<CartItemRow> {
  final Value<int> productId;
  final Value<String> title;
  final Value<int> priceCents;
  final Value<String> description;
  final Value<String> category;
  final Value<String> imageUrl;
  final Value<double> rating;
  final Value<int> ratingCount;
  final Value<int> position;
  final Value<int> quantity;
  const CartItemsCompanion({
    this.productId = const Value.absent(),
    this.title = const Value.absent(),
    this.priceCents = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rating = const Value.absent(),
    this.ratingCount = const Value.absent(),
    this.position = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  CartItemsCompanion.insert({
    this.productId = const Value.absent(),
    required String title,
    required int priceCents,
    required String description,
    required String category,
    required String imageUrl,
    required double rating,
    required int ratingCount,
    required int position,
    required int quantity,
  }) : title = Value(title),
       priceCents = Value(priceCents),
       description = Value(description),
       category = Value(category),
       imageUrl = Value(imageUrl),
       rating = Value(rating),
       ratingCount = Value(ratingCount),
       position = Value(position),
       quantity = Value(quantity);
  static Insertable<CartItemRow> custom({
    Expression<int>? productId,
    Expression<String>? title,
    Expression<int>? priceCents,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? imageUrl,
    Expression<double>? rating,
    Expression<int>? ratingCount,
    Expression<int>? position,
    Expression<int>? quantity,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
      if (title != null) 'title': title,
      if (priceCents != null) 'price_cents': priceCents,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (imageUrl != null) 'image_url': imageUrl,
      if (rating != null) 'rating': rating,
      if (ratingCount != null) 'rating_count': ratingCount,
      if (position != null) 'position': position,
      if (quantity != null) 'quantity': quantity,
    });
  }

  CartItemsCompanion copyWith({
    Value<int>? productId,
    Value<String>? title,
    Value<int>? priceCents,
    Value<String>? description,
    Value<String>? category,
    Value<String>? imageUrl,
    Value<double>? rating,
    Value<int>? ratingCount,
    Value<int>? position,
    Value<int>? quantity,
  }) {
    return CartItemsCompanion(
      productId: productId ?? this.productId,
      title: title ?? this.title,
      priceCents: priceCents ?? this.priceCents,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      position: position ?? this.position,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (priceCents.present) {
      map['price_cents'] = Variable<int>(priceCents.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (ratingCount.present) {
      map['rating_count'] = Variable<int>(ratingCount.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartItemsCompanion(')
          ..write('productId: $productId, ')
          ..write('title: $title, ')
          ..write('priceCents: $priceCents, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rating: $rating, ')
          ..write('ratingCount: $ratingCount, ')
          ..write('position: $position, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _settingKeyMeta = const VerificationMeta(
    'settingKey',
  );
  @override
  late final GeneratedColumn<String> settingKey = GeneratedColumn<String>(
    'setting_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _settingValueMeta = const VerificationMeta(
    'settingValue',
  );
  @override
  late final GeneratedColumn<String> settingValue = GeneratedColumn<String>(
    'setting_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [settingKey, settingValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('setting_key')) {
      context.handle(
        _settingKeyMeta,
        settingKey.isAcceptableOrUnknown(data['setting_key']!, _settingKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_settingKeyMeta);
    }
    if (data.containsKey('setting_value')) {
      context.handle(
        _settingValueMeta,
        settingValue.isAcceptableOrUnknown(
          data['setting_value']!,
          _settingValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_settingValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {settingKey};
  @override
  AppSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingRow(
      settingKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_key'],
      )!,
      settingValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSettingRow extends DataClass implements Insertable<AppSettingRow> {
  final String settingKey;
  final String settingValue;
  const AppSettingRow({required this.settingKey, required this.settingValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['setting_key'] = Variable<String>(settingKey);
    map['setting_value'] = Variable<String>(settingValue);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      settingKey: Value(settingKey),
      settingValue: Value(settingValue),
    );
  }

  factory AppSettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingRow(
      settingKey: serializer.fromJson<String>(json['settingKey']),
      settingValue: serializer.fromJson<String>(json['settingValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'settingKey': serializer.toJson<String>(settingKey),
      'settingValue': serializer.toJson<String>(settingValue),
    };
  }

  AppSettingRow copyWith({String? settingKey, String? settingValue}) =>
      AppSettingRow(
        settingKey: settingKey ?? this.settingKey,
        settingValue: settingValue ?? this.settingValue,
      );
  AppSettingRow copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingRow(
      settingKey: data.settingKey.present
          ? data.settingKey.value
          : this.settingKey,
      settingValue: data.settingValue.present
          ? data.settingValue.value
          : this.settingValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingRow(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(settingKey, settingValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingRow &&
          other.settingKey == this.settingKey &&
          other.settingValue == this.settingValue);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingRow> {
  final Value<String> settingKey;
  final Value<String> settingValue;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.settingKey = const Value.absent(),
    this.settingValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String settingKey,
    required String settingValue,
    this.rowid = const Value.absent(),
  }) : settingKey = Value(settingKey),
       settingValue = Value(settingValue);
  static Insertable<AppSettingRow> custom({
    Expression<String>? settingKey,
    Expression<String>? settingValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (settingKey != null) 'setting_key': settingKey,
      if (settingValue != null) 'setting_value': settingValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? settingKey,
    Value<String>? settingValue,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      settingKey: settingKey ?? this.settingKey,
      settingValue: settingValue ?? this.settingValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (settingKey.present) {
      map['setting_key'] = Variable<String>(settingKey.value);
    }
    if (settingValue.present) {
      map['setting_value'] = Variable<String>(settingValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CatalogProductsTable catalogProducts = $CatalogProductsTable(
    this,
  );
  late final $CartItemsTable cartItems = $CartItemsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    catalogProducts,
    cartItems,
    appSettings,
  ];
}

typedef $$CatalogProductsTableCreateCompanionBuilder =
    CatalogProductsCompanion Function({
      Value<int> productId,
      required String title,
      required int priceCents,
      required String description,
      required String category,
      required String imageUrl,
      required double rating,
      required int ratingCount,
      required int position,
    });
typedef $$CatalogProductsTableUpdateCompanionBuilder =
    CatalogProductsCompanion Function({
      Value<int> productId,
      Value<String> title,
      Value<int> priceCents,
      Value<String> description,
      Value<String> category,
      Value<String> imageUrl,
      Value<double> rating,
      Value<int> ratingCount,
      Value<int> position,
    });

class $$CatalogProductsTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogProductsTable> {
  $$CatalogProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ratingCount => $composableBuilder(
    column: $table.ratingCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogProductsTable> {
  $$CatalogProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ratingCount => $composableBuilder(
    column: $table.ratingCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogProductsTable> {
  $$CatalogProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<int> get ratingCount => $composableBuilder(
    column: $table.ratingCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$CatalogProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogProductsTable,
          CatalogProductRow,
          $$CatalogProductsTableFilterComposer,
          $$CatalogProductsTableOrderingComposer,
          $$CatalogProductsTableAnnotationComposer,
          $$CatalogProductsTableCreateCompanionBuilder,
          $$CatalogProductsTableUpdateCompanionBuilder,
          (
            CatalogProductRow,
            BaseReferences<
              _$AppDatabase,
              $CatalogProductsTable,
              CatalogProductRow
            >,
          ),
          CatalogProductRow,
          PrefetchHooks Function()
        > {
  $$CatalogProductsTableTableManager(
    _$AppDatabase db,
    $CatalogProductsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> productId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> priceCents = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<double> rating = const Value.absent(),
                Value<int> ratingCount = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => CatalogProductsCompanion(
                productId: productId,
                title: title,
                priceCents: priceCents,
                description: description,
                category: category,
                imageUrl: imageUrl,
                rating: rating,
                ratingCount: ratingCount,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> productId = const Value.absent(),
                required String title,
                required int priceCents,
                required String description,
                required String category,
                required String imageUrl,
                required double rating,
                required int ratingCount,
                required int position,
              }) => CatalogProductsCompanion.insert(
                productId: productId,
                title: title,
                priceCents: priceCents,
                description: description,
                category: category,
                imageUrl: imageUrl,
                rating: rating,
                ratingCount: ratingCount,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CatalogProductsTable, CatalogProductRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CatalogProductsTable,
                    CatalogProductRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogProductsTable,
      CatalogProductRow,
      $$CatalogProductsTableFilterComposer,
      $$CatalogProductsTableOrderingComposer,
      $$CatalogProductsTableAnnotationComposer,
      $$CatalogProductsTableCreateCompanionBuilder,
      $$CatalogProductsTableUpdateCompanionBuilder,
      (
        CatalogProductRow,
        BaseReferences<_$AppDatabase, $CatalogProductsTable, CatalogProductRow>,
      ),
      CatalogProductRow,
      PrefetchHooks Function()
    >;
typedef $$CartItemsTableCreateCompanionBuilder =
    CartItemsCompanion Function({
      Value<int> productId,
      required String title,
      required int priceCents,
      required String description,
      required String category,
      required String imageUrl,
      required double rating,
      required int ratingCount,
      required int position,
      required int quantity,
    });
typedef $$CartItemsTableUpdateCompanionBuilder =
    CartItemsCompanion Function({
      Value<int> productId,
      Value<String> title,
      Value<int> priceCents,
      Value<String> description,
      Value<String> category,
      Value<String> imageUrl,
      Value<double> rating,
      Value<int> ratingCount,
      Value<int> position,
      Value<int> quantity,
    });

class $$CartItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ratingCount => $composableBuilder(
    column: $table.ratingCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CartItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ratingCount => $composableBuilder(
    column: $table.ratingCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CartItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<int> get ratingCount => $composableBuilder(
    column: $table.ratingCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);
}

class $$CartItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CartItemsTable,
          CartItemRow,
          $$CartItemsTableFilterComposer,
          $$CartItemsTableOrderingComposer,
          $$CartItemsTableAnnotationComposer,
          $$CartItemsTableCreateCompanionBuilder,
          $$CartItemsTableUpdateCompanionBuilder,
          (
            CartItemRow,
            BaseReferences<_$AppDatabase, $CartItemsTable, CartItemRow>,
          ),
          CartItemRow,
          PrefetchHooks Function()
        > {
  $$CartItemsTableTableManager(_$AppDatabase db, $CartItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CartItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CartItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CartItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> productId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> priceCents = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<double> rating = const Value.absent(),
                Value<int> ratingCount = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> quantity = const Value.absent(),
              }) => CartItemsCompanion(
                productId: productId,
                title: title,
                priceCents: priceCents,
                description: description,
                category: category,
                imageUrl: imageUrl,
                rating: rating,
                ratingCount: ratingCount,
                position: position,
                quantity: quantity,
              ),
          createCompanionCallback:
              ({
                Value<int> productId = const Value.absent(),
                required String title,
                required int priceCents,
                required String description,
                required String category,
                required String imageUrl,
                required double rating,
                required int ratingCount,
                required int position,
                required int quantity,
              }) => CartItemsCompanion.insert(
                productId: productId,
                title: title,
                priceCents: priceCents,
                description: description,
                category: category,
                imageUrl: imageUrl,
                rating: rating,
                ratingCount: ratingCount,
                position: position,
                quantity: quantity,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CartItemsTable, CartItemRow>(table),
                  BaseReferences<_$AppDatabase, $CartItemsTable, CartItemRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CartItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CartItemsTable,
      CartItemRow,
      $$CartItemsTableFilterComposer,
      $$CartItemsTableOrderingComposer,
      $$CartItemsTableAnnotationComposer,
      $$CartItemsTableCreateCompanionBuilder,
      $$CartItemsTableUpdateCompanionBuilder,
      (
        CartItemRow,
        BaseReferences<_$AppDatabase, $CartItemsTable, CartItemRow>,
      ),
      CartItemRow,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String settingKey,
      required String settingValue,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> settingKey,
      Value<String> settingValue,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSettingRow,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSettingRow,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRow>,
          ),
          AppSettingRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> settingKey = const Value.absent(),
                Value<String> settingValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                settingKey: settingKey,
                settingValue: settingValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String settingKey,
                required String settingValue,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                settingKey: settingKey,
                settingValue: settingValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSettingRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppSettingsTable,
                    AppSettingRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSettingRow,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSettingRow,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRow>,
      ),
      AppSettingRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CatalogProductsTableTableManager get catalogProducts =>
      $$CatalogProductsTableTableManager(_db, _db.catalogProducts);
  $$CartItemsTableTableManager get cartItems =>
      $$CartItemsTableTableManager(_db, _db.cartItems);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
