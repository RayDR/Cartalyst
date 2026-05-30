// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _canonicalNameMeta =
      const VerificationMeta('canonicalName');
  @override
  late final GeneratedColumn<String> canonicalName = GeneratedColumn<String>(
      'canonical_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'other\' CHECK (category IN (\'produce\', \'dairy\', \'protein\', \'grains\', \'bakery\', \'household\', \'other\'))',
      defaultValue: const CustomExpression('\'other\''));
  static const VerificationMeta _defaultUnitMeta =
      const VerificationMeta('defaultUnit');
  @override
  late final GeneratedColumn<String> defaultUnit = GeneratedColumn<String>(
      'default_unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'unit\' CHECK (default_unit IN (\'unit\', \'kg\', \'g\', \'liter\', \'ml\', \'pack\'))',
      defaultValue: const CustomExpression('\'unit\''));
  static const VerificationMeta _defaultPackageQuantityMeta =
      const VerificationMeta('defaultPackageQuantity');
  @override
  late final GeneratedColumn<double> defaultPackageQuantity =
      GeneratedColumn<double>('default_package_quantity', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'local_only\' CHECK (sync_status IN (\'local_only\', \'pending_sync\', \'synced\', \'sync_error\'))',
      defaultValue: const CustomExpression('\'local_only\''));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        canonicalName,
        brand,
        category,
        defaultUnit,
        defaultPackageQuantity,
        createdAt,
        updatedAt,
        deletedAt,
        syncStatus,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('canonical_name')) {
      context.handle(
          _canonicalNameMeta,
          canonicalName.isAcceptableOrUnknown(
              data['canonical_name']!, _canonicalNameMeta));
    } else if (isInserting) {
      context.missing(_canonicalNameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('default_unit')) {
      context.handle(
          _defaultUnitMeta,
          defaultUnit.isAcceptableOrUnknown(
              data['default_unit']!, _defaultUnitMeta));
    }
    if (data.containsKey('default_package_quantity')) {
      context.handle(
          _defaultPackageQuantityMeta,
          defaultPackageQuantity.isAcceptableOrUnknown(
              data['default_package_quantity']!, _defaultPackageQuantityMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      canonicalName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}canonical_name'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      defaultUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}default_unit'])!,
      defaultPackageQuantity: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}default_package_quantity']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String canonicalName;
  final String? brand;
  final String category;
  final String defaultUnit;
  final double? defaultPackageQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  final int version;
  const Product(
      {required this.id,
      required this.canonicalName,
      this.brand,
      required this.category,
      required this.defaultUnit,
      this.defaultPackageQuantity,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.syncStatus,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['canonical_name'] = Variable<String>(canonicalName);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    map['category'] = Variable<String>(category);
    map['default_unit'] = Variable<String>(defaultUnit);
    if (!nullToAbsent || defaultPackageQuantity != null) {
      map['default_package_quantity'] =
          Variable<double>(defaultPackageQuantity);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['version'] = Variable<int>(version);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      canonicalName: Value(canonicalName),
      brand:
          brand == null && nullToAbsent ? const Value.absent() : Value(brand),
      category: Value(category),
      defaultUnit: Value(defaultUnit),
      defaultPackageQuantity: defaultPackageQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultPackageQuantity),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      version: Value(version),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      canonicalName: serializer.fromJson<String>(json['canonicalName']),
      brand: serializer.fromJson<String?>(json['brand']),
      category: serializer.fromJson<String>(json['category']),
      defaultUnit: serializer.fromJson<String>(json['defaultUnit']),
      defaultPackageQuantity:
          serializer.fromJson<double?>(json['defaultPackageQuantity']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'canonicalName': serializer.toJson<String>(canonicalName),
      'brand': serializer.toJson<String?>(brand),
      'category': serializer.toJson<String>(category),
      'defaultUnit': serializer.toJson<String>(defaultUnit),
      'defaultPackageQuantity':
          serializer.toJson<double?>(defaultPackageQuantity),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'version': serializer.toJson<int>(version),
    };
  }

  Product copyWith(
          {String? id,
          String? canonicalName,
          Value<String?> brand = const Value.absent(),
          String? category,
          String? defaultUnit,
          Value<double?> defaultPackageQuantity = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          String? syncStatus,
          int? version}) =>
      Product(
        id: id ?? this.id,
        canonicalName: canonicalName ?? this.canonicalName,
        brand: brand.present ? brand.value : this.brand,
        category: category ?? this.category,
        defaultUnit: defaultUnit ?? this.defaultUnit,
        defaultPackageQuantity: defaultPackageQuantity.present
            ? defaultPackageQuantity.value
            : this.defaultPackageQuantity,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        version: version ?? this.version,
      );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      canonicalName: data.canonicalName.present
          ? data.canonicalName.value
          : this.canonicalName,
      brand: data.brand.present ? data.brand.value : this.brand,
      category: data.category.present ? data.category.value : this.category,
      defaultUnit:
          data.defaultUnit.present ? data.defaultUnit.value : this.defaultUnit,
      defaultPackageQuantity: data.defaultPackageQuantity.present
          ? data.defaultPackageQuantity.value
          : this.defaultPackageQuantity,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('canonicalName: $canonicalName, ')
          ..write('brand: $brand, ')
          ..write('category: $category, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('defaultPackageQuantity: $defaultPackageQuantity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      canonicalName,
      brand,
      category,
      defaultUnit,
      defaultPackageQuantity,
      createdAt,
      updatedAt,
      deletedAt,
      syncStatus,
      version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.canonicalName == this.canonicalName &&
          other.brand == this.brand &&
          other.category == this.category &&
          other.defaultUnit == this.defaultUnit &&
          other.defaultPackageQuantity == this.defaultPackageQuantity &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> canonicalName;
  final Value<String?> brand;
  final Value<String> category;
  final Value<String> defaultUnit;
  final Value<double?> defaultPackageQuantity;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> version;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.canonicalName = const Value.absent(),
    this.brand = const Value.absent(),
    this.category = const Value.absent(),
    this.defaultUnit = const Value.absent(),
    this.defaultPackageQuantity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String canonicalName,
    this.brand = const Value.absent(),
    this.category = const Value.absent(),
    this.defaultUnit = const Value.absent(),
    this.defaultPackageQuantity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        canonicalName = Value(canonicalName);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? canonicalName,
    Expression<String>? brand,
    Expression<String>? category,
    Expression<String>? defaultUnit,
    Expression<double>? defaultPackageQuantity,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (canonicalName != null) 'canonical_name': canonicalName,
      if (brand != null) 'brand': brand,
      if (category != null) 'category': category,
      if (defaultUnit != null) 'default_unit': defaultUnit,
      if (defaultPackageQuantity != null)
        'default_package_quantity': defaultPackageQuantity,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith(
      {Value<String>? id,
      Value<String>? canonicalName,
      Value<String?>? brand,
      Value<String>? category,
      Value<String>? defaultUnit,
      Value<double?>? defaultPackageQuantity,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<String>? syncStatus,
      Value<int>? version,
      Value<int>? rowid}) {
    return ProductsCompanion(
      id: id ?? this.id,
      canonicalName: canonicalName ?? this.canonicalName,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      defaultUnit: defaultUnit ?? this.defaultUnit,
      defaultPackageQuantity:
          defaultPackageQuantity ?? this.defaultPackageQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (canonicalName.present) {
      map['canonical_name'] = Variable<String>(canonicalName.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (defaultUnit.present) {
      map['default_unit'] = Variable<String>(defaultUnit.value);
    }
    if (defaultPackageQuantity.present) {
      map['default_package_quantity'] =
          Variable<double>(defaultPackageQuantity.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('canonicalName: $canonicalName, ')
          ..write('brand: $brand, ')
          ..write('category: $category, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('defaultPackageQuantity: $defaultPackageQuantity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductAliasesTable extends ProductAliases
    with TableInfo<$ProductAliasesTable, ProductAliase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductAliasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
      'alias', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _languageCodeMeta =
      const VerificationMeta('languageCode');
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
      'language_code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 8),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, productId, alias, languageCode, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_aliases';
  @override
  VerificationContext validateIntegrity(Insertable<ProductAliase> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('alias')) {
      context.handle(
          _aliasMeta, alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta));
    } else if (isInserting) {
      context.missing(_aliasMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
          _languageCodeMeta,
          languageCode.isAcceptableOrUnknown(
              data['language_code']!, _languageCodeMeta));
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {productId, alias, languageCode},
      ];
  @override
  ProductAliase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductAliase(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      alias: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alias'])!,
      languageCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language_code'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ProductAliasesTable createAlias(String alias) {
    return $ProductAliasesTable(attachedDatabase, alias);
  }
}

class ProductAliase extends DataClass implements Insertable<ProductAliase> {
  final String id;
  final String productId;
  final String alias;
  final String languageCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProductAliase(
      {required this.id,
      required this.productId,
      required this.alias,
      required this.languageCode,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['alias'] = Variable<String>(alias);
    map['language_code'] = Variable<String>(languageCode);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductAliasesCompanion toCompanion(bool nullToAbsent) {
    return ProductAliasesCompanion(
      id: Value(id),
      productId: Value(productId),
      alias: Value(alias),
      languageCode: Value(languageCode),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProductAliase.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductAliase(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      alias: serializer.fromJson<String>(json['alias']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'alias': serializer.toJson<String>(alias),
      'languageCode': serializer.toJson<String>(languageCode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProductAliase copyWith(
          {String? id,
          String? productId,
          String? alias,
          String? languageCode,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ProductAliase(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        alias: alias ?? this.alias,
        languageCode: languageCode ?? this.languageCode,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ProductAliase copyWithCompanion(ProductAliasesCompanion data) {
    return ProductAliase(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      alias: data.alias.present ? data.alias.value : this.alias,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductAliase(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('alias: $alias, ')
          ..write('languageCode: $languageCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, alias, languageCode, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductAliase &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.alias == this.alias &&
          other.languageCode == this.languageCode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductAliasesCompanion extends UpdateCompanion<ProductAliase> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> alias;
  final Value<String> languageCode;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProductAliasesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.alias = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductAliasesCompanion.insert({
    required String id,
    required String productId,
    required String alias,
    required String languageCode,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        productId = Value(productId),
        alias = Value(alias),
        languageCode = Value(languageCode);
  static Insertable<ProductAliase> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? alias,
    Expression<String>? languageCode,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (alias != null) 'alias': alias,
      if (languageCode != null) 'language_code': languageCode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductAliasesCompanion copyWith(
      {Value<String>? id,
      Value<String>? productId,
      Value<String>? alias,
      Value<String>? languageCode,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ProductAliasesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      alias: alias ?? this.alias,
      languageCode: languageCode ?? this.languageCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductAliasesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('alias: $alias, ')
          ..write('languageCode: $languageCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'local_only\' CHECK (sync_status IN (\'local_only\', \'pending_sync\', \'synced\', \'sync_error\'))',
      defaultValue: const CustomExpression('\'local_only\''));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        color,
        icon,
        createdAt,
        updatedAt,
        deletedAt,
        syncStatus,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String name;
  final String? color;
  final String? icon;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  final int version;
  const Category(
      {required this.id,
      required this.name,
      this.color,
      this.icon,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.syncStatus,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['version'] = Variable<int>(version);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      version: Value(version),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String?>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String?>(color),
      'icon': serializer.toJson<String?>(icon),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'version': serializer.toJson<int>(version),
    };
  }

  Category copyWith(
          {String? id,
          String? name,
          Value<String?> color = const Value.absent(),
          Value<String?> icon = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          String? syncStatus,
          int? version}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color.present ? color.value : this.color,
        icon: icon.present ? icon.value : this.icon,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        version: version ?? this.version,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, icon, createdAt, updatedAt,
      deletedAt, syncStatus, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> color;
  final Value<String?> icon;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> version;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<String>? icon,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? color,
      Value<String?>? icon,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<String>? syncStatus,
      Value<int>? version,
      Value<int>? rowid}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoriesTable extends Inventories
    with TableInfo<$InventoriesTable, Inventory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 240),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'local_only\' CHECK (sync_status IN (\'local_only\', \'pending_sync\', \'synced\', \'sync_error\'))',
      defaultValue: const CustomExpression('\'local_only\''));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        createdAt,
        updatedAt,
        deletedAt,
        syncStatus,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventories';
  @override
  VerificationContext validateIntegrity(Insertable<Inventory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Inventory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Inventory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $InventoriesTable createAlias(String alias) {
    return $InventoriesTable(attachedDatabase, alias);
  }
}

class Inventory extends DataClass implements Insertable<Inventory> {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  final int version;
  const Inventory(
      {required this.id,
      required this.name,
      this.description,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.syncStatus,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['version'] = Variable<int>(version);
    return map;
  }

  InventoriesCompanion toCompanion(bool nullToAbsent) {
    return InventoriesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      version: Value(version),
    );
  }

  factory Inventory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Inventory(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'version': serializer.toJson<int>(version),
    };
  }

  Inventory copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          String? syncStatus,
          int? version}) =>
      Inventory(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        version: version ?? this.version,
      );
  Inventory copyWithCompanion(InventoriesCompanion data) {
    return Inventory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Inventory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, createdAt, updatedAt,
      deletedAt, syncStatus, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Inventory &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version);
}

class InventoriesCompanion extends UpdateCompanion<Inventory> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> version;
  final Value<int> rowid;
  const InventoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoriesCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Inventory> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<String>? syncStatus,
      Value<int>? version,
      Value<int>? rowid}) {
    return InventoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryCategoriesTable extends InventoryCategories
    with TableInfo<$InventoryCategoriesTable, InventoryCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inventoryIdMeta =
      const VerificationMeta('inventoryId');
  @override
  late final GeneratedColumn<String> inventoryId = GeneratedColumn<String>(
      'inventory_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES inventories (id) ON DELETE CASCADE'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES categories (id) ON DELETE CASCADE'));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, inventoryId, categoryId, sortOrder, createdAt, updatedAt, deletedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_categories';
  @override
  VerificationContext validateIntegrity(Insertable<InventoryCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('inventory_id')) {
      context.handle(
          _inventoryIdMeta,
          inventoryId.isAcceptableOrUnknown(
              data['inventory_id']!, _inventoryIdMeta));
    } else if (isInserting) {
      context.missing(_inventoryIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      inventoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}inventory_id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $InventoryCategoriesTable createAlias(String alias) {
    return $InventoryCategoriesTable(attachedDatabase, alias);
  }
}

class InventoryCategory extends DataClass
    implements Insertable<InventoryCategory> {
  final String id;
  final String inventoryId;
  final String categoryId;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const InventoryCategory(
      {required this.id,
      required this.inventoryId,
      required this.categoryId,
      required this.sortOrder,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['inventory_id'] = Variable<String>(inventoryId);
    map['category_id'] = Variable<String>(categoryId);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  InventoryCategoriesCompanion toCompanion(bool nullToAbsent) {
    return InventoryCategoriesCompanion(
      id: Value(id),
      inventoryId: Value(inventoryId),
      categoryId: Value(categoryId),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory InventoryCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryCategory(
      id: serializer.fromJson<String>(json['id']),
      inventoryId: serializer.fromJson<String>(json['inventoryId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'inventoryId': serializer.toJson<String>(inventoryId),
      'categoryId': serializer.toJson<String>(categoryId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  InventoryCategory copyWith(
          {String? id,
          String? inventoryId,
          String? categoryId,
          int? sortOrder,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      InventoryCategory(
        id: id ?? this.id,
        inventoryId: inventoryId ?? this.inventoryId,
        categoryId: categoryId ?? this.categoryId,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  InventoryCategory copyWithCompanion(InventoryCategoriesCompanion data) {
    return InventoryCategory(
      id: data.id.present ? data.id.value : this.id,
      inventoryId:
          data.inventoryId.present ? data.inventoryId.value : this.inventoryId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryCategory(')
          ..write('id: $id, ')
          ..write('inventoryId: $inventoryId, ')
          ..write('categoryId: $categoryId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, inventoryId, categoryId, sortOrder, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryCategory &&
          other.id == this.id &&
          other.inventoryId == this.inventoryId &&
          other.categoryId == this.categoryId &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class InventoryCategoriesCompanion extends UpdateCompanion<InventoryCategory> {
  final Value<String> id;
  final Value<String> inventoryId;
  final Value<String> categoryId;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const InventoryCategoriesCompanion({
    this.id = const Value.absent(),
    this.inventoryId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryCategoriesCompanion.insert({
    required String id,
    required String inventoryId,
    required String categoryId,
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        inventoryId = Value(inventoryId),
        categoryId = Value(categoryId);
  static Insertable<InventoryCategory> custom({
    Expression<String>? id,
    Expression<String>? inventoryId,
    Expression<String>? categoryId,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inventoryId != null) 'inventory_id': inventoryId,
      if (categoryId != null) 'category_id': categoryId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryCategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? inventoryId,
      Value<String>? categoryId,
      Value<int>? sortOrder,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return InventoryCategoriesCompanion(
      id: id ?? this.id,
      inventoryId: inventoryId ?? this.inventoryId,
      categoryId: categoryId ?? this.categoryId,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (inventoryId.present) {
      map['inventory_id'] = Variable<String>(inventoryId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('inventoryId: $inventoryId, ')
          ..write('categoryId: $categoryId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryItemsTable extends InventoryItems
    with TableInfo<$InventoryItemsTable, InventoryItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inventoryIdMeta =
      const VerificationMeta('inventoryId');
  @override
  late final GeneratedColumn<String> inventoryId = GeneratedColumn<String>(
      'inventory_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES inventories (id)'));
  static const VerificationMeta _inventoryCategoryIdMeta =
      const VerificationMeta('inventoryCategoryId');
  @override
  late final GeneratedColumn<String> inventoryCategoryId =
      GeneratedColumn<String>('inventory_category_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES inventory_categories (id)'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _rawNameMeta =
      const VerificationMeta('rawName');
  @override
  late final GeneratedColumn<String> rawName = GeneratedColumn<String>(
      'raw_name', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _quantityEstimatedMeta =
      const VerificationMeta('quantityEstimated');
  @override
  late final GeneratedColumn<double> quantityEstimated =
      GeneratedColumn<double>('quantity_estimated', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'unknown\' CHECK (status IN (\'unknown\', \'in_stock\', \'low\', \'out\'))',
      defaultValue: const CustomExpression('\'unknown\''));
  static const VerificationMeta _confidenceScoreMeta =
      const VerificationMeta('confidenceScore');
  @override
  late final GeneratedColumn<double> confidenceScore = GeneratedColumn<double>(
      'confidence_score', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.5));
  static const VerificationMeta _lastConfirmedAtMeta =
      const VerificationMeta('lastConfirmedAt');
  @override
  late final GeneratedColumn<DateTime> lastConfirmedAt =
      GeneratedColumn<DateTime>('last_confirmed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'local_only\' CHECK (sync_status IN (\'local_only\', \'pending_sync\', \'synced\', \'sync_error\'))',
      defaultValue: const CustomExpression('\'local_only\''));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        inventoryId,
        inventoryCategoryId,
        productId,
        rawName,
        quantityEstimated,
        unit,
        status,
        confidenceScore,
        lastConfirmedAt,
        createdAt,
        updatedAt,
        deletedAt,
        syncStatus,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_items';
  @override
  VerificationContext validateIntegrity(Insertable<InventoryItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('inventory_id')) {
      context.handle(
          _inventoryIdMeta,
          inventoryId.isAcceptableOrUnknown(
              data['inventory_id']!, _inventoryIdMeta));
    } else if (isInserting) {
      context.missing(_inventoryIdMeta);
    }
    if (data.containsKey('inventory_category_id')) {
      context.handle(
          _inventoryCategoryIdMeta,
          inventoryCategoryId.isAcceptableOrUnknown(
              data['inventory_category_id']!, _inventoryCategoryIdMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    }
    if (data.containsKey('raw_name')) {
      context.handle(_rawNameMeta,
          rawName.isAcceptableOrUnknown(data['raw_name']!, _rawNameMeta));
    }
    if (data.containsKey('quantity_estimated')) {
      context.handle(
          _quantityEstimatedMeta,
          quantityEstimated.isAcceptableOrUnknown(
              data['quantity_estimated']!, _quantityEstimatedMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('confidence_score')) {
      context.handle(
          _confidenceScoreMeta,
          confidenceScore.isAcceptableOrUnknown(
              data['confidence_score']!, _confidenceScoreMeta));
    }
    if (data.containsKey('last_confirmed_at')) {
      context.handle(
          _lastConfirmedAtMeta,
          lastConfirmedAt.isAcceptableOrUnknown(
              data['last_confirmed_at']!, _lastConfirmedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      inventoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}inventory_id'])!,
      inventoryCategoryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}inventory_category_id']),
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id']),
      rawName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}raw_name']),
      quantityEstimated: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}quantity_estimated']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      confidenceScore: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}confidence_score'])!,
      lastConfirmedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_confirmed_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $InventoryItemsTable createAlias(String alias) {
    return $InventoryItemsTable(attachedDatabase, alias);
  }
}

class InventoryItem extends DataClass implements Insertable<InventoryItem> {
  final String id;
  final String inventoryId;
  final String? inventoryCategoryId;
  final String? productId;
  final String? rawName;
  final double? quantityEstimated;
  final String? unit;
  final String status;
  final double confidenceScore;
  final DateTime? lastConfirmedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  final int version;
  const InventoryItem(
      {required this.id,
      required this.inventoryId,
      this.inventoryCategoryId,
      this.productId,
      this.rawName,
      this.quantityEstimated,
      this.unit,
      required this.status,
      required this.confidenceScore,
      this.lastConfirmedAt,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.syncStatus,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['inventory_id'] = Variable<String>(inventoryId);
    if (!nullToAbsent || inventoryCategoryId != null) {
      map['inventory_category_id'] = Variable<String>(inventoryCategoryId);
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    if (!nullToAbsent || rawName != null) {
      map['raw_name'] = Variable<String>(rawName);
    }
    if (!nullToAbsent || quantityEstimated != null) {
      map['quantity_estimated'] = Variable<double>(quantityEstimated);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['status'] = Variable<String>(status);
    map['confidence_score'] = Variable<double>(confidenceScore);
    if (!nullToAbsent || lastConfirmedAt != null) {
      map['last_confirmed_at'] = Variable<DateTime>(lastConfirmedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['version'] = Variable<int>(version);
    return map;
  }

  InventoryItemsCompanion toCompanion(bool nullToAbsent) {
    return InventoryItemsCompanion(
      id: Value(id),
      inventoryId: Value(inventoryId),
      inventoryCategoryId: inventoryCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(inventoryCategoryId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      rawName: rawName == null && nullToAbsent
          ? const Value.absent()
          : Value(rawName),
      quantityEstimated: quantityEstimated == null && nullToAbsent
          ? const Value.absent()
          : Value(quantityEstimated),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      status: Value(status),
      confidenceScore: Value(confidenceScore),
      lastConfirmedAt: lastConfirmedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastConfirmedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      version: Value(version),
    );
  }

  factory InventoryItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryItem(
      id: serializer.fromJson<String>(json['id']),
      inventoryId: serializer.fromJson<String>(json['inventoryId']),
      inventoryCategoryId:
          serializer.fromJson<String?>(json['inventoryCategoryId']),
      productId: serializer.fromJson<String?>(json['productId']),
      rawName: serializer.fromJson<String?>(json['rawName']),
      quantityEstimated:
          serializer.fromJson<double?>(json['quantityEstimated']),
      unit: serializer.fromJson<String?>(json['unit']),
      status: serializer.fromJson<String>(json['status']),
      confidenceScore: serializer.fromJson<double>(json['confidenceScore']),
      lastConfirmedAt: serializer.fromJson<DateTime?>(json['lastConfirmedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'inventoryId': serializer.toJson<String>(inventoryId),
      'inventoryCategoryId': serializer.toJson<String?>(inventoryCategoryId),
      'productId': serializer.toJson<String?>(productId),
      'rawName': serializer.toJson<String?>(rawName),
      'quantityEstimated': serializer.toJson<double?>(quantityEstimated),
      'unit': serializer.toJson<String?>(unit),
      'status': serializer.toJson<String>(status),
      'confidenceScore': serializer.toJson<double>(confidenceScore),
      'lastConfirmedAt': serializer.toJson<DateTime?>(lastConfirmedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'version': serializer.toJson<int>(version),
    };
  }

  InventoryItem copyWith(
          {String? id,
          String? inventoryId,
          Value<String?> inventoryCategoryId = const Value.absent(),
          Value<String?> productId = const Value.absent(),
          Value<String?> rawName = const Value.absent(),
          Value<double?> quantityEstimated = const Value.absent(),
          Value<String?> unit = const Value.absent(),
          String? status,
          double? confidenceScore,
          Value<DateTime?> lastConfirmedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          String? syncStatus,
          int? version}) =>
      InventoryItem(
        id: id ?? this.id,
        inventoryId: inventoryId ?? this.inventoryId,
        inventoryCategoryId: inventoryCategoryId.present
            ? inventoryCategoryId.value
            : this.inventoryCategoryId,
        productId: productId.present ? productId.value : this.productId,
        rawName: rawName.present ? rawName.value : this.rawName,
        quantityEstimated: quantityEstimated.present
            ? quantityEstimated.value
            : this.quantityEstimated,
        unit: unit.present ? unit.value : this.unit,
        status: status ?? this.status,
        confidenceScore: confidenceScore ?? this.confidenceScore,
        lastConfirmedAt: lastConfirmedAt.present
            ? lastConfirmedAt.value
            : this.lastConfirmedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        version: version ?? this.version,
      );
  InventoryItem copyWithCompanion(InventoryItemsCompanion data) {
    return InventoryItem(
      id: data.id.present ? data.id.value : this.id,
      inventoryId:
          data.inventoryId.present ? data.inventoryId.value : this.inventoryId,
      inventoryCategoryId: data.inventoryCategoryId.present
          ? data.inventoryCategoryId.value
          : this.inventoryCategoryId,
      productId: data.productId.present ? data.productId.value : this.productId,
      rawName: data.rawName.present ? data.rawName.value : this.rawName,
      quantityEstimated: data.quantityEstimated.present
          ? data.quantityEstimated.value
          : this.quantityEstimated,
      unit: data.unit.present ? data.unit.value : this.unit,
      status: data.status.present ? data.status.value : this.status,
      confidenceScore: data.confidenceScore.present
          ? data.confidenceScore.value
          : this.confidenceScore,
      lastConfirmedAt: data.lastConfirmedAt.present
          ? data.lastConfirmedAt.value
          : this.lastConfirmedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryItem(')
          ..write('id: $id, ')
          ..write('inventoryId: $inventoryId, ')
          ..write('inventoryCategoryId: $inventoryCategoryId, ')
          ..write('productId: $productId, ')
          ..write('rawName: $rawName, ')
          ..write('quantityEstimated: $quantityEstimated, ')
          ..write('unit: $unit, ')
          ..write('status: $status, ')
          ..write('confidenceScore: $confidenceScore, ')
          ..write('lastConfirmedAt: $lastConfirmedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      inventoryId,
      inventoryCategoryId,
      productId,
      rawName,
      quantityEstimated,
      unit,
      status,
      confidenceScore,
      lastConfirmedAt,
      createdAt,
      updatedAt,
      deletedAt,
      syncStatus,
      version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryItem &&
          other.id == this.id &&
          other.inventoryId == this.inventoryId &&
          other.inventoryCategoryId == this.inventoryCategoryId &&
          other.productId == this.productId &&
          other.rawName == this.rawName &&
          other.quantityEstimated == this.quantityEstimated &&
          other.unit == this.unit &&
          other.status == this.status &&
          other.confidenceScore == this.confidenceScore &&
          other.lastConfirmedAt == this.lastConfirmedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version);
}

class InventoryItemsCompanion extends UpdateCompanion<InventoryItem> {
  final Value<String> id;
  final Value<String> inventoryId;
  final Value<String?> inventoryCategoryId;
  final Value<String?> productId;
  final Value<String?> rawName;
  final Value<double?> quantityEstimated;
  final Value<String?> unit;
  final Value<String> status;
  final Value<double> confidenceScore;
  final Value<DateTime?> lastConfirmedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> version;
  final Value<int> rowid;
  const InventoryItemsCompanion({
    this.id = const Value.absent(),
    this.inventoryId = const Value.absent(),
    this.inventoryCategoryId = const Value.absent(),
    this.productId = const Value.absent(),
    this.rawName = const Value.absent(),
    this.quantityEstimated = const Value.absent(),
    this.unit = const Value.absent(),
    this.status = const Value.absent(),
    this.confidenceScore = const Value.absent(),
    this.lastConfirmedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryItemsCompanion.insert({
    required String id,
    required String inventoryId,
    this.inventoryCategoryId = const Value.absent(),
    this.productId = const Value.absent(),
    this.rawName = const Value.absent(),
    this.quantityEstimated = const Value.absent(),
    this.unit = const Value.absent(),
    this.status = const Value.absent(),
    this.confidenceScore = const Value.absent(),
    this.lastConfirmedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        inventoryId = Value(inventoryId);
  static Insertable<InventoryItem> custom({
    Expression<String>? id,
    Expression<String>? inventoryId,
    Expression<String>? inventoryCategoryId,
    Expression<String>? productId,
    Expression<String>? rawName,
    Expression<double>? quantityEstimated,
    Expression<String>? unit,
    Expression<String>? status,
    Expression<double>? confidenceScore,
    Expression<DateTime>? lastConfirmedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inventoryId != null) 'inventory_id': inventoryId,
      if (inventoryCategoryId != null)
        'inventory_category_id': inventoryCategoryId,
      if (productId != null) 'product_id': productId,
      if (rawName != null) 'raw_name': rawName,
      if (quantityEstimated != null) 'quantity_estimated': quantityEstimated,
      if (unit != null) 'unit': unit,
      if (status != null) 'status': status,
      if (confidenceScore != null) 'confidence_score': confidenceScore,
      if (lastConfirmedAt != null) 'last_confirmed_at': lastConfirmedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? inventoryId,
      Value<String?>? inventoryCategoryId,
      Value<String?>? productId,
      Value<String?>? rawName,
      Value<double?>? quantityEstimated,
      Value<String?>? unit,
      Value<String>? status,
      Value<double>? confidenceScore,
      Value<DateTime?>? lastConfirmedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<String>? syncStatus,
      Value<int>? version,
      Value<int>? rowid}) {
    return InventoryItemsCompanion(
      id: id ?? this.id,
      inventoryId: inventoryId ?? this.inventoryId,
      inventoryCategoryId: inventoryCategoryId ?? this.inventoryCategoryId,
      productId: productId ?? this.productId,
      rawName: rawName ?? this.rawName,
      quantityEstimated: quantityEstimated ?? this.quantityEstimated,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      lastConfirmedAt: lastConfirmedAt ?? this.lastConfirmedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (inventoryId.present) {
      map['inventory_id'] = Variable<String>(inventoryId.value);
    }
    if (inventoryCategoryId.present) {
      map['inventory_category_id'] =
          Variable<String>(inventoryCategoryId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (rawName.present) {
      map['raw_name'] = Variable<String>(rawName.value);
    }
    if (quantityEstimated.present) {
      map['quantity_estimated'] = Variable<double>(quantityEstimated.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (confidenceScore.present) {
      map['confidence_score'] = Variable<double>(confidenceScore.value);
    }
    if (lastConfirmedAt.present) {
      map['last_confirmed_at'] = Variable<DateTime>(lastConfirmedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryItemsCompanion(')
          ..write('id: $id, ')
          ..write('inventoryId: $inventoryId, ')
          ..write('inventoryCategoryId: $inventoryCategoryId, ')
          ..write('productId: $productId, ')
          ..write('rawName: $rawName, ')
          ..write('quantityEstimated: $quantityEstimated, ')
          ..write('unit: $unit, ')
          ..write('status: $status, ')
          ..write('confidenceScore: $confidenceScore, ')
          ..write('lastConfirmedAt: $lastConfirmedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingListsTable extends ShoppingLists
    with TableInfo<$ShoppingListsTable, ShoppingList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingListsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inventoryIdMeta =
      const VerificationMeta('inventoryId');
  @override
  late final GeneratedColumn<String> inventoryId = GeneratedColumn<String>(
      'inventory_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES inventories (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _listTypeMeta =
      const VerificationMeta('listType');
  @override
  late final GeneratedColumn<String> listType = GeneratedColumn<String>(
      'list_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'simple\' CHECK (list_type IN (\'simple\', \'organized\'))',
      defaultValue: const CustomExpression('\'simple\''));
  static const VerificationMeta _routingModeMeta =
      const VerificationMeta('routingMode');
  @override
  late final GeneratedColumn<String> routingMode = GeneratedColumn<String>(
      'routing_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'none\' CHECK (routing_mode IN (\'none\', \'inventory_categories\', \'category_as_inventory\'))',
      defaultValue: const CustomExpression('\'none\''));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'active\' CHECK (status IN (\'active\', \'completed\', \'archived\'))',
      defaultValue: const CustomExpression('\'active\''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'local_only\' CHECK (sync_status IN (\'local_only\', \'pending_sync\', \'synced\', \'sync_error\'))',
      defaultValue: const CustomExpression('\'local_only\''));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        inventoryId,
        name,
        listType,
        routingMode,
        status,
        createdAt,
        updatedAt,
        deletedAt,
        syncStatus,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_lists';
  @override
  VerificationContext validateIntegrity(Insertable<ShoppingList> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('inventory_id')) {
      context.handle(
          _inventoryIdMeta,
          inventoryId.isAcceptableOrUnknown(
              data['inventory_id']!, _inventoryIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('list_type')) {
      context.handle(_listTypeMeta,
          listType.isAcceptableOrUnknown(data['list_type']!, _listTypeMeta));
    }
    if (data.containsKey('routing_mode')) {
      context.handle(
          _routingModeMeta,
          routingMode.isAcceptableOrUnknown(
              data['routing_mode']!, _routingModeMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingList(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      inventoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}inventory_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      listType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}list_type'])!,
      routingMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}routing_mode'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $ShoppingListsTable createAlias(String alias) {
    return $ShoppingListsTable(attachedDatabase, alias);
  }
}

class ShoppingList extends DataClass implements Insertable<ShoppingList> {
  final String id;
  final String? inventoryId;
  final String name;
  final String listType;
  final String routingMode;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  final int version;
  const ShoppingList(
      {required this.id,
      this.inventoryId,
      required this.name,
      required this.listType,
      required this.routingMode,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.syncStatus,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || inventoryId != null) {
      map['inventory_id'] = Variable<String>(inventoryId);
    }
    map['name'] = Variable<String>(name);
    map['list_type'] = Variable<String>(listType);
    map['routing_mode'] = Variable<String>(routingMode);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['version'] = Variable<int>(version);
    return map;
  }

  ShoppingListsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListsCompanion(
      id: Value(id),
      inventoryId: inventoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(inventoryId),
      name: Value(name),
      listType: Value(listType),
      routingMode: Value(routingMode),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      version: Value(version),
    );
  }

  factory ShoppingList.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingList(
      id: serializer.fromJson<String>(json['id']),
      inventoryId: serializer.fromJson<String?>(json['inventoryId']),
      name: serializer.fromJson<String>(json['name']),
      listType: serializer.fromJson<String>(json['listType']),
      routingMode: serializer.fromJson<String>(json['routingMode']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'inventoryId': serializer.toJson<String?>(inventoryId),
      'name': serializer.toJson<String>(name),
      'listType': serializer.toJson<String>(listType),
      'routingMode': serializer.toJson<String>(routingMode),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'version': serializer.toJson<int>(version),
    };
  }

  ShoppingList copyWith(
          {String? id,
          Value<String?> inventoryId = const Value.absent(),
          String? name,
          String? listType,
          String? routingMode,
          String? status,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          String? syncStatus,
          int? version}) =>
      ShoppingList(
        id: id ?? this.id,
        inventoryId: inventoryId.present ? inventoryId.value : this.inventoryId,
        name: name ?? this.name,
        listType: listType ?? this.listType,
        routingMode: routingMode ?? this.routingMode,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        version: version ?? this.version,
      );
  ShoppingList copyWithCompanion(ShoppingListsCompanion data) {
    return ShoppingList(
      id: data.id.present ? data.id.value : this.id,
      inventoryId:
          data.inventoryId.present ? data.inventoryId.value : this.inventoryId,
      name: data.name.present ? data.name.value : this.name,
      listType: data.listType.present ? data.listType.value : this.listType,
      routingMode:
          data.routingMode.present ? data.routingMode.value : this.routingMode,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingList(')
          ..write('id: $id, ')
          ..write('inventoryId: $inventoryId, ')
          ..write('name: $name, ')
          ..write('listType: $listType, ')
          ..write('routingMode: $routingMode, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, inventoryId, name, listType, routingMode,
      status, createdAt, updatedAt, deletedAt, syncStatus, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingList &&
          other.id == this.id &&
          other.inventoryId == this.inventoryId &&
          other.name == this.name &&
          other.listType == this.listType &&
          other.routingMode == this.routingMode &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version);
}

class ShoppingListsCompanion extends UpdateCompanion<ShoppingList> {
  final Value<String> id;
  final Value<String?> inventoryId;
  final Value<String> name;
  final Value<String> listType;
  final Value<String> routingMode;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> version;
  final Value<int> rowid;
  const ShoppingListsCompanion({
    this.id = const Value.absent(),
    this.inventoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.listType = const Value.absent(),
    this.routingMode = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingListsCompanion.insert({
    required String id,
    this.inventoryId = const Value.absent(),
    required String name,
    this.listType = const Value.absent(),
    this.routingMode = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<ShoppingList> custom({
    Expression<String>? id,
    Expression<String>? inventoryId,
    Expression<String>? name,
    Expression<String>? listType,
    Expression<String>? routingMode,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inventoryId != null) 'inventory_id': inventoryId,
      if (name != null) 'name': name,
      if (listType != null) 'list_type': listType,
      if (routingMode != null) 'routing_mode': routingMode,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingListsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? inventoryId,
      Value<String>? name,
      Value<String>? listType,
      Value<String>? routingMode,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<String>? syncStatus,
      Value<int>? version,
      Value<int>? rowid}) {
    return ShoppingListsCompanion(
      id: id ?? this.id,
      inventoryId: inventoryId ?? this.inventoryId,
      name: name ?? this.name,
      listType: listType ?? this.listType,
      routingMode: routingMode ?? this.routingMode,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (inventoryId.present) {
      map['inventory_id'] = Variable<String>(inventoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (listType.present) {
      map['list_type'] = Variable<String>(listType.value);
    }
    if (routingMode.present) {
      map['routing_mode'] = Variable<String>(routingMode.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListsCompanion(')
          ..write('id: $id, ')
          ..write('inventoryId: $inventoryId, ')
          ..write('name: $name, ')
          ..write('listType: $listType, ')
          ..write('routingMode: $routingMode, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingListInventoryLinksTable extends ShoppingListInventoryLinks
    with
        TableInfo<$ShoppingListInventoryLinksTable, ShoppingListInventoryLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingListInventoryLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _shoppingListIdMeta =
      const VerificationMeta('shoppingListId');
  @override
  late final GeneratedColumn<String> shoppingListId = GeneratedColumn<String>(
      'shopping_list_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES shopping_lists (id) ON DELETE CASCADE'));
  static const VerificationMeta _inventoryIdMeta =
      const VerificationMeta('inventoryId');
  @override
  late final GeneratedColumn<String> inventoryId = GeneratedColumn<String>(
      'inventory_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES inventories (id) ON DELETE CASCADE'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'local_only\' CHECK (sync_status IN (\'local_only\', \'pending_sync\', \'synced\', \'sync_error\'))',
      defaultValue: const CustomExpression('\'local_only\''));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        shoppingListId,
        inventoryId,
        createdAt,
        deletedAt,
        syncStatus,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_list_inventory_links';
  @override
  VerificationContext validateIntegrity(
      Insertable<ShoppingListInventoryLink> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('shopping_list_id')) {
      context.handle(
          _shoppingListIdMeta,
          shoppingListId.isAcceptableOrUnknown(
              data['shopping_list_id']!, _shoppingListIdMeta));
    } else if (isInserting) {
      context.missing(_shoppingListIdMeta);
    }
    if (data.containsKey('inventory_id')) {
      context.handle(
          _inventoryIdMeta,
          inventoryId.isAcceptableOrUnknown(
              data['inventory_id']!, _inventoryIdMeta));
    } else if (isInserting) {
      context.missing(_inventoryIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingListInventoryLink map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingListInventoryLink(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      shoppingListId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}shopping_list_id'])!,
      inventoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}inventory_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $ShoppingListInventoryLinksTable createAlias(String alias) {
    return $ShoppingListInventoryLinksTable(attachedDatabase, alias);
  }
}

class ShoppingListInventoryLink extends DataClass
    implements Insertable<ShoppingListInventoryLink> {
  final String id;
  final String shoppingListId;
  final String inventoryId;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final String syncStatus;
  final int version;
  const ShoppingListInventoryLink(
      {required this.id,
      required this.shoppingListId,
      required this.inventoryId,
      required this.createdAt,
      this.deletedAt,
      required this.syncStatus,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shopping_list_id'] = Variable<String>(shoppingListId);
    map['inventory_id'] = Variable<String>(inventoryId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['version'] = Variable<int>(version);
    return map;
  }

  ShoppingListInventoryLinksCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListInventoryLinksCompanion(
      id: Value(id),
      shoppingListId: Value(shoppingListId),
      inventoryId: Value(inventoryId),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      version: Value(version),
    );
  }

  factory ShoppingListInventoryLink.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingListInventoryLink(
      id: serializer.fromJson<String>(json['id']),
      shoppingListId: serializer.fromJson<String>(json['shoppingListId']),
      inventoryId: serializer.fromJson<String>(json['inventoryId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shoppingListId': serializer.toJson<String>(shoppingListId),
      'inventoryId': serializer.toJson<String>(inventoryId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'version': serializer.toJson<int>(version),
    };
  }

  ShoppingListInventoryLink copyWith(
          {String? id,
          String? shoppingListId,
          String? inventoryId,
          DateTime? createdAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          String? syncStatus,
          int? version}) =>
      ShoppingListInventoryLink(
        id: id ?? this.id,
        shoppingListId: shoppingListId ?? this.shoppingListId,
        inventoryId: inventoryId ?? this.inventoryId,
        createdAt: createdAt ?? this.createdAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        version: version ?? this.version,
      );
  ShoppingListInventoryLink copyWithCompanion(
      ShoppingListInventoryLinksCompanion data) {
    return ShoppingListInventoryLink(
      id: data.id.present ? data.id.value : this.id,
      shoppingListId: data.shoppingListId.present
          ? data.shoppingListId.value
          : this.shoppingListId,
      inventoryId:
          data.inventoryId.present ? data.inventoryId.value : this.inventoryId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListInventoryLink(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('inventoryId: $inventoryId, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, shoppingListId, inventoryId, createdAt,
      deletedAt, syncStatus, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingListInventoryLink &&
          other.id == this.id &&
          other.shoppingListId == this.shoppingListId &&
          other.inventoryId == this.inventoryId &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version);
}

class ShoppingListInventoryLinksCompanion
    extends UpdateCompanion<ShoppingListInventoryLink> {
  final Value<String> id;
  final Value<String> shoppingListId;
  final Value<String> inventoryId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> version;
  final Value<int> rowid;
  const ShoppingListInventoryLinksCompanion({
    this.id = const Value.absent(),
    this.shoppingListId = const Value.absent(),
    this.inventoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingListInventoryLinksCompanion.insert({
    required String id,
    required String shoppingListId,
    required String inventoryId,
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        shoppingListId = Value(shoppingListId),
        inventoryId = Value(inventoryId);
  static Insertable<ShoppingListInventoryLink> custom({
    Expression<String>? id,
    Expression<String>? shoppingListId,
    Expression<String>? inventoryId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shoppingListId != null) 'shopping_list_id': shoppingListId,
      if (inventoryId != null) 'inventory_id': inventoryId,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingListInventoryLinksCompanion copyWith(
      {Value<String>? id,
      Value<String>? shoppingListId,
      Value<String>? inventoryId,
      Value<DateTime>? createdAt,
      Value<DateTime?>? deletedAt,
      Value<String>? syncStatus,
      Value<int>? version,
      Value<int>? rowid}) {
    return ShoppingListInventoryLinksCompanion(
      id: id ?? this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      inventoryId: inventoryId ?? this.inventoryId,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shoppingListId.present) {
      map['shopping_list_id'] = Variable<String>(shoppingListId.value);
    }
    if (inventoryId.present) {
      map['inventory_id'] = Variable<String>(inventoryId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListInventoryLinksCompanion(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('inventoryId: $inventoryId, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingListCategoriesTable extends ShoppingListCategories
    with TableInfo<$ShoppingListCategoriesTable, ShoppingListCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingListCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _shoppingListIdMeta =
      const VerificationMeta('shoppingListId');
  @override
  late final GeneratedColumn<String> shoppingListId = GeneratedColumn<String>(
      'shopping_list_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES shopping_lists (id) ON DELETE CASCADE'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES categories (id) ON DELETE CASCADE'));
  static const VerificationMeta _targetInventoryIdMeta =
      const VerificationMeta('targetInventoryId');
  @override
  late final GeneratedColumn<String> targetInventoryId =
      GeneratedColumn<String>('target_inventory_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES inventories (id)'));
  static const VerificationMeta _targetInventoryCategoryIdMeta =
      const VerificationMeta('targetInventoryCategoryId');
  @override
  late final GeneratedColumn<String> targetInventoryCategoryId =
      GeneratedColumn<String>('target_inventory_category_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES inventory_categories (id)'));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        shoppingListId,
        categoryId,
        targetInventoryId,
        targetInventoryCategoryId,
        sortOrder,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_list_categories';
  @override
  VerificationContext validateIntegrity(
      Insertable<ShoppingListCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('shopping_list_id')) {
      context.handle(
          _shoppingListIdMeta,
          shoppingListId.isAcceptableOrUnknown(
              data['shopping_list_id']!, _shoppingListIdMeta));
    } else if (isInserting) {
      context.missing(_shoppingListIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('target_inventory_id')) {
      context.handle(
          _targetInventoryIdMeta,
          targetInventoryId.isAcceptableOrUnknown(
              data['target_inventory_id']!, _targetInventoryIdMeta));
    }
    if (data.containsKey('target_inventory_category_id')) {
      context.handle(
          _targetInventoryCategoryIdMeta,
          targetInventoryCategoryId.isAcceptableOrUnknown(
              data['target_inventory_category_id']!,
              _targetInventoryCategoryIdMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingListCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingListCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      shoppingListId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}shopping_list_id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      targetInventoryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}target_inventory_id']),
      targetInventoryCategoryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}target_inventory_category_id']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $ShoppingListCategoriesTable createAlias(String alias) {
    return $ShoppingListCategoriesTable(attachedDatabase, alias);
  }
}

class ShoppingListCategory extends DataClass
    implements Insertable<ShoppingListCategory> {
  final String id;
  final String shoppingListId;
  final String categoryId;
  final String? targetInventoryId;
  final String? targetInventoryCategoryId;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const ShoppingListCategory(
      {required this.id,
      required this.shoppingListId,
      required this.categoryId,
      this.targetInventoryId,
      this.targetInventoryCategoryId,
      required this.sortOrder,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shopping_list_id'] = Variable<String>(shoppingListId);
    map['category_id'] = Variable<String>(categoryId);
    if (!nullToAbsent || targetInventoryId != null) {
      map['target_inventory_id'] = Variable<String>(targetInventoryId);
    }
    if (!nullToAbsent || targetInventoryCategoryId != null) {
      map['target_inventory_category_id'] =
          Variable<String>(targetInventoryCategoryId);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ShoppingListCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListCategoriesCompanion(
      id: Value(id),
      shoppingListId: Value(shoppingListId),
      categoryId: Value(categoryId),
      targetInventoryId: targetInventoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(targetInventoryId),
      targetInventoryCategoryId:
          targetInventoryCategoryId == null && nullToAbsent
              ? const Value.absent()
              : Value(targetInventoryCategoryId),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ShoppingListCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingListCategory(
      id: serializer.fromJson<String>(json['id']),
      shoppingListId: serializer.fromJson<String>(json['shoppingListId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      targetInventoryId:
          serializer.fromJson<String?>(json['targetInventoryId']),
      targetInventoryCategoryId:
          serializer.fromJson<String?>(json['targetInventoryCategoryId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shoppingListId': serializer.toJson<String>(shoppingListId),
      'categoryId': serializer.toJson<String>(categoryId),
      'targetInventoryId': serializer.toJson<String?>(targetInventoryId),
      'targetInventoryCategoryId':
          serializer.toJson<String?>(targetInventoryCategoryId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  ShoppingListCategory copyWith(
          {String? id,
          String? shoppingListId,
          String? categoryId,
          Value<String?> targetInventoryId = const Value.absent(),
          Value<String?> targetInventoryCategoryId = const Value.absent(),
          int? sortOrder,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      ShoppingListCategory(
        id: id ?? this.id,
        shoppingListId: shoppingListId ?? this.shoppingListId,
        categoryId: categoryId ?? this.categoryId,
        targetInventoryId: targetInventoryId.present
            ? targetInventoryId.value
            : this.targetInventoryId,
        targetInventoryCategoryId: targetInventoryCategoryId.present
            ? targetInventoryCategoryId.value
            : this.targetInventoryCategoryId,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  ShoppingListCategory copyWithCompanion(ShoppingListCategoriesCompanion data) {
    return ShoppingListCategory(
      id: data.id.present ? data.id.value : this.id,
      shoppingListId: data.shoppingListId.present
          ? data.shoppingListId.value
          : this.shoppingListId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      targetInventoryId: data.targetInventoryId.present
          ? data.targetInventoryId.value
          : this.targetInventoryId,
      targetInventoryCategoryId: data.targetInventoryCategoryId.present
          ? data.targetInventoryCategoryId.value
          : this.targetInventoryCategoryId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListCategory(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('categoryId: $categoryId, ')
          ..write('targetInventoryId: $targetInventoryId, ')
          ..write('targetInventoryCategoryId: $targetInventoryCategoryId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      shoppingListId,
      categoryId,
      targetInventoryId,
      targetInventoryCategoryId,
      sortOrder,
      createdAt,
      updatedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingListCategory &&
          other.id == this.id &&
          other.shoppingListId == this.shoppingListId &&
          other.categoryId == this.categoryId &&
          other.targetInventoryId == this.targetInventoryId &&
          other.targetInventoryCategoryId == this.targetInventoryCategoryId &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ShoppingListCategoriesCompanion
    extends UpdateCompanion<ShoppingListCategory> {
  final Value<String> id;
  final Value<String> shoppingListId;
  final Value<String> categoryId;
  final Value<String?> targetInventoryId;
  final Value<String?> targetInventoryCategoryId;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ShoppingListCategoriesCompanion({
    this.id = const Value.absent(),
    this.shoppingListId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.targetInventoryId = const Value.absent(),
    this.targetInventoryCategoryId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingListCategoriesCompanion.insert({
    required String id,
    required String shoppingListId,
    required String categoryId,
    this.targetInventoryId = const Value.absent(),
    this.targetInventoryCategoryId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        shoppingListId = Value(shoppingListId),
        categoryId = Value(categoryId);
  static Insertable<ShoppingListCategory> custom({
    Expression<String>? id,
    Expression<String>? shoppingListId,
    Expression<String>? categoryId,
    Expression<String>? targetInventoryId,
    Expression<String>? targetInventoryCategoryId,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shoppingListId != null) 'shopping_list_id': shoppingListId,
      if (categoryId != null) 'category_id': categoryId,
      if (targetInventoryId != null) 'target_inventory_id': targetInventoryId,
      if (targetInventoryCategoryId != null)
        'target_inventory_category_id': targetInventoryCategoryId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingListCategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? shoppingListId,
      Value<String>? categoryId,
      Value<String?>? targetInventoryId,
      Value<String?>? targetInventoryCategoryId,
      Value<int>? sortOrder,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return ShoppingListCategoriesCompanion(
      id: id ?? this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      categoryId: categoryId ?? this.categoryId,
      targetInventoryId: targetInventoryId ?? this.targetInventoryId,
      targetInventoryCategoryId:
          targetInventoryCategoryId ?? this.targetInventoryCategoryId,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shoppingListId.present) {
      map['shopping_list_id'] = Variable<String>(shoppingListId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (targetInventoryId.present) {
      map['target_inventory_id'] = Variable<String>(targetInventoryId.value);
    }
    if (targetInventoryCategoryId.present) {
      map['target_inventory_category_id'] =
          Variable<String>(targetInventoryCategoryId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('categoryId: $categoryId, ')
          ..write('targetInventoryId: $targetInventoryId, ')
          ..write('targetInventoryCategoryId: $targetInventoryCategoryId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingListItemsTable extends ShoppingListItems
    with TableInfo<$ShoppingListItemsTable, ShoppingListItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingListItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _shoppingListIdMeta =
      const VerificationMeta('shoppingListId');
  @override
  late final GeneratedColumn<String> shoppingListId = GeneratedColumn<String>(
      'shopping_list_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES shopping_lists (id)'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _targetInventoryIdMeta =
      const VerificationMeta('targetInventoryId');
  @override
  late final GeneratedColumn<String> targetInventoryId =
      GeneratedColumn<String>('target_inventory_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES inventories (id)'));
  static const VerificationMeta _targetInventoryCategoryIdMeta =
      const VerificationMeta('targetInventoryCategoryId');
  @override
  late final GeneratedColumn<String> targetInventoryCategoryId =
      GeneratedColumn<String>('target_inventory_category_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES inventory_categories (id)'));
  static const VerificationMeta _rawTextMeta =
      const VerificationMeta('rawText');
  @override
  late final GeneratedColumn<String> rawText = GeneratedColumn<String>(
      'raw_text', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 160),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'pending\' CHECK (status IN (\'pending\', \'purchased\', \'skipped\'))',
      defaultValue: const CustomExpression('\'pending\''));
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'manual\' CHECK (source IN (\'manual\', \'suggestion\', \'import\'))',
      defaultValue: const CustomExpression('\'manual\''));
  static const VerificationMeta _priorityScoreMeta =
      const VerificationMeta('priorityScore');
  @override
  late final GeneratedColumn<double> priorityScore = GeneratedColumn<double>(
      'priority_score', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _purchasedAtMeta =
      const VerificationMeta('purchasedAt');
  @override
  late final GeneratedColumn<DateTime> purchasedAt = GeneratedColumn<DateTime>(
      'purchased_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'local_only\' CHECK (sync_status IN (\'local_only\', \'pending_sync\', \'synced\', \'sync_error\'))',
      defaultValue: const CustomExpression('\'local_only\''));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        shoppingListId,
        productId,
        categoryId,
        targetInventoryId,
        targetInventoryCategoryId,
        rawText,
        quantity,
        unit,
        status,
        source,
        priorityScore,
        createdAt,
        updatedAt,
        purchasedAt,
        deletedAt,
        syncStatus,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_list_items';
  @override
  VerificationContext validateIntegrity(Insertable<ShoppingListItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('shopping_list_id')) {
      context.handle(
          _shoppingListIdMeta,
          shoppingListId.isAcceptableOrUnknown(
              data['shopping_list_id']!, _shoppingListIdMeta));
    } else if (isInserting) {
      context.missing(_shoppingListIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('target_inventory_id')) {
      context.handle(
          _targetInventoryIdMeta,
          targetInventoryId.isAcceptableOrUnknown(
              data['target_inventory_id']!, _targetInventoryIdMeta));
    }
    if (data.containsKey('target_inventory_category_id')) {
      context.handle(
          _targetInventoryCategoryIdMeta,
          targetInventoryCategoryId.isAcceptableOrUnknown(
              data['target_inventory_category_id']!,
              _targetInventoryCategoryIdMeta));
    }
    if (data.containsKey('raw_text')) {
      context.handle(_rawTextMeta,
          rawText.isAcceptableOrUnknown(data['raw_text']!, _rawTextMeta));
    } else if (isInserting) {
      context.missing(_rawTextMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('priority_score')) {
      context.handle(
          _priorityScoreMeta,
          priorityScore.isAcceptableOrUnknown(
              data['priority_score']!, _priorityScoreMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('purchased_at')) {
      context.handle(
          _purchasedAtMeta,
          purchasedAt.isAcceptableOrUnknown(
              data['purchased_at']!, _purchasedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingListItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingListItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      shoppingListId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}shopping_list_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      targetInventoryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}target_inventory_id']),
      targetInventoryCategoryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}target_inventory_category_id']),
      rawText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}raw_text'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      priorityScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}priority_score'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      purchasedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}purchased_at']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $ShoppingListItemsTable createAlias(String alias) {
    return $ShoppingListItemsTable(attachedDatabase, alias);
  }
}

class ShoppingListItem extends DataClass
    implements Insertable<ShoppingListItem> {
  final String id;
  final String shoppingListId;
  final String? productId;
  final String? categoryId;
  final String? targetInventoryId;
  final String? targetInventoryCategoryId;
  final String rawText;
  final double? quantity;
  final String? unit;
  final String status;
  final String source;
  final double priorityScore;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? purchasedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  final int version;
  const ShoppingListItem(
      {required this.id,
      required this.shoppingListId,
      this.productId,
      this.categoryId,
      this.targetInventoryId,
      this.targetInventoryCategoryId,
      required this.rawText,
      this.quantity,
      this.unit,
      required this.status,
      required this.source,
      required this.priorityScore,
      required this.createdAt,
      required this.updatedAt,
      this.purchasedAt,
      this.deletedAt,
      required this.syncStatus,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shopping_list_id'] = Variable<String>(shoppingListId);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || targetInventoryId != null) {
      map['target_inventory_id'] = Variable<String>(targetInventoryId);
    }
    if (!nullToAbsent || targetInventoryCategoryId != null) {
      map['target_inventory_category_id'] =
          Variable<String>(targetInventoryCategoryId);
    }
    map['raw_text'] = Variable<String>(rawText);
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<double>(quantity);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['status'] = Variable<String>(status);
    map['source'] = Variable<String>(source);
    map['priority_score'] = Variable<double>(priorityScore);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || purchasedAt != null) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['version'] = Variable<int>(version);
    return map;
  }

  ShoppingListItemsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListItemsCompanion(
      id: Value(id),
      shoppingListId: Value(shoppingListId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      targetInventoryId: targetInventoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(targetInventoryId),
      targetInventoryCategoryId:
          targetInventoryCategoryId == null && nullToAbsent
              ? const Value.absent()
              : Value(targetInventoryCategoryId),
      rawText: Value(rawText),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      status: Value(status),
      source: Value(source),
      priorityScore: Value(priorityScore),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      purchasedAt: purchasedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      version: Value(version),
    );
  }

  factory ShoppingListItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingListItem(
      id: serializer.fromJson<String>(json['id']),
      shoppingListId: serializer.fromJson<String>(json['shoppingListId']),
      productId: serializer.fromJson<String?>(json['productId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      targetInventoryId:
          serializer.fromJson<String?>(json['targetInventoryId']),
      targetInventoryCategoryId:
          serializer.fromJson<String?>(json['targetInventoryCategoryId']),
      rawText: serializer.fromJson<String>(json['rawText']),
      quantity: serializer.fromJson<double?>(json['quantity']),
      unit: serializer.fromJson<String?>(json['unit']),
      status: serializer.fromJson<String>(json['status']),
      source: serializer.fromJson<String>(json['source']),
      priorityScore: serializer.fromJson<double>(json['priorityScore']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      purchasedAt: serializer.fromJson<DateTime?>(json['purchasedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shoppingListId': serializer.toJson<String>(shoppingListId),
      'productId': serializer.toJson<String?>(productId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'targetInventoryId': serializer.toJson<String?>(targetInventoryId),
      'targetInventoryCategoryId':
          serializer.toJson<String?>(targetInventoryCategoryId),
      'rawText': serializer.toJson<String>(rawText),
      'quantity': serializer.toJson<double?>(quantity),
      'unit': serializer.toJson<String?>(unit),
      'status': serializer.toJson<String>(status),
      'source': serializer.toJson<String>(source),
      'priorityScore': serializer.toJson<double>(priorityScore),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'purchasedAt': serializer.toJson<DateTime?>(purchasedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'version': serializer.toJson<int>(version),
    };
  }

  ShoppingListItem copyWith(
          {String? id,
          String? shoppingListId,
          Value<String?> productId = const Value.absent(),
          Value<String?> categoryId = const Value.absent(),
          Value<String?> targetInventoryId = const Value.absent(),
          Value<String?> targetInventoryCategoryId = const Value.absent(),
          String? rawText,
          Value<double?> quantity = const Value.absent(),
          Value<String?> unit = const Value.absent(),
          String? status,
          String? source,
          double? priorityScore,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> purchasedAt = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent(),
          String? syncStatus,
          int? version}) =>
      ShoppingListItem(
        id: id ?? this.id,
        shoppingListId: shoppingListId ?? this.shoppingListId,
        productId: productId.present ? productId.value : this.productId,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        targetInventoryId: targetInventoryId.present
            ? targetInventoryId.value
            : this.targetInventoryId,
        targetInventoryCategoryId: targetInventoryCategoryId.present
            ? targetInventoryCategoryId.value
            : this.targetInventoryCategoryId,
        rawText: rawText ?? this.rawText,
        quantity: quantity.present ? quantity.value : this.quantity,
        unit: unit.present ? unit.value : this.unit,
        status: status ?? this.status,
        source: source ?? this.source,
        priorityScore: priorityScore ?? this.priorityScore,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        purchasedAt: purchasedAt.present ? purchasedAt.value : this.purchasedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        version: version ?? this.version,
      );
  ShoppingListItem copyWithCompanion(ShoppingListItemsCompanion data) {
    return ShoppingListItem(
      id: data.id.present ? data.id.value : this.id,
      shoppingListId: data.shoppingListId.present
          ? data.shoppingListId.value
          : this.shoppingListId,
      productId: data.productId.present ? data.productId.value : this.productId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      targetInventoryId: data.targetInventoryId.present
          ? data.targetInventoryId.value
          : this.targetInventoryId,
      targetInventoryCategoryId: data.targetInventoryCategoryId.present
          ? data.targetInventoryCategoryId.value
          : this.targetInventoryCategoryId,
      rawText: data.rawText.present ? data.rawText.value : this.rawText,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      status: data.status.present ? data.status.value : this.status,
      source: data.source.present ? data.source.value : this.source,
      priorityScore: data.priorityScore.present
          ? data.priorityScore.value
          : this.priorityScore,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      purchasedAt:
          data.purchasedAt.present ? data.purchasedAt.value : this.purchasedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListItem(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('productId: $productId, ')
          ..write('categoryId: $categoryId, ')
          ..write('targetInventoryId: $targetInventoryId, ')
          ..write('targetInventoryCategoryId: $targetInventoryCategoryId, ')
          ..write('rawText: $rawText, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('priorityScore: $priorityScore, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      shoppingListId,
      productId,
      categoryId,
      targetInventoryId,
      targetInventoryCategoryId,
      rawText,
      quantity,
      unit,
      status,
      source,
      priorityScore,
      createdAt,
      updatedAt,
      purchasedAt,
      deletedAt,
      syncStatus,
      version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingListItem &&
          other.id == this.id &&
          other.shoppingListId == this.shoppingListId &&
          other.productId == this.productId &&
          other.categoryId == this.categoryId &&
          other.targetInventoryId == this.targetInventoryId &&
          other.targetInventoryCategoryId == this.targetInventoryCategoryId &&
          other.rawText == this.rawText &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.status == this.status &&
          other.source == this.source &&
          other.priorityScore == this.priorityScore &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.purchasedAt == this.purchasedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version);
}

class ShoppingListItemsCompanion extends UpdateCompanion<ShoppingListItem> {
  final Value<String> id;
  final Value<String> shoppingListId;
  final Value<String?> productId;
  final Value<String?> categoryId;
  final Value<String?> targetInventoryId;
  final Value<String?> targetInventoryCategoryId;
  final Value<String> rawText;
  final Value<double?> quantity;
  final Value<String?> unit;
  final Value<String> status;
  final Value<String> source;
  final Value<double> priorityScore;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> purchasedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> version;
  final Value<int> rowid;
  const ShoppingListItemsCompanion({
    this.id = const Value.absent(),
    this.shoppingListId = const Value.absent(),
    this.productId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.targetInventoryId = const Value.absent(),
    this.targetInventoryCategoryId = const Value.absent(),
    this.rawText = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.priorityScore = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingListItemsCompanion.insert({
    required String id,
    required String shoppingListId,
    this.productId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.targetInventoryId = const Value.absent(),
    this.targetInventoryCategoryId = const Value.absent(),
    required String rawText,
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.priorityScore = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        shoppingListId = Value(shoppingListId),
        rawText = Value(rawText);
  static Insertable<ShoppingListItem> custom({
    Expression<String>? id,
    Expression<String>? shoppingListId,
    Expression<String>? productId,
    Expression<String>? categoryId,
    Expression<String>? targetInventoryId,
    Expression<String>? targetInventoryCategoryId,
    Expression<String>? rawText,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<String>? status,
    Expression<String>? source,
    Expression<double>? priorityScore,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? purchasedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shoppingListId != null) 'shopping_list_id': shoppingListId,
      if (productId != null) 'product_id': productId,
      if (categoryId != null) 'category_id': categoryId,
      if (targetInventoryId != null) 'target_inventory_id': targetInventoryId,
      if (targetInventoryCategoryId != null)
        'target_inventory_category_id': targetInventoryCategoryId,
      if (rawText != null) 'raw_text': rawText,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (status != null) 'status': status,
      if (source != null) 'source': source,
      if (priorityScore != null) 'priority_score': priorityScore,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingListItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? shoppingListId,
      Value<String?>? productId,
      Value<String?>? categoryId,
      Value<String?>? targetInventoryId,
      Value<String?>? targetInventoryCategoryId,
      Value<String>? rawText,
      Value<double?>? quantity,
      Value<String?>? unit,
      Value<String>? status,
      Value<String>? source,
      Value<double>? priorityScore,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? purchasedAt,
      Value<DateTime?>? deletedAt,
      Value<String>? syncStatus,
      Value<int>? version,
      Value<int>? rowid}) {
    return ShoppingListItemsCompanion(
      id: id ?? this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      productId: productId ?? this.productId,
      categoryId: categoryId ?? this.categoryId,
      targetInventoryId: targetInventoryId ?? this.targetInventoryId,
      targetInventoryCategoryId:
          targetInventoryCategoryId ?? this.targetInventoryCategoryId,
      rawText: rawText ?? this.rawText,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      source: source ?? this.source,
      priorityScore: priorityScore ?? this.priorityScore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shoppingListId.present) {
      map['shopping_list_id'] = Variable<String>(shoppingListId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (targetInventoryId.present) {
      map['target_inventory_id'] = Variable<String>(targetInventoryId.value);
    }
    if (targetInventoryCategoryId.present) {
      map['target_inventory_category_id'] =
          Variable<String>(targetInventoryCategoryId.value);
    }
    if (rawText.present) {
      map['raw_text'] = Variable<String>(rawText.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (priorityScore.present) {
      map['priority_score'] = Variable<double>(priorityScore.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (purchasedAt.present) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListItemsCompanion(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('productId: $productId, ')
          ..write('categoryId: $categoryId, ')
          ..write('targetInventoryId: $targetInventoryId, ')
          ..write('targetInventoryCategoryId: $targetInventoryCategoryId, ')
          ..write('rawText: $rawText, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('priorityScore: $priorityScore, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryEventsTable extends InventoryEvents
    with TableInfo<$InventoryEventsTable, InventoryEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inventoryIdMeta =
      const VerificationMeta('inventoryId');
  @override
  late final GeneratedColumn<String> inventoryId = GeneratedColumn<String>(
      'inventory_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES inventories (id)'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _inventoryItemIdMeta =
      const VerificationMeta('inventoryItemId');
  @override
  late final GeneratedColumn<String> inventoryItemId = GeneratedColumn<String>(
      'inventory_item_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES inventory_items (id)'));
  static const VerificationMeta _eventTypeMeta =
      const VerificationMeta('eventType');
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
      'event_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'adjust\' CHECK (event_type IN (\'add\', \'purchase\', \'consume\', \'adjust\', \'confirm\', \'finish\', \'discard\'))',
      defaultValue: const CustomExpression('\'adjust\''));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'manual\' CHECK (source IN (\'manual\', \'receipt\', \'system\'))',
      defaultValue: const CustomExpression('\'manual\''));
  static const VerificationMeta _occurredAtMeta =
      const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
      'occurred_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        inventoryId,
        productId,
        inventoryItemId,
        eventType,
        quantity,
        unit,
        source,
        occurredAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_events';
  @override
  VerificationContext validateIntegrity(Insertable<InventoryEvent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('inventory_id')) {
      context.handle(
          _inventoryIdMeta,
          inventoryId.isAcceptableOrUnknown(
              data['inventory_id']!, _inventoryIdMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    }
    if (data.containsKey('inventory_item_id')) {
      context.handle(
          _inventoryItemIdMeta,
          inventoryItemId.isAcceptableOrUnknown(
              data['inventory_item_id']!, _inventoryItemIdMeta));
    }
    if (data.containsKey('event_type')) {
      context.handle(_eventTypeMeta,
          eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
          _occurredAtMeta,
          occurredAt.isAcceptableOrUnknown(
              data['occurred_at']!, _occurredAtMeta));
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryEvent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      inventoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}inventory_id']),
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id']),
      inventoryItemId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}inventory_item_id']),
      eventType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_type'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      occurredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}occurred_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $InventoryEventsTable createAlias(String alias) {
    return $InventoryEventsTable(attachedDatabase, alias);
  }
}

class InventoryEvent extends DataClass implements Insertable<InventoryEvent> {
  final String id;
  final String? inventoryId;
  final String? productId;
  final String? inventoryItemId;
  final String eventType;
  final double? quantity;
  final String? unit;
  final String source;
  final DateTime occurredAt;
  final DateTime createdAt;
  const InventoryEvent(
      {required this.id,
      this.inventoryId,
      this.productId,
      this.inventoryItemId,
      required this.eventType,
      this.quantity,
      this.unit,
      required this.source,
      required this.occurredAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || inventoryId != null) {
      map['inventory_id'] = Variable<String>(inventoryId);
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    if (!nullToAbsent || inventoryItemId != null) {
      map['inventory_item_id'] = Variable<String>(inventoryItemId);
    }
    map['event_type'] = Variable<String>(eventType);
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<double>(quantity);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['source'] = Variable<String>(source);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InventoryEventsCompanion toCompanion(bool nullToAbsent) {
    return InventoryEventsCompanion(
      id: Value(id),
      inventoryId: inventoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(inventoryId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      inventoryItemId: inventoryItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(inventoryItemId),
      eventType: Value(eventType),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      source: Value(source),
      occurredAt: Value(occurredAt),
      createdAt: Value(createdAt),
    );
  }

  factory InventoryEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryEvent(
      id: serializer.fromJson<String>(json['id']),
      inventoryId: serializer.fromJson<String?>(json['inventoryId']),
      productId: serializer.fromJson<String?>(json['productId']),
      inventoryItemId: serializer.fromJson<String?>(json['inventoryItemId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      quantity: serializer.fromJson<double?>(json['quantity']),
      unit: serializer.fromJson<String?>(json['unit']),
      source: serializer.fromJson<String>(json['source']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'inventoryId': serializer.toJson<String?>(inventoryId),
      'productId': serializer.toJson<String?>(productId),
      'inventoryItemId': serializer.toJson<String?>(inventoryItemId),
      'eventType': serializer.toJson<String>(eventType),
      'quantity': serializer.toJson<double?>(quantity),
      'unit': serializer.toJson<String?>(unit),
      'source': serializer.toJson<String>(source),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InventoryEvent copyWith(
          {String? id,
          Value<String?> inventoryId = const Value.absent(),
          Value<String?> productId = const Value.absent(),
          Value<String?> inventoryItemId = const Value.absent(),
          String? eventType,
          Value<double?> quantity = const Value.absent(),
          Value<String?> unit = const Value.absent(),
          String? source,
          DateTime? occurredAt,
          DateTime? createdAt}) =>
      InventoryEvent(
        id: id ?? this.id,
        inventoryId: inventoryId.present ? inventoryId.value : this.inventoryId,
        productId: productId.present ? productId.value : this.productId,
        inventoryItemId: inventoryItemId.present
            ? inventoryItemId.value
            : this.inventoryItemId,
        eventType: eventType ?? this.eventType,
        quantity: quantity.present ? quantity.value : this.quantity,
        unit: unit.present ? unit.value : this.unit,
        source: source ?? this.source,
        occurredAt: occurredAt ?? this.occurredAt,
        createdAt: createdAt ?? this.createdAt,
      );
  InventoryEvent copyWithCompanion(InventoryEventsCompanion data) {
    return InventoryEvent(
      id: data.id.present ? data.id.value : this.id,
      inventoryId:
          data.inventoryId.present ? data.inventoryId.value : this.inventoryId,
      productId: data.productId.present ? data.productId.value : this.productId,
      inventoryItemId: data.inventoryItemId.present
          ? data.inventoryItemId.value
          : this.inventoryItemId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      source: data.source.present ? data.source.value : this.source,
      occurredAt:
          data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryEvent(')
          ..write('id: $id, ')
          ..write('inventoryId: $inventoryId, ')
          ..write('productId: $productId, ')
          ..write('inventoryItemId: $inventoryItemId, ')
          ..write('eventType: $eventType, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('source: $source, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, inventoryId, productId, inventoryItemId,
      eventType, quantity, unit, source, occurredAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryEvent &&
          other.id == this.id &&
          other.inventoryId == this.inventoryId &&
          other.productId == this.productId &&
          other.inventoryItemId == this.inventoryItemId &&
          other.eventType == this.eventType &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.source == this.source &&
          other.occurredAt == this.occurredAt &&
          other.createdAt == this.createdAt);
}

class InventoryEventsCompanion extends UpdateCompanion<InventoryEvent> {
  final Value<String> id;
  final Value<String?> inventoryId;
  final Value<String?> productId;
  final Value<String?> inventoryItemId;
  final Value<String> eventType;
  final Value<double?> quantity;
  final Value<String?> unit;
  final Value<String> source;
  final Value<DateTime> occurredAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const InventoryEventsCompanion({
    this.id = const Value.absent(),
    this.inventoryId = const Value.absent(),
    this.productId = const Value.absent(),
    this.inventoryItemId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.source = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryEventsCompanion.insert({
    required String id,
    this.inventoryId = const Value.absent(),
    this.productId = const Value.absent(),
    this.inventoryItemId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.source = const Value.absent(),
    required DateTime occurredAt,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        occurredAt = Value(occurredAt);
  static Insertable<InventoryEvent> custom({
    Expression<String>? id,
    Expression<String>? inventoryId,
    Expression<String>? productId,
    Expression<String>? inventoryItemId,
    Expression<String>? eventType,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<String>? source,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inventoryId != null) 'inventory_id': inventoryId,
      if (productId != null) 'product_id': productId,
      if (inventoryItemId != null) 'inventory_item_id': inventoryItemId,
      if (eventType != null) 'event_type': eventType,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (source != null) 'source': source,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryEventsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? inventoryId,
      Value<String?>? productId,
      Value<String?>? inventoryItemId,
      Value<String>? eventType,
      Value<double?>? quantity,
      Value<String?>? unit,
      Value<String>? source,
      Value<DateTime>? occurredAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return InventoryEventsCompanion(
      id: id ?? this.id,
      inventoryId: inventoryId ?? this.inventoryId,
      productId: productId ?? this.productId,
      inventoryItemId: inventoryItemId ?? this.inventoryItemId,
      eventType: eventType ?? this.eventType,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      source: source ?? this.source,
      occurredAt: occurredAt ?? this.occurredAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (inventoryId.present) {
      map['inventory_id'] = Variable<String>(inventoryId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (inventoryItemId.present) {
      map['inventory_item_id'] = Variable<String>(inventoryItemId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryEventsCompanion(')
          ..write('id: $id, ')
          ..write('inventoryId: $inventoryId, ')
          ..write('productId: $productId, ')
          ..write('inventoryItemId: $inventoryItemId, ')
          ..write('eventType: $eventType, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('source: $source, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PriceObservationsTable extends PriceObservations
    with TableInfo<$PriceObservationsTable, PriceObservation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PriceObservationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _storeNameMeta =
      const VerificationMeta('storeName');
  @override
  late final GeneratedColumn<String> storeName = GeneratedColumn<String>(
      'store_name', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _packageQuantityMeta =
      const VerificationMeta('packageQuantity');
  @override
  late final GeneratedColumn<double> packageQuantity = GeneratedColumn<double>(
      'package_quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _packageUnitMeta =
      const VerificationMeta('packageUnit');
  @override
  late final GeneratedColumn<String> packageUnit = GeneratedColumn<String>(
      'package_unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'unit\' CHECK (package_unit IN (\'unit\', \'kg\', \'g\', \'liter\', \'ml\', \'pack\'))',
      defaultValue: const CustomExpression('\'unit\''));
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _observedAtMeta =
      const VerificationMeta('observedAt');
  @override
  late final GeneratedColumn<DateTime> observedAt = GeneratedColumn<DateTime>(
      'observed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productId,
        storeName,
        packageQuantity,
        packageUnit,
        price,
        unitPrice,
        observedAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'price_observations';
  @override
  VerificationContext validateIntegrity(Insertable<PriceObservation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    }
    if (data.containsKey('store_name')) {
      context.handle(_storeNameMeta,
          storeName.isAcceptableOrUnknown(data['store_name']!, _storeNameMeta));
    }
    if (data.containsKey('package_quantity')) {
      context.handle(
          _packageQuantityMeta,
          packageQuantity.isAcceptableOrUnknown(
              data['package_quantity']!, _packageQuantityMeta));
    } else if (isInserting) {
      context.missing(_packageQuantityMeta);
    }
    if (data.containsKey('package_unit')) {
      context.handle(
          _packageUnitMeta,
          packageUnit.isAcceptableOrUnknown(
              data['package_unit']!, _packageUnitMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('observed_at')) {
      context.handle(
          _observedAtMeta,
          observedAt.isAcceptableOrUnknown(
              data['observed_at']!, _observedAtMeta));
    } else if (isInserting) {
      context.missing(_observedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PriceObservation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PriceObservation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id']),
      storeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}store_name']),
      packageQuantity: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}package_quantity'])!,
      packageUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}package_unit'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_price'])!,
      observedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}observed_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PriceObservationsTable createAlias(String alias) {
    return $PriceObservationsTable(attachedDatabase, alias);
  }
}

class PriceObservation extends DataClass
    implements Insertable<PriceObservation> {
  final String id;
  final String? productId;
  final String? storeName;
  final double packageQuantity;
  final String packageUnit;
  final double price;
  final double unitPrice;
  final DateTime observedAt;
  final DateTime createdAt;
  const PriceObservation(
      {required this.id,
      this.productId,
      this.storeName,
      required this.packageQuantity,
      required this.packageUnit,
      required this.price,
      required this.unitPrice,
      required this.observedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    if (!nullToAbsent || storeName != null) {
      map['store_name'] = Variable<String>(storeName);
    }
    map['package_quantity'] = Variable<double>(packageQuantity);
    map['package_unit'] = Variable<String>(packageUnit);
    map['price'] = Variable<double>(price);
    map['unit_price'] = Variable<double>(unitPrice);
    map['observed_at'] = Variable<DateTime>(observedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PriceObservationsCompanion toCompanion(bool nullToAbsent) {
    return PriceObservationsCompanion(
      id: Value(id),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      storeName: storeName == null && nullToAbsent
          ? const Value.absent()
          : Value(storeName),
      packageQuantity: Value(packageQuantity),
      packageUnit: Value(packageUnit),
      price: Value(price),
      unitPrice: Value(unitPrice),
      observedAt: Value(observedAt),
      createdAt: Value(createdAt),
    );
  }

  factory PriceObservation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PriceObservation(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String?>(json['productId']),
      storeName: serializer.fromJson<String?>(json['storeName']),
      packageQuantity: serializer.fromJson<double>(json['packageQuantity']),
      packageUnit: serializer.fromJson<String>(json['packageUnit']),
      price: serializer.fromJson<double>(json['price']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      observedAt: serializer.fromJson<DateTime>(json['observedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String?>(productId),
      'storeName': serializer.toJson<String?>(storeName),
      'packageQuantity': serializer.toJson<double>(packageQuantity),
      'packageUnit': serializer.toJson<String>(packageUnit),
      'price': serializer.toJson<double>(price),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'observedAt': serializer.toJson<DateTime>(observedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PriceObservation copyWith(
          {String? id,
          Value<String?> productId = const Value.absent(),
          Value<String?> storeName = const Value.absent(),
          double? packageQuantity,
          String? packageUnit,
          double? price,
          double? unitPrice,
          DateTime? observedAt,
          DateTime? createdAt}) =>
      PriceObservation(
        id: id ?? this.id,
        productId: productId.present ? productId.value : this.productId,
        storeName: storeName.present ? storeName.value : this.storeName,
        packageQuantity: packageQuantity ?? this.packageQuantity,
        packageUnit: packageUnit ?? this.packageUnit,
        price: price ?? this.price,
        unitPrice: unitPrice ?? this.unitPrice,
        observedAt: observedAt ?? this.observedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  PriceObservation copyWithCompanion(PriceObservationsCompanion data) {
    return PriceObservation(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      storeName: data.storeName.present ? data.storeName.value : this.storeName,
      packageQuantity: data.packageQuantity.present
          ? data.packageQuantity.value
          : this.packageQuantity,
      packageUnit:
          data.packageUnit.present ? data.packageUnit.value : this.packageUnit,
      price: data.price.present ? data.price.value : this.price,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      observedAt:
          data.observedAt.present ? data.observedAt.value : this.observedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PriceObservation(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('storeName: $storeName, ')
          ..write('packageQuantity: $packageQuantity, ')
          ..write('packageUnit: $packageUnit, ')
          ..write('price: $price, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('observedAt: $observedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, storeName, packageQuantity,
      packageUnit, price, unitPrice, observedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PriceObservation &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.storeName == this.storeName &&
          other.packageQuantity == this.packageQuantity &&
          other.packageUnit == this.packageUnit &&
          other.price == this.price &&
          other.unitPrice == this.unitPrice &&
          other.observedAt == this.observedAt &&
          other.createdAt == this.createdAt);
}

class PriceObservationsCompanion extends UpdateCompanion<PriceObservation> {
  final Value<String> id;
  final Value<String?> productId;
  final Value<String?> storeName;
  final Value<double> packageQuantity;
  final Value<String> packageUnit;
  final Value<double> price;
  final Value<double> unitPrice;
  final Value<DateTime> observedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PriceObservationsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.storeName = const Value.absent(),
    this.packageQuantity = const Value.absent(),
    this.packageUnit = const Value.absent(),
    this.price = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.observedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PriceObservationsCompanion.insert({
    required String id,
    this.productId = const Value.absent(),
    this.storeName = const Value.absent(),
    required double packageQuantity,
    this.packageUnit = const Value.absent(),
    required double price,
    required double unitPrice,
    required DateTime observedAt,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        packageQuantity = Value(packageQuantity),
        price = Value(price),
        unitPrice = Value(unitPrice),
        observedAt = Value(observedAt);
  static Insertable<PriceObservation> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? storeName,
    Expression<double>? packageQuantity,
    Expression<String>? packageUnit,
    Expression<double>? price,
    Expression<double>? unitPrice,
    Expression<DateTime>? observedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (storeName != null) 'store_name': storeName,
      if (packageQuantity != null) 'package_quantity': packageQuantity,
      if (packageUnit != null) 'package_unit': packageUnit,
      if (price != null) 'price': price,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (observedAt != null) 'observed_at': observedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PriceObservationsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? productId,
      Value<String?>? storeName,
      Value<double>? packageQuantity,
      Value<String>? packageUnit,
      Value<double>? price,
      Value<double>? unitPrice,
      Value<DateTime>? observedAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return PriceObservationsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      storeName: storeName ?? this.storeName,
      packageQuantity: packageQuantity ?? this.packageQuantity,
      packageUnit: packageUnit ?? this.packageUnit,
      price: price ?? this.price,
      unitPrice: unitPrice ?? this.unitPrice,
      observedAt: observedAt ?? this.observedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (storeName.present) {
      map['store_name'] = Variable<String>(storeName.value);
    }
    if (packageQuantity.present) {
      map['package_quantity'] = Variable<double>(packageQuantity.value);
    }
    if (packageUnit.present) {
      map['package_unit'] = Variable<String>(packageUnit.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (observedAt.present) {
      map['observed_at'] = Variable<DateTime>(observedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PriceObservationsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('storeName: $storeName, ')
          ..write('packageQuantity: $packageQuantity, ')
          ..write('packageUnit: $packageUnit, ')
          ..write('price: $price, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('observedAt: $observedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $ProductAliasesTable productAliases = $ProductAliasesTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $InventoriesTable inventories = $InventoriesTable(this);
  late final $InventoryCategoriesTable inventoryCategories =
      $InventoryCategoriesTable(this);
  late final $InventoryItemsTable inventoryItems = $InventoryItemsTable(this);
  late final $ShoppingListsTable shoppingLists = $ShoppingListsTable(this);
  late final $ShoppingListInventoryLinksTable shoppingListInventoryLinks =
      $ShoppingListInventoryLinksTable(this);
  late final $ShoppingListCategoriesTable shoppingListCategories =
      $ShoppingListCategoriesTable(this);
  late final $ShoppingListItemsTable shoppingListItems =
      $ShoppingListItemsTable(this);
  late final $InventoryEventsTable inventoryEvents =
      $InventoryEventsTable(this);
  late final $PriceObservationsTable priceObservations =
      $PriceObservationsTable(this);
  late final ProductsDao productsDao = ProductsDao(this as AppDatabase);
  late final ShoppingListsDao shoppingListsDao =
      ShoppingListsDao(this as AppDatabase);
  late final PantryDao pantryDao = PantryDao(this as AppDatabase);
  late final PriceObservationsDao priceObservationsDao =
      PriceObservationsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        products,
        productAliases,
        categories,
        inventories,
        inventoryCategories,
        inventoryItems,
        shoppingLists,
        shoppingListInventoryLinks,
        shoppingListCategories,
        shoppingListItems,
        inventoryEvents,
        priceObservations
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('inventories',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('inventory_categories', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('categories',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('inventory_categories', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('shopping_lists',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('shopping_list_inventory_links',
                  kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('inventories',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('shopping_list_inventory_links',
                  kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('shopping_lists',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('shopping_list_categories', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('categories',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('shopping_list_categories', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  required String id,
  required String canonicalName,
  Value<String?> brand,
  Value<String> category,
  Value<String> defaultUnit,
  Value<double?> defaultPackageQuantity,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> syncStatus,
  Value<int> version,
  Value<int> rowid,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<String> id,
  Value<String> canonicalName,
  Value<String?> brand,
  Value<String> category,
  Value<String> defaultUnit,
  Value<double?> defaultPackageQuantity,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> syncStatus,
  Value<int> version,
  Value<int> rowid,
});

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductAliasesTable, List<ProductAliase>>
      _productAliasesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.productAliases,
              aliasName: $_aliasNameGenerator(
                  db.products.id, db.productAliases.productId));

  $$ProductAliasesTableProcessedTableManager get productAliasesRefs {
    final manager = $$ProductAliasesTableTableManager($_db, $_db.productAliases)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_productAliasesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$InventoryItemsTable, List<InventoryItem>>
      _inventoryItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.inventoryItems,
              aliasName: $_aliasNameGenerator(
                  db.products.id, db.inventoryItems.productId));

  $$InventoryItemsTableProcessedTableManager get inventoryItemsRefs {
    final manager = $$InventoryItemsTableTableManager($_db, $_db.inventoryItems)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_inventoryItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ShoppingListItemsTable, List<ShoppingListItem>>
      _shoppingListItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.shoppingListItems,
              aliasName: $_aliasNameGenerator(
                  db.products.id, db.shoppingListItems.productId));

  $$ShoppingListItemsTableProcessedTableManager get shoppingListItemsRefs {
    final manager = $$ShoppingListItemsTableTableManager(
            $_db, $_db.shoppingListItems)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_shoppingListItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$InventoryEventsTable, List<InventoryEvent>>
      _inventoryEventsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.inventoryEvents,
              aliasName: $_aliasNameGenerator(
                  db.products.id, db.inventoryEvents.productId));

  $$InventoryEventsTableProcessedTableManager get inventoryEventsRefs {
    final manager = $$InventoryEventsTableTableManager(
            $_db, $_db.inventoryEvents)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_inventoryEventsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PriceObservationsTable, List<PriceObservation>>
      _priceObservationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.priceObservations,
              aliasName: $_aliasNameGenerator(
                  db.products.id, db.priceObservations.productId));

  $$PriceObservationsTableProcessedTableManager get priceObservationsRefs {
    final manager = $$PriceObservationsTableTableManager(
            $_db, $_db.priceObservations)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_priceObservationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get canonicalName => $composableBuilder(
      column: $table.canonicalName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultUnit => $composableBuilder(
      column: $table.defaultUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get defaultPackageQuantity => $composableBuilder(
      column: $table.defaultPackageQuantity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  Expression<bool> productAliasesRefs(
      Expression<bool> Function($$ProductAliasesTableFilterComposer f) f) {
    final $$ProductAliasesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productAliases,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductAliasesTableFilterComposer(
              $db: $db,
              $table: $db.productAliases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> inventoryItemsRefs(
      Expression<bool> Function($$InventoryItemsTableFilterComposer f) f) {
    final $$InventoryItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryItemsTableFilterComposer(
              $db: $db,
              $table: $db.inventoryItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> shoppingListItemsRefs(
      Expression<bool> Function($$ShoppingListItemsTableFilterComposer f) f) {
    final $$ShoppingListItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shoppingListItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListItemsTableFilterComposer(
              $db: $db,
              $table: $db.shoppingListItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> inventoryEventsRefs(
      Expression<bool> Function($$InventoryEventsTableFilterComposer f) f) {
    final $$InventoryEventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryEvents,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryEventsTableFilterComposer(
              $db: $db,
              $table: $db.inventoryEvents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> priceObservationsRefs(
      Expression<bool> Function($$PriceObservationsTableFilterComposer f) f) {
    final $$PriceObservationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.priceObservations,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PriceObservationsTableFilterComposer(
              $db: $db,
              $table: $db.priceObservations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get canonicalName => $composableBuilder(
      column: $table.canonicalName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultUnit => $composableBuilder(
      column: $table.defaultUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get defaultPackageQuantity => $composableBuilder(
      column: $table.defaultPackageQuantity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get canonicalName => $composableBuilder(
      column: $table.canonicalName, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get defaultUnit => $composableBuilder(
      column: $table.defaultUnit, builder: (column) => column);

  GeneratedColumn<double> get defaultPackageQuantity => $composableBuilder(
      column: $table.defaultPackageQuantity, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  Expression<T> productAliasesRefs<T extends Object>(
      Expression<T> Function($$ProductAliasesTableAnnotationComposer a) f) {
    final $$ProductAliasesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productAliases,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductAliasesTableAnnotationComposer(
              $db: $db,
              $table: $db.productAliases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> inventoryItemsRefs<T extends Object>(
      Expression<T> Function($$InventoryItemsTableAnnotationComposer a) f) {
    final $$InventoryItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.inventoryItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> shoppingListItemsRefs<T extends Object>(
      Expression<T> Function($$ShoppingListItemsTableAnnotationComposer a) f) {
    final $$ShoppingListItemsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.shoppingListItems,
            getReferencedColumn: (t) => t.productId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingListItemsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.shoppingListItems,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> inventoryEventsRefs<T extends Object>(
      Expression<T> Function($$InventoryEventsTableAnnotationComposer a) f) {
    final $$InventoryEventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryEvents,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryEventsTableAnnotationComposer(
              $db: $db,
              $table: $db.inventoryEvents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> priceObservationsRefs<T extends Object>(
      Expression<T> Function($$PriceObservationsTableAnnotationComposer a) f) {
    final $$PriceObservationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.priceObservations,
            getReferencedColumn: (t) => t.productId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PriceObservationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.priceObservations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, $$ProductsTableReferences),
    Product,
    PrefetchHooks Function(
        {bool productAliasesRefs,
        bool inventoryItemsRefs,
        bool shoppingListItemsRefs,
        bool inventoryEventsRefs,
        bool priceObservationsRefs})> {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> canonicalName = const Value.absent(),
            Value<String?> brand = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> defaultUnit = const Value.absent(),
            Value<double?> defaultPackageQuantity = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            canonicalName: canonicalName,
            brand: brand,
            category: category,
            defaultUnit: defaultUnit,
            defaultPackageQuantity: defaultPackageQuantity,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            syncStatus: syncStatus,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String canonicalName,
            Value<String?> brand = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> defaultUnit = const Value.absent(),
            Value<double?> defaultPackageQuantity = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductsCompanion.insert(
            id: id,
            canonicalName: canonicalName,
            brand: brand,
            category: category,
            defaultUnit: defaultUnit,
            defaultPackageQuantity: defaultPackageQuantity,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            syncStatus: syncStatus,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProductsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {productAliasesRefs = false,
              inventoryItemsRefs = false,
              shoppingListItemsRefs = false,
              inventoryEventsRefs = false,
              priceObservationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productAliasesRefs) db.productAliases,
                if (inventoryItemsRefs) db.inventoryItems,
                if (shoppingListItemsRefs) db.shoppingListItems,
                if (inventoryEventsRefs) db.inventoryEvents,
                if (priceObservationsRefs) db.priceObservations
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productAliasesRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            ProductAliase>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._productAliasesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .productAliasesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items),
                  if (inventoryItemsRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            InventoryItem>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._inventoryItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .inventoryItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items),
                  if (shoppingListItemsRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            ShoppingListItem>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._shoppingListItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .shoppingListItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items),
                  if (inventoryEventsRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            InventoryEvent>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._inventoryEventsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .inventoryEventsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items),
                  if (priceObservationsRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            PriceObservation>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._priceObservationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .priceObservationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, $$ProductsTableReferences),
    Product,
    PrefetchHooks Function(
        {bool productAliasesRefs,
        bool inventoryItemsRefs,
        bool shoppingListItemsRefs,
        bool inventoryEventsRefs,
        bool priceObservationsRefs})>;
typedef $$ProductAliasesTableCreateCompanionBuilder = ProductAliasesCompanion
    Function({
  required String id,
  required String productId,
  required String alias,
  required String languageCode,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$ProductAliasesTableUpdateCompanionBuilder = ProductAliasesCompanion
    Function({
  Value<String> id,
  Value<String> productId,
  Value<String> alias,
  Value<String> languageCode,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ProductAliasesTableReferences
    extends BaseReferences<_$AppDatabase, $ProductAliasesTable, ProductAliase> {
  $$ProductAliasesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
          $_aliasNameGenerator(db.productAliases.productId, db.products.id));

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ProductAliasesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductAliasesTable> {
  $$ProductAliasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get languageCode => $composableBuilder(
      column: $table.languageCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductAliasesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductAliasesTable> {
  $$ProductAliasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get languageCode => $composableBuilder(
      column: $table.languageCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductAliasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductAliasesTable> {
  $$ProductAliasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<String> get languageCode => $composableBuilder(
      column: $table.languageCode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductAliasesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductAliasesTable,
    ProductAliase,
    $$ProductAliasesTableFilterComposer,
    $$ProductAliasesTableOrderingComposer,
    $$ProductAliasesTableAnnotationComposer,
    $$ProductAliasesTableCreateCompanionBuilder,
    $$ProductAliasesTableUpdateCompanionBuilder,
    (ProductAliase, $$ProductAliasesTableReferences),
    ProductAliase,
    PrefetchHooks Function({bool productId})> {
  $$ProductAliasesTableTableManager(
      _$AppDatabase db, $ProductAliasesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductAliasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductAliasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductAliasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String> alias = const Value.absent(),
            Value<String> languageCode = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductAliasesCompanion(
            id: id,
            productId: productId,
            alias: alias,
            languageCode: languageCode,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String productId,
            required String alias,
            required String languageCode,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductAliasesCompanion.insert(
            id: id,
            productId: productId,
            alias: alias,
            languageCode: languageCode,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProductAliasesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$ProductAliasesTableReferences._productIdTable(db),
                    referencedColumn:
                        $$ProductAliasesTableReferences._productIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ProductAliasesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductAliasesTable,
    ProductAliase,
    $$ProductAliasesTableFilterComposer,
    $$ProductAliasesTableOrderingComposer,
    $$ProductAliasesTableAnnotationComposer,
    $$ProductAliasesTableCreateCompanionBuilder,
    $$ProductAliasesTableUpdateCompanionBuilder,
    (ProductAliase, $$ProductAliasesTableReferences),
    ProductAliase,
    PrefetchHooks Function({bool productId})>;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  required String name,
  Value<String?> color,
  Value<String?> icon,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> syncStatus,
  Value<int> version,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> color,
  Value<String?> icon,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> syncStatus,
  Value<int> version,
  Value<int> rowid,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InventoryCategoriesTable, List<InventoryCategory>>
      _inventoryCategoriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.inventoryCategories,
              aliasName: $_aliasNameGenerator(
                  db.categories.id, db.inventoryCategories.categoryId));

  $$InventoryCategoriesTableProcessedTableManager get inventoryCategoriesRefs {
    final manager = $$InventoryCategoriesTableTableManager(
            $_db, $_db.inventoryCategories)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_inventoryCategoriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ShoppingListCategoriesTable,
      List<ShoppingListCategory>> _shoppingListCategoriesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.shoppingListCategories,
          aliasName: $_aliasNameGenerator(
              db.categories.id, db.shoppingListCategories.categoryId));

  $$ShoppingListCategoriesTableProcessedTableManager
      get shoppingListCategoriesRefs {
    final manager = $$ShoppingListCategoriesTableTableManager(
            $_db, $_db.shoppingListCategories)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_shoppingListCategoriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ShoppingListItemsTable, List<ShoppingListItem>>
      _shoppingListItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.shoppingListItems,
              aliasName: $_aliasNameGenerator(
                  db.categories.id, db.shoppingListItems.categoryId));

  $$ShoppingListItemsTableProcessedTableManager get shoppingListItemsRefs {
    final manager = $$ShoppingListItemsTableTableManager(
            $_db, $_db.shoppingListItems)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_shoppingListItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  Expression<bool> inventoryCategoriesRefs(
      Expression<bool> Function($$InventoryCategoriesTableFilterComposer f) f) {
    final $$InventoryCategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryCategories,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryCategoriesTableFilterComposer(
              $db: $db,
              $table: $db.inventoryCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> shoppingListCategoriesRefs(
      Expression<bool> Function($$ShoppingListCategoriesTableFilterComposer f)
          f) {
    final $$ShoppingListCategoriesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.shoppingListCategories,
            getReferencedColumn: (t) => t.categoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingListCategoriesTableFilterComposer(
                  $db: $db,
                  $table: $db.shoppingListCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> shoppingListItemsRefs(
      Expression<bool> Function($$ShoppingListItemsTableFilterComposer f) f) {
    final $$ShoppingListItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shoppingListItems,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListItemsTableFilterComposer(
              $db: $db,
              $table: $db.shoppingListItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  Expression<T> inventoryCategoriesRefs<T extends Object>(
      Expression<T> Function($$InventoryCategoriesTableAnnotationComposer a)
          f) {
    final $$InventoryCategoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.inventoryCategories,
            getReferencedColumn: (t) => t.categoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$InventoryCategoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.inventoryCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> shoppingListCategoriesRefs<T extends Object>(
      Expression<T> Function($$ShoppingListCategoriesTableAnnotationComposer a)
          f) {
    final $$ShoppingListCategoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.shoppingListCategories,
            getReferencedColumn: (t) => t.categoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingListCategoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.shoppingListCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> shoppingListItemsRefs<T extends Object>(
      Expression<T> Function($$ShoppingListItemsTableAnnotationComposer a) f) {
    final $$ShoppingListItemsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.shoppingListItems,
            getReferencedColumn: (t) => t.categoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingListItemsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.shoppingListItems,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function(
        {bool inventoryCategoriesRefs,
        bool shoppingListCategoriesRefs,
        bool shoppingListItemsRefs})> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            name: name,
            color: color,
            icon: icon,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            syncStatus: syncStatus,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> color = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            name: name,
            color: color,
            icon: icon,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            syncStatus: syncStatus,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {inventoryCategoriesRefs = false,
              shoppingListCategoriesRefs = false,
              shoppingListItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (inventoryCategoriesRefs) db.inventoryCategories,
                if (shoppingListCategoriesRefs) db.shoppingListCategories,
                if (shoppingListItemsRefs) db.shoppingListItems
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (inventoryCategoriesRefs)
                    await $_getPrefetchedData<Category, $CategoriesTable,
                            InventoryCategory>(
                        currentTable: table,
                        referencedTable: $$CategoriesTableReferences
                            ._inventoryCategoriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .inventoryCategoriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items),
                  if (shoppingListCategoriesRefs)
                    await $_getPrefetchedData<Category, $CategoriesTable,
                            ShoppingListCategory>(
                        currentTable: table,
                        referencedTable: $$CategoriesTableReferences
                            ._shoppingListCategoriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .shoppingListCategoriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items),
                  if (shoppingListItemsRefs)
                    await $_getPrefetchedData<Category, $CategoriesTable,
                            ShoppingListItem>(
                        currentTable: table,
                        referencedTable: $$CategoriesTableReferences
                            ._shoppingListItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .shoppingListItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function(
        {bool inventoryCategoriesRefs,
        bool shoppingListCategoriesRefs,
        bool shoppingListItemsRefs})>;
typedef $$InventoriesTableCreateCompanionBuilder = InventoriesCompanion
    Function({
  required String id,
  required String name,
  Value<String?> description,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> syncStatus,
  Value<int> version,
  Value<int> rowid,
});
typedef $$InventoriesTableUpdateCompanionBuilder = InventoriesCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> syncStatus,
  Value<int> version,
  Value<int> rowid,
});

final class $$InventoriesTableReferences
    extends BaseReferences<_$AppDatabase, $InventoriesTable, Inventory> {
  $$InventoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InventoryCategoriesTable, List<InventoryCategory>>
      _inventoryCategoriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.inventoryCategories,
              aliasName: $_aliasNameGenerator(
                  db.inventories.id, db.inventoryCategories.inventoryId));

  $$InventoryCategoriesTableProcessedTableManager get inventoryCategoriesRefs {
    final manager = $$InventoryCategoriesTableTableManager(
            $_db, $_db.inventoryCategories)
        .filter((f) => f.inventoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_inventoryCategoriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$InventoryItemsTable, List<InventoryItem>>
      _inventoryItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.inventoryItems,
              aliasName: $_aliasNameGenerator(
                  db.inventories.id, db.inventoryItems.inventoryId));

  $$InventoryItemsTableProcessedTableManager get inventoryItemsRefs {
    final manager = $$InventoryItemsTableTableManager($_db, $_db.inventoryItems)
        .filter((f) => f.inventoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_inventoryItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ShoppingListsTable, List<ShoppingList>>
      _shoppingListsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.shoppingLists,
              aliasName: $_aliasNameGenerator(
                  db.inventories.id, db.shoppingLists.inventoryId));

  $$ShoppingListsTableProcessedTableManager get shoppingListsRefs {
    final manager = $$ShoppingListsTableTableManager($_db, $_db.shoppingLists)
        .filter((f) => f.inventoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_shoppingListsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ShoppingListInventoryLinksTable,
      List<ShoppingListInventoryLink>> _shoppingListInventoryLinksRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.shoppingListInventoryLinks,
          aliasName: $_aliasNameGenerator(
              db.inventories.id, db.shoppingListInventoryLinks.inventoryId));

  $$ShoppingListInventoryLinksTableProcessedTableManager
      get shoppingListInventoryLinksRefs {
    final manager = $$ShoppingListInventoryLinksTableTableManager(
            $_db, $_db.shoppingListInventoryLinks)
        .filter((f) => f.inventoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult
        .readTableOrNull(_shoppingListInventoryLinksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ShoppingListCategoriesTable,
      List<ShoppingListCategory>> _shoppingListCategoriesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.shoppingListCategories,
          aliasName: $_aliasNameGenerator(
              db.inventories.id, db.shoppingListCategories.targetInventoryId));

  $$ShoppingListCategoriesTableProcessedTableManager
      get shoppingListCategoriesRefs {
    final manager = $$ShoppingListCategoriesTableTableManager(
            $_db, $_db.shoppingListCategories)
        .filter((f) =>
            f.targetInventoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_shoppingListCategoriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ShoppingListItemsTable, List<ShoppingListItem>>
      _shoppingListItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.shoppingListItems,
              aliasName: $_aliasNameGenerator(
                  db.inventories.id, db.shoppingListItems.targetInventoryId));

  $$ShoppingListItemsTableProcessedTableManager get shoppingListItemsRefs {
    final manager =
        $$ShoppingListItemsTableTableManager($_db, $_db.shoppingListItems)
            .filter((f) =>
                f.targetInventoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_shoppingListItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$InventoryEventsTable, List<InventoryEvent>>
      _inventoryEventsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.inventoryEvents,
              aliasName: $_aliasNameGenerator(
                  db.inventories.id, db.inventoryEvents.inventoryId));

  $$InventoryEventsTableProcessedTableManager get inventoryEventsRefs {
    final manager = $$InventoryEventsTableTableManager(
            $_db, $_db.inventoryEvents)
        .filter((f) => f.inventoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_inventoryEventsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$InventoriesTableFilterComposer
    extends Composer<_$AppDatabase, $InventoriesTable> {
  $$InventoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  Expression<bool> inventoryCategoriesRefs(
      Expression<bool> Function($$InventoryCategoriesTableFilterComposer f) f) {
    final $$InventoryCategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryCategories,
        getReferencedColumn: (t) => t.inventoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryCategoriesTableFilterComposer(
              $db: $db,
              $table: $db.inventoryCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> inventoryItemsRefs(
      Expression<bool> Function($$InventoryItemsTableFilterComposer f) f) {
    final $$InventoryItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryItems,
        getReferencedColumn: (t) => t.inventoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryItemsTableFilterComposer(
              $db: $db,
              $table: $db.inventoryItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> shoppingListsRefs(
      Expression<bool> Function($$ShoppingListsTableFilterComposer f) f) {
    final $$ShoppingListsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shoppingLists,
        getReferencedColumn: (t) => t.inventoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListsTableFilterComposer(
              $db: $db,
              $table: $db.shoppingLists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> shoppingListInventoryLinksRefs(
      Expression<bool> Function(
              $$ShoppingListInventoryLinksTableFilterComposer f)
          f) {
    final $$ShoppingListInventoryLinksTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.shoppingListInventoryLinks,
            getReferencedColumn: (t) => t.inventoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingListInventoryLinksTableFilterComposer(
                  $db: $db,
                  $table: $db.shoppingListInventoryLinks,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> shoppingListCategoriesRefs(
      Expression<bool> Function($$ShoppingListCategoriesTableFilterComposer f)
          f) {
    final $$ShoppingListCategoriesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.shoppingListCategories,
            getReferencedColumn: (t) => t.targetInventoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingListCategoriesTableFilterComposer(
                  $db: $db,
                  $table: $db.shoppingListCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> shoppingListItemsRefs(
      Expression<bool> Function($$ShoppingListItemsTableFilterComposer f) f) {
    final $$ShoppingListItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shoppingListItems,
        getReferencedColumn: (t) => t.targetInventoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListItemsTableFilterComposer(
              $db: $db,
              $table: $db.shoppingListItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> inventoryEventsRefs(
      Expression<bool> Function($$InventoryEventsTableFilterComposer f) f) {
    final $$InventoryEventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryEvents,
        getReferencedColumn: (t) => t.inventoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryEventsTableFilterComposer(
              $db: $db,
              $table: $db.inventoryEvents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InventoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoriesTable> {
  $$InventoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$InventoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoriesTable> {
  $$InventoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  Expression<T> inventoryCategoriesRefs<T extends Object>(
      Expression<T> Function($$InventoryCategoriesTableAnnotationComposer a)
          f) {
    final $$InventoryCategoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.inventoryCategories,
            getReferencedColumn: (t) => t.inventoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$InventoryCategoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.inventoryCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> inventoryItemsRefs<T extends Object>(
      Expression<T> Function($$InventoryItemsTableAnnotationComposer a) f) {
    final $$InventoryItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryItems,
        getReferencedColumn: (t) => t.inventoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.inventoryItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> shoppingListsRefs<T extends Object>(
      Expression<T> Function($$ShoppingListsTableAnnotationComposer a) f) {
    final $$ShoppingListsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shoppingLists,
        getReferencedColumn: (t) => t.inventoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListsTableAnnotationComposer(
              $db: $db,
              $table: $db.shoppingLists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> shoppingListInventoryLinksRefs<T extends Object>(
      Expression<T> Function(
              $$ShoppingListInventoryLinksTableAnnotationComposer a)
          f) {
    final $$ShoppingListInventoryLinksTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.shoppingListInventoryLinks,
            getReferencedColumn: (t) => t.inventoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingListInventoryLinksTableAnnotationComposer(
                  $db: $db,
                  $table: $db.shoppingListInventoryLinks,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> shoppingListCategoriesRefs<T extends Object>(
      Expression<T> Function($$ShoppingListCategoriesTableAnnotationComposer a)
          f) {
    final $$ShoppingListCategoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.shoppingListCategories,
            getReferencedColumn: (t) => t.targetInventoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingListCategoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.shoppingListCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> shoppingListItemsRefs<T extends Object>(
      Expression<T> Function($$ShoppingListItemsTableAnnotationComposer a) f) {
    final $$ShoppingListItemsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.shoppingListItems,
            getReferencedColumn: (t) => t.targetInventoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingListItemsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.shoppingListItems,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> inventoryEventsRefs<T extends Object>(
      Expression<T> Function($$InventoryEventsTableAnnotationComposer a) f) {
    final $$InventoryEventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryEvents,
        getReferencedColumn: (t) => t.inventoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryEventsTableAnnotationComposer(
              $db: $db,
              $table: $db.inventoryEvents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InventoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InventoriesTable,
    Inventory,
    $$InventoriesTableFilterComposer,
    $$InventoriesTableOrderingComposer,
    $$InventoriesTableAnnotationComposer,
    $$InventoriesTableCreateCompanionBuilder,
    $$InventoriesTableUpdateCompanionBuilder,
    (Inventory, $$InventoriesTableReferences),
    Inventory,
    PrefetchHooks Function(
        {bool inventoryCategoriesRefs,
        bool inventoryItemsRefs,
        bool shoppingListsRefs,
        bool shoppingListInventoryLinksRefs,
        bool shoppingListCategoriesRefs,
        bool shoppingListItemsRefs,
        bool inventoryEventsRefs})> {
  $$InventoriesTableTableManager(_$AppDatabase db, $InventoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoriesCompanion(
            id: id,
            name: name,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            syncStatus: syncStatus,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoriesCompanion.insert(
            id: id,
            name: name,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            syncStatus: syncStatus,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$InventoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {inventoryCategoriesRefs = false,
              inventoryItemsRefs = false,
              shoppingListsRefs = false,
              shoppingListInventoryLinksRefs = false,
              shoppingListCategoriesRefs = false,
              shoppingListItemsRefs = false,
              inventoryEventsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (inventoryCategoriesRefs) db.inventoryCategories,
                if (inventoryItemsRefs) db.inventoryItems,
                if (shoppingListsRefs) db.shoppingLists,
                if (shoppingListInventoryLinksRefs)
                  db.shoppingListInventoryLinks,
                if (shoppingListCategoriesRefs) db.shoppingListCategories,
                if (shoppingListItemsRefs) db.shoppingListItems,
                if (inventoryEventsRefs) db.inventoryEvents
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (inventoryCategoriesRefs)
                    await $_getPrefetchedData<Inventory, $InventoriesTable,
                            InventoryCategory>(
                        currentTable: table,
                        referencedTable: $$InventoriesTableReferences
                            ._inventoryCategoriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InventoriesTableReferences(db, table, p0)
                                .inventoryCategoriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.inventoryId == item.id),
                        typedResults: items),
                  if (inventoryItemsRefs)
                    await $_getPrefetchedData<Inventory, $InventoriesTable,
                            InventoryItem>(
                        currentTable: table,
                        referencedTable: $$InventoriesTableReferences
                            ._inventoryItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InventoriesTableReferences(db, table, p0)
                                .inventoryItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.inventoryId == item.id),
                        typedResults: items),
                  if (shoppingListsRefs)
                    await $_getPrefetchedData<Inventory, $InventoriesTable,
                            ShoppingList>(
                        currentTable: table,
                        referencedTable: $$InventoriesTableReferences
                            ._shoppingListsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InventoriesTableReferences(db, table, p0)
                                .shoppingListsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.inventoryId == item.id),
                        typedResults: items),
                  if (shoppingListInventoryLinksRefs)
                    await $_getPrefetchedData<Inventory, $InventoriesTable,
                            ShoppingListInventoryLink>(
                        currentTable: table,
                        referencedTable: $$InventoriesTableReferences
                            ._shoppingListInventoryLinksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InventoriesTableReferences(db, table, p0)
                                .shoppingListInventoryLinksRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.inventoryId == item.id),
                        typedResults: items),
                  if (shoppingListCategoriesRefs)
                    await $_getPrefetchedData<Inventory, $InventoriesTable,
                            ShoppingListCategory>(
                        currentTable: table,
                        referencedTable: $$InventoriesTableReferences
                            ._shoppingListCategoriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InventoriesTableReferences(db, table, p0)
                                .shoppingListCategoriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.targetInventoryId == item.id),
                        typedResults: items),
                  if (shoppingListItemsRefs)
                    await $_getPrefetchedData<Inventory, $InventoriesTable,
                            ShoppingListItem>(
                        currentTable: table,
                        referencedTable: $$InventoriesTableReferences
                            ._shoppingListItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InventoriesTableReferences(db, table, p0)
                                .shoppingListItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.targetInventoryId == item.id),
                        typedResults: items),
                  if (inventoryEventsRefs)
                    await $_getPrefetchedData<Inventory, $InventoriesTable,
                            InventoryEvent>(
                        currentTable: table,
                        referencedTable: $$InventoriesTableReferences
                            ._inventoryEventsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InventoriesTableReferences(db, table, p0)
                                .inventoryEventsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.inventoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$InventoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InventoriesTable,
    Inventory,
    $$InventoriesTableFilterComposer,
    $$InventoriesTableOrderingComposer,
    $$InventoriesTableAnnotationComposer,
    $$InventoriesTableCreateCompanionBuilder,
    $$InventoriesTableUpdateCompanionBuilder,
    (Inventory, $$InventoriesTableReferences),
    Inventory,
    PrefetchHooks Function(
        {bool inventoryCategoriesRefs,
        bool inventoryItemsRefs,
        bool shoppingListsRefs,
        bool shoppingListInventoryLinksRefs,
        bool shoppingListCategoriesRefs,
        bool shoppingListItemsRefs,
        bool inventoryEventsRefs})>;
typedef $$InventoryCategoriesTableCreateCompanionBuilder
    = InventoryCategoriesCompanion Function({
  required String id,
  required String inventoryId,
  required String categoryId,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$InventoryCategoriesTableUpdateCompanionBuilder
    = InventoryCategoriesCompanion Function({
  Value<String> id,
  Value<String> inventoryId,
  Value<String> categoryId,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$InventoryCategoriesTableReferences extends BaseReferences<
    _$AppDatabase, $InventoryCategoriesTable, InventoryCategory> {
  $$InventoryCategoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $InventoriesTable _inventoryIdTable(_$AppDatabase db) =>
      db.inventories.createAlias($_aliasNameGenerator(
          db.inventoryCategories.inventoryId, db.inventories.id));

  $$InventoriesTableProcessedTableManager get inventoryId {
    final $_column = $_itemColumn<String>('inventory_id')!;

    final manager = $$InventoriesTableTableManager($_db, $_db.inventories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inventoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias($_aliasNameGenerator(
          db.inventoryCategories.categoryId, db.categories.id));

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$InventoryItemsTable, List<InventoryItem>>
      _inventoryItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.inventoryItems,
              aliasName: $_aliasNameGenerator(db.inventoryCategories.id,
                  db.inventoryItems.inventoryCategoryId));

  $$InventoryItemsTableProcessedTableManager get inventoryItemsRefs {
    final manager = $$InventoryItemsTableTableManager($_db, $_db.inventoryItems)
        .filter((f) =>
            f.inventoryCategoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_inventoryItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ShoppingListCategoriesTable,
      List<ShoppingListCategory>> _shoppingListCategoriesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.shoppingListCategories,
          aliasName: $_aliasNameGenerator(db.inventoryCategories.id,
              db.shoppingListCategories.targetInventoryCategoryId));

  $$ShoppingListCategoriesTableProcessedTableManager
      get shoppingListCategoriesRefs {
    final manager = $$ShoppingListCategoriesTableTableManager(
            $_db, $_db.shoppingListCategories)
        .filter((f) => f.targetInventoryCategoryId.id
            .sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_shoppingListCategoriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ShoppingListItemsTable, List<ShoppingListItem>>
      _shoppingListItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.shoppingListItems,
              aliasName: $_aliasNameGenerator(db.inventoryCategories.id,
                  db.shoppingListItems.targetInventoryCategoryId));

  $$ShoppingListItemsTableProcessedTableManager get shoppingListItemsRefs {
    final manager =
        $$ShoppingListItemsTableTableManager($_db, $_db.shoppingListItems)
            .filter((f) => f.targetInventoryCategoryId.id
                .sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_shoppingListItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$InventoryCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryCategoriesTable> {
  $$InventoryCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  $$InventoriesTableFilterComposer get inventoryId {
    final $$InventoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableFilterComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> inventoryItemsRefs(
      Expression<bool> Function($$InventoryItemsTableFilterComposer f) f) {
    final $$InventoryItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryItems,
        getReferencedColumn: (t) => t.inventoryCategoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryItemsTableFilterComposer(
              $db: $db,
              $table: $db.inventoryItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> shoppingListCategoriesRefs(
      Expression<bool> Function($$ShoppingListCategoriesTableFilterComposer f)
          f) {
    final $$ShoppingListCategoriesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.shoppingListCategories,
            getReferencedColumn: (t) => t.targetInventoryCategoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingListCategoriesTableFilterComposer(
                  $db: $db,
                  $table: $db.shoppingListCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> shoppingListItemsRefs(
      Expression<bool> Function($$ShoppingListItemsTableFilterComposer f) f) {
    final $$ShoppingListItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shoppingListItems,
        getReferencedColumn: (t) => t.targetInventoryCategoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListItemsTableFilterComposer(
              $db: $db,
              $table: $db.shoppingListItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InventoryCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryCategoriesTable> {
  $$InventoryCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  $$InventoriesTableOrderingComposer get inventoryId {
    final $$InventoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableOrderingComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InventoryCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryCategoriesTable> {
  $$InventoryCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$InventoriesTableAnnotationComposer get inventoryId {
    final $$InventoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> inventoryItemsRefs<T extends Object>(
      Expression<T> Function($$InventoryItemsTableAnnotationComposer a) f) {
    final $$InventoryItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryItems,
        getReferencedColumn: (t) => t.inventoryCategoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.inventoryItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> shoppingListCategoriesRefs<T extends Object>(
      Expression<T> Function($$ShoppingListCategoriesTableAnnotationComposer a)
          f) {
    final $$ShoppingListCategoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.shoppingListCategories,
            getReferencedColumn: (t) => t.targetInventoryCategoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingListCategoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.shoppingListCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> shoppingListItemsRefs<T extends Object>(
      Expression<T> Function($$ShoppingListItemsTableAnnotationComposer a) f) {
    final $$ShoppingListItemsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.shoppingListItems,
            getReferencedColumn: (t) => t.targetInventoryCategoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingListItemsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.shoppingListItems,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$InventoryCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InventoryCategoriesTable,
    InventoryCategory,
    $$InventoryCategoriesTableFilterComposer,
    $$InventoryCategoriesTableOrderingComposer,
    $$InventoryCategoriesTableAnnotationComposer,
    $$InventoryCategoriesTableCreateCompanionBuilder,
    $$InventoryCategoriesTableUpdateCompanionBuilder,
    (InventoryCategory, $$InventoryCategoriesTableReferences),
    InventoryCategory,
    PrefetchHooks Function(
        {bool inventoryId,
        bool categoryId,
        bool inventoryItemsRefs,
        bool shoppingListCategoriesRefs,
        bool shoppingListItemsRefs})> {
  $$InventoryCategoriesTableTableManager(
      _$AppDatabase db, $InventoryCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryCategoriesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryCategoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> inventoryId = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryCategoriesCompanion(
            id: id,
            inventoryId: inventoryId,
            categoryId: categoryId,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String inventoryId,
            required String categoryId,
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryCategoriesCompanion.insert(
            id: id,
            inventoryId: inventoryId,
            categoryId: categoryId,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$InventoryCategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {inventoryId = false,
              categoryId = false,
              inventoryItemsRefs = false,
              shoppingListCategoriesRefs = false,
              shoppingListItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (inventoryItemsRefs) db.inventoryItems,
                if (shoppingListCategoriesRefs) db.shoppingListCategories,
                if (shoppingListItemsRefs) db.shoppingListItems
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (inventoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.inventoryId,
                    referencedTable: $$InventoryCategoriesTableReferences
                        ._inventoryIdTable(db),
                    referencedColumn: $$InventoryCategoriesTableReferences
                        ._inventoryIdTable(db)
                        .id,
                  ) as T;
                }
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable: $$InventoryCategoriesTableReferences
                        ._categoryIdTable(db),
                    referencedColumn: $$InventoryCategoriesTableReferences
                        ._categoryIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (inventoryItemsRefs)
                    await $_getPrefetchedData<InventoryCategory,
                            $InventoryCategoriesTable, InventoryItem>(
                        currentTable: table,
                        referencedTable: $$InventoryCategoriesTableReferences
                            ._inventoryItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InventoryCategoriesTableReferences(db, table, p0)
                                .inventoryItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.inventoryCategoryId == item.id),
                        typedResults: items),
                  if (shoppingListCategoriesRefs)
                    await $_getPrefetchedData<InventoryCategory,
                            $InventoryCategoriesTable, ShoppingListCategory>(
                        currentTable: table,
                        referencedTable: $$InventoryCategoriesTableReferences
                            ._shoppingListCategoriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InventoryCategoriesTableReferences(db, table, p0)
                                .shoppingListCategoriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.targetInventoryCategoryId == item.id),
                        typedResults: items),
                  if (shoppingListItemsRefs)
                    await $_getPrefetchedData<InventoryCategory,
                            $InventoryCategoriesTable, ShoppingListItem>(
                        currentTable: table,
                        referencedTable: $$InventoryCategoriesTableReferences
                            ._shoppingListItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InventoryCategoriesTableReferences(db, table, p0)
                                .shoppingListItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.targetInventoryCategoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$InventoryCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InventoryCategoriesTable,
    InventoryCategory,
    $$InventoryCategoriesTableFilterComposer,
    $$InventoryCategoriesTableOrderingComposer,
    $$InventoryCategoriesTableAnnotationComposer,
    $$InventoryCategoriesTableCreateCompanionBuilder,
    $$InventoryCategoriesTableUpdateCompanionBuilder,
    (InventoryCategory, $$InventoryCategoriesTableReferences),
    InventoryCategory,
    PrefetchHooks Function(
        {bool inventoryId,
        bool categoryId,
        bool inventoryItemsRefs,
        bool shoppingListCategoriesRefs,
        bool shoppingListItemsRefs})>;
typedef $$InventoryItemsTableCreateCompanionBuilder = InventoryItemsCompanion
    Function({
  required String id,
  required String inventoryId,
  Value<String?> inventoryCategoryId,
  Value<String?> productId,
  Value<String?> rawName,
  Value<double?> quantityEstimated,
  Value<String?> unit,
  Value<String> status,
  Value<double> confidenceScore,
  Value<DateTime?> lastConfirmedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> syncStatus,
  Value<int> version,
  Value<int> rowid,
});
typedef $$InventoryItemsTableUpdateCompanionBuilder = InventoryItemsCompanion
    Function({
  Value<String> id,
  Value<String> inventoryId,
  Value<String?> inventoryCategoryId,
  Value<String?> productId,
  Value<String?> rawName,
  Value<double?> quantityEstimated,
  Value<String?> unit,
  Value<String> status,
  Value<double> confidenceScore,
  Value<DateTime?> lastConfirmedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> syncStatus,
  Value<int> version,
  Value<int> rowid,
});

final class $$InventoryItemsTableReferences
    extends BaseReferences<_$AppDatabase, $InventoryItemsTable, InventoryItem> {
  $$InventoryItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $InventoriesTable _inventoryIdTable(_$AppDatabase db) =>
      db.inventories.createAlias($_aliasNameGenerator(
          db.inventoryItems.inventoryId, db.inventories.id));

  $$InventoriesTableProcessedTableManager get inventoryId {
    final $_column = $_itemColumn<String>('inventory_id')!;

    final manager = $$InventoriesTableTableManager($_db, $_db.inventories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inventoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $InventoryCategoriesTable _inventoryCategoryIdTable(
          _$AppDatabase db) =>
      db.inventoryCategories.createAlias($_aliasNameGenerator(
          db.inventoryItems.inventoryCategoryId, db.inventoryCategories.id));

  $$InventoryCategoriesTableProcessedTableManager? get inventoryCategoryId {
    final $_column = $_itemColumn<String>('inventory_category_id');
    if ($_column == null) return null;
    final manager =
        $$InventoryCategoriesTableTableManager($_db, $_db.inventoryCategories)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inventoryCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
          $_aliasNameGenerator(db.inventoryItems.productId, db.products.id));

  $$ProductsTableProcessedTableManager? get productId {
    final $_column = $_itemColumn<String>('product_id');
    if ($_column == null) return null;
    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$InventoryEventsTable, List<InventoryEvent>>
      _inventoryEventsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.inventoryEvents,
              aliasName: $_aliasNameGenerator(
                  db.inventoryItems.id, db.inventoryEvents.inventoryItemId));

  $$InventoryEventsTableProcessedTableManager get inventoryEventsRefs {
    final manager =
        $$InventoryEventsTableTableManager($_db, $_db.inventoryEvents).filter(
            (f) => f.inventoryItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_inventoryEventsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$InventoryItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rawName => $composableBuilder(
      column: $table.rawName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantityEstimated => $composableBuilder(
      column: $table.quantityEstimated,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confidenceScore => $composableBuilder(
      column: $table.confidenceScore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastConfirmedAt => $composableBuilder(
      column: $table.lastConfirmedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  $$InventoriesTableFilterComposer get inventoryId {
    final $$InventoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableFilterComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoryCategoriesTableFilterComposer get inventoryCategoryId {
    final $$InventoryCategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryCategoryId,
        referencedTable: $db.inventoryCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryCategoriesTableFilterComposer(
              $db: $db,
              $table: $db.inventoryCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> inventoryEventsRefs(
      Expression<bool> Function($$InventoryEventsTableFilterComposer f) f) {
    final $$InventoryEventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryEvents,
        getReferencedColumn: (t) => t.inventoryItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryEventsTableFilterComposer(
              $db: $db,
              $table: $db.inventoryEvents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InventoryItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rawName => $composableBuilder(
      column: $table.rawName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantityEstimated => $composableBuilder(
      column: $table.quantityEstimated,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confidenceScore => $composableBuilder(
      column: $table.confidenceScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastConfirmedAt => $composableBuilder(
      column: $table.lastConfirmedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  $$InventoriesTableOrderingComposer get inventoryId {
    final $$InventoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableOrderingComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoryCategoriesTableOrderingComposer get inventoryCategoryId {
    final $$InventoryCategoriesTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.inventoryCategoryId,
            referencedTable: $db.inventoryCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$InventoryCategoriesTableOrderingComposer(
                  $db: $db,
                  $table: $db.inventoryCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InventoryItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rawName =>
      $composableBuilder(column: $table.rawName, builder: (column) => column);

  GeneratedColumn<double> get quantityEstimated => $composableBuilder(
      column: $table.quantityEstimated, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get confidenceScore => $composableBuilder(
      column: $table.confidenceScore, builder: (column) => column);

  GeneratedColumn<DateTime> get lastConfirmedAt => $composableBuilder(
      column: $table.lastConfirmedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  $$InventoriesTableAnnotationComposer get inventoryId {
    final $$InventoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoryCategoriesTableAnnotationComposer get inventoryCategoryId {
    final $$InventoryCategoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.inventoryCategoryId,
            referencedTable: $db.inventoryCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$InventoryCategoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.inventoryCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> inventoryEventsRefs<T extends Object>(
      Expression<T> Function($$InventoryEventsTableAnnotationComposer a) f) {
    final $$InventoryEventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryEvents,
        getReferencedColumn: (t) => t.inventoryItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryEventsTableAnnotationComposer(
              $db: $db,
              $table: $db.inventoryEvents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InventoryItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InventoryItemsTable,
    InventoryItem,
    $$InventoryItemsTableFilterComposer,
    $$InventoryItemsTableOrderingComposer,
    $$InventoryItemsTableAnnotationComposer,
    $$InventoryItemsTableCreateCompanionBuilder,
    $$InventoryItemsTableUpdateCompanionBuilder,
    (InventoryItem, $$InventoryItemsTableReferences),
    InventoryItem,
    PrefetchHooks Function(
        {bool inventoryId,
        bool inventoryCategoryId,
        bool productId,
        bool inventoryEventsRefs})> {
  $$InventoryItemsTableTableManager(
      _$AppDatabase db, $InventoryItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> inventoryId = const Value.absent(),
            Value<String?> inventoryCategoryId = const Value.absent(),
            Value<String?> productId = const Value.absent(),
            Value<String?> rawName = const Value.absent(),
            Value<double?> quantityEstimated = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> confidenceScore = const Value.absent(),
            Value<DateTime?> lastConfirmedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryItemsCompanion(
            id: id,
            inventoryId: inventoryId,
            inventoryCategoryId: inventoryCategoryId,
            productId: productId,
            rawName: rawName,
            quantityEstimated: quantityEstimated,
            unit: unit,
            status: status,
            confidenceScore: confidenceScore,
            lastConfirmedAt: lastConfirmedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            syncStatus: syncStatus,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String inventoryId,
            Value<String?> inventoryCategoryId = const Value.absent(),
            Value<String?> productId = const Value.absent(),
            Value<String?> rawName = const Value.absent(),
            Value<double?> quantityEstimated = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> confidenceScore = const Value.absent(),
            Value<DateTime?> lastConfirmedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryItemsCompanion.insert(
            id: id,
            inventoryId: inventoryId,
            inventoryCategoryId: inventoryCategoryId,
            productId: productId,
            rawName: rawName,
            quantityEstimated: quantityEstimated,
            unit: unit,
            status: status,
            confidenceScore: confidenceScore,
            lastConfirmedAt: lastConfirmedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            syncStatus: syncStatus,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$InventoryItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {inventoryId = false,
              inventoryCategoryId = false,
              productId = false,
              inventoryEventsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (inventoryEventsRefs) db.inventoryEvents
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (inventoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.inventoryId,
                    referencedTable:
                        $$InventoryItemsTableReferences._inventoryIdTable(db),
                    referencedColumn: $$InventoryItemsTableReferences
                        ._inventoryIdTable(db)
                        .id,
                  ) as T;
                }
                if (inventoryCategoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.inventoryCategoryId,
                    referencedTable: $$InventoryItemsTableReferences
                        ._inventoryCategoryIdTable(db),
                    referencedColumn: $$InventoryItemsTableReferences
                        ._inventoryCategoryIdTable(db)
                        .id,
                  ) as T;
                }
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$InventoryItemsTableReferences._productIdTable(db),
                    referencedColumn:
                        $$InventoryItemsTableReferences._productIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (inventoryEventsRefs)
                    await $_getPrefetchedData<InventoryItem,
                            $InventoryItemsTable, InventoryEvent>(
                        currentTable: table,
                        referencedTable: $$InventoryItemsTableReferences
                            ._inventoryEventsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InventoryItemsTableReferences(db, table, p0)
                                .inventoryEventsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.inventoryItemId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$InventoryItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InventoryItemsTable,
    InventoryItem,
    $$InventoryItemsTableFilterComposer,
    $$InventoryItemsTableOrderingComposer,
    $$InventoryItemsTableAnnotationComposer,
    $$InventoryItemsTableCreateCompanionBuilder,
    $$InventoryItemsTableUpdateCompanionBuilder,
    (InventoryItem, $$InventoryItemsTableReferences),
    InventoryItem,
    PrefetchHooks Function(
        {bool inventoryId,
        bool inventoryCategoryId,
        bool productId,
        bool inventoryEventsRefs})>;
typedef $$ShoppingListsTableCreateCompanionBuilder = ShoppingListsCompanion
    Function({
  required String id,
  Value<String?> inventoryId,
  required String name,
  Value<String> listType,
  Value<String> routingMode,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> syncStatus,
  Value<int> version,
  Value<int> rowid,
});
typedef $$ShoppingListsTableUpdateCompanionBuilder = ShoppingListsCompanion
    Function({
  Value<String> id,
  Value<String?> inventoryId,
  Value<String> name,
  Value<String> listType,
  Value<String> routingMode,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> syncStatus,
  Value<int> version,
  Value<int> rowid,
});

final class $$ShoppingListsTableReferences
    extends BaseReferences<_$AppDatabase, $ShoppingListsTable, ShoppingList> {
  $$ShoppingListsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $InventoriesTable _inventoryIdTable(_$AppDatabase db) =>
      db.inventories.createAlias($_aliasNameGenerator(
          db.shoppingLists.inventoryId, db.inventories.id));

  $$InventoriesTableProcessedTableManager? get inventoryId {
    final $_column = $_itemColumn<String>('inventory_id');
    if ($_column == null) return null;
    final manager = $$InventoriesTableTableManager($_db, $_db.inventories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inventoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ShoppingListInventoryLinksTable,
      List<ShoppingListInventoryLink>> _shoppingListInventoryLinksRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.shoppingListInventoryLinks,
          aliasName: $_aliasNameGenerator(db.shoppingLists.id,
              db.shoppingListInventoryLinks.shoppingListId));

  $$ShoppingListInventoryLinksTableProcessedTableManager
      get shoppingListInventoryLinksRefs {
    final manager = $$ShoppingListInventoryLinksTableTableManager(
            $_db, $_db.shoppingListInventoryLinks)
        .filter(
            (f) => f.shoppingListId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult
        .readTableOrNull(_shoppingListInventoryLinksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ShoppingListCategoriesTable,
      List<ShoppingListCategory>> _shoppingListCategoriesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.shoppingListCategories,
          aliasName: $_aliasNameGenerator(
              db.shoppingLists.id, db.shoppingListCategories.shoppingListId));

  $$ShoppingListCategoriesTableProcessedTableManager
      get shoppingListCategoriesRefs {
    final manager = $$ShoppingListCategoriesTableTableManager(
            $_db, $_db.shoppingListCategories)
        .filter(
            (f) => f.shoppingListId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_shoppingListCategoriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ShoppingListItemsTable, List<ShoppingListItem>>
      _shoppingListItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.shoppingListItems,
              aliasName: $_aliasNameGenerator(
                  db.shoppingLists.id, db.shoppingListItems.shoppingListId));

  $$ShoppingListItemsTableProcessedTableManager get shoppingListItemsRefs {
    final manager = $$ShoppingListItemsTableTableManager(
            $_db, $_db.shoppingListItems)
        .filter(
            (f) => f.shoppingListId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_shoppingListItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ShoppingListsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get listType => $composableBuilder(
      column: $table.listType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get routingMode => $composableBuilder(
      column: $table.routingMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  $$InventoriesTableFilterComposer get inventoryId {
    final $$InventoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableFilterComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> shoppingListInventoryLinksRefs(
      Expression<bool> Function(
              $$ShoppingListInventoryLinksTableFilterComposer f)
          f) {
    final $$ShoppingListInventoryLinksTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.shoppingListInventoryLinks,
            getReferencedColumn: (t) => t.shoppingListId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingListInventoryLinksTableFilterComposer(
                  $db: $db,
                  $table: $db.shoppingListInventoryLinks,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> shoppingListCategoriesRefs(
      Expression<bool> Function($$ShoppingListCategoriesTableFilterComposer f)
          f) {
    final $$ShoppingListCategoriesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.shoppingListCategories,
            getReferencedColumn: (t) => t.shoppingListId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingListCategoriesTableFilterComposer(
                  $db: $db,
                  $table: $db.shoppingListCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> shoppingListItemsRefs(
      Expression<bool> Function($$ShoppingListItemsTableFilterComposer f) f) {
    final $$ShoppingListItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shoppingListItems,
        getReferencedColumn: (t) => t.shoppingListId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListItemsTableFilterComposer(
              $db: $db,
              $table: $db.shoppingListItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ShoppingListsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get listType => $composableBuilder(
      column: $table.listType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get routingMode => $composableBuilder(
      column: $table.routingMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  $$InventoriesTableOrderingComposer get inventoryId {
    final $$InventoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableOrderingComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ShoppingListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get listType =>
      $composableBuilder(column: $table.listType, builder: (column) => column);

  GeneratedColumn<String> get routingMode => $composableBuilder(
      column: $table.routingMode, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  $$InventoriesTableAnnotationComposer get inventoryId {
    final $$InventoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> shoppingListInventoryLinksRefs<T extends Object>(
      Expression<T> Function(
              $$ShoppingListInventoryLinksTableAnnotationComposer a)
          f) {
    final $$ShoppingListInventoryLinksTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.shoppingListInventoryLinks,
            getReferencedColumn: (t) => t.shoppingListId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingListInventoryLinksTableAnnotationComposer(
                  $db: $db,
                  $table: $db.shoppingListInventoryLinks,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> shoppingListCategoriesRefs<T extends Object>(
      Expression<T> Function($$ShoppingListCategoriesTableAnnotationComposer a)
          f) {
    final $$ShoppingListCategoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.shoppingListCategories,
            getReferencedColumn: (t) => t.shoppingListId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingListCategoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.shoppingListCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> shoppingListItemsRefs<T extends Object>(
      Expression<T> Function($$ShoppingListItemsTableAnnotationComposer a) f) {
    final $$ShoppingListItemsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.shoppingListItems,
            getReferencedColumn: (t) => t.shoppingListId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingListItemsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.shoppingListItems,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ShoppingListsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShoppingListsTable,
    ShoppingList,
    $$ShoppingListsTableFilterComposer,
    $$ShoppingListsTableOrderingComposer,
    $$ShoppingListsTableAnnotationComposer,
    $$ShoppingListsTableCreateCompanionBuilder,
    $$ShoppingListsTableUpdateCompanionBuilder,
    (ShoppingList, $$ShoppingListsTableReferences),
    ShoppingList,
    PrefetchHooks Function(
        {bool inventoryId,
        bool shoppingListInventoryLinksRefs,
        bool shoppingListCategoriesRefs,
        bool shoppingListItemsRefs})> {
  $$ShoppingListsTableTableManager(_$AppDatabase db, $ShoppingListsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> inventoryId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> listType = const Value.absent(),
            Value<String> routingMode = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShoppingListsCompanion(
            id: id,
            inventoryId: inventoryId,
            name: name,
            listType: listType,
            routingMode: routingMode,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            syncStatus: syncStatus,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> inventoryId = const Value.absent(),
            required String name,
            Value<String> listType = const Value.absent(),
            Value<String> routingMode = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShoppingListsCompanion.insert(
            id: id,
            inventoryId: inventoryId,
            name: name,
            listType: listType,
            routingMode: routingMode,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            syncStatus: syncStatus,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ShoppingListsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {inventoryId = false,
              shoppingListInventoryLinksRefs = false,
              shoppingListCategoriesRefs = false,
              shoppingListItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (shoppingListInventoryLinksRefs)
                  db.shoppingListInventoryLinks,
                if (shoppingListCategoriesRefs) db.shoppingListCategories,
                if (shoppingListItemsRefs) db.shoppingListItems
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (inventoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.inventoryId,
                    referencedTable:
                        $$ShoppingListsTableReferences._inventoryIdTable(db),
                    referencedColumn:
                        $$ShoppingListsTableReferences._inventoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (shoppingListInventoryLinksRefs)
                    await $_getPrefetchedData<ShoppingList, $ShoppingListsTable,
                            ShoppingListInventoryLink>(
                        currentTable: table,
                        referencedTable: $$ShoppingListsTableReferences
                            ._shoppingListInventoryLinksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ShoppingListsTableReferences(db, table, p0)
                                .shoppingListInventoryLinksRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.shoppingListId == item.id),
                        typedResults: items),
                  if (shoppingListCategoriesRefs)
                    await $_getPrefetchedData<ShoppingList, $ShoppingListsTable,
                            ShoppingListCategory>(
                        currentTable: table,
                        referencedTable: $$ShoppingListsTableReferences
                            ._shoppingListCategoriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ShoppingListsTableReferences(db, table, p0)
                                .shoppingListCategoriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.shoppingListId == item.id),
                        typedResults: items),
                  if (shoppingListItemsRefs)
                    await $_getPrefetchedData<ShoppingList, $ShoppingListsTable,
                            ShoppingListItem>(
                        currentTable: table,
                        referencedTable: $$ShoppingListsTableReferences
                            ._shoppingListItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ShoppingListsTableReferences(db, table, p0)
                                .shoppingListItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.shoppingListId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ShoppingListsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ShoppingListsTable,
    ShoppingList,
    $$ShoppingListsTableFilterComposer,
    $$ShoppingListsTableOrderingComposer,
    $$ShoppingListsTableAnnotationComposer,
    $$ShoppingListsTableCreateCompanionBuilder,
    $$ShoppingListsTableUpdateCompanionBuilder,
    (ShoppingList, $$ShoppingListsTableReferences),
    ShoppingList,
    PrefetchHooks Function(
        {bool inventoryId,
        bool shoppingListInventoryLinksRefs,
        bool shoppingListCategoriesRefs,
        bool shoppingListItemsRefs})>;
typedef $$ShoppingListInventoryLinksTableCreateCompanionBuilder
    = ShoppingListInventoryLinksCompanion Function({
  required String id,
  required String shoppingListId,
  required String inventoryId,
  Value<DateTime> createdAt,
  Value<DateTime?> deletedAt,
  Value<String> syncStatus,
  Value<int> version,
  Value<int> rowid,
});
typedef $$ShoppingListInventoryLinksTableUpdateCompanionBuilder
    = ShoppingListInventoryLinksCompanion Function({
  Value<String> id,
  Value<String> shoppingListId,
  Value<String> inventoryId,
  Value<DateTime> createdAt,
  Value<DateTime?> deletedAt,
  Value<String> syncStatus,
  Value<int> version,
  Value<int> rowid,
});

final class $$ShoppingListInventoryLinksTableReferences extends BaseReferences<
    _$AppDatabase,
    $ShoppingListInventoryLinksTable,
    ShoppingListInventoryLink> {
  $$ShoppingListInventoryLinksTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ShoppingListsTable _shoppingListIdTable(_$AppDatabase db) =>
      db.shoppingLists.createAlias($_aliasNameGenerator(
          db.shoppingListInventoryLinks.shoppingListId, db.shoppingLists.id));

  $$ShoppingListsTableProcessedTableManager get shoppingListId {
    final $_column = $_itemColumn<String>('shopping_list_id')!;

    final manager = $$ShoppingListsTableTableManager($_db, $_db.shoppingLists)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shoppingListIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $InventoriesTable _inventoryIdTable(_$AppDatabase db) =>
      db.inventories.createAlias($_aliasNameGenerator(
          db.shoppingListInventoryLinks.inventoryId, db.inventories.id));

  $$InventoriesTableProcessedTableManager get inventoryId {
    final $_column = $_itemColumn<String>('inventory_id')!;

    final manager = $$InventoriesTableTableManager($_db, $_db.inventories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inventoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ShoppingListInventoryLinksTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingListInventoryLinksTable> {
  $$ShoppingListInventoryLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  $$ShoppingListsTableFilterComposer get shoppingListId {
    final $$ShoppingListsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shoppingListId,
        referencedTable: $db.shoppingLists,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListsTableFilterComposer(
              $db: $db,
              $table: $db.shoppingLists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoriesTableFilterComposer get inventoryId {
    final $$InventoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableFilterComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ShoppingListInventoryLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingListInventoryLinksTable> {
  $$ShoppingListInventoryLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  $$ShoppingListsTableOrderingComposer get shoppingListId {
    final $$ShoppingListsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shoppingListId,
        referencedTable: $db.shoppingLists,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListsTableOrderingComposer(
              $db: $db,
              $table: $db.shoppingLists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoriesTableOrderingComposer get inventoryId {
    final $$InventoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableOrderingComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ShoppingListInventoryLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingListInventoryLinksTable> {
  $$ShoppingListInventoryLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  $$ShoppingListsTableAnnotationComposer get shoppingListId {
    final $$ShoppingListsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shoppingListId,
        referencedTable: $db.shoppingLists,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListsTableAnnotationComposer(
              $db: $db,
              $table: $db.shoppingLists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoriesTableAnnotationComposer get inventoryId {
    final $$InventoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ShoppingListInventoryLinksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShoppingListInventoryLinksTable,
    ShoppingListInventoryLink,
    $$ShoppingListInventoryLinksTableFilterComposer,
    $$ShoppingListInventoryLinksTableOrderingComposer,
    $$ShoppingListInventoryLinksTableAnnotationComposer,
    $$ShoppingListInventoryLinksTableCreateCompanionBuilder,
    $$ShoppingListInventoryLinksTableUpdateCompanionBuilder,
    (ShoppingListInventoryLink, $$ShoppingListInventoryLinksTableReferences),
    ShoppingListInventoryLink,
    PrefetchHooks Function({bool shoppingListId, bool inventoryId})> {
  $$ShoppingListInventoryLinksTableTableManager(
      _$AppDatabase db, $ShoppingListInventoryLinksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingListInventoryLinksTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingListInventoryLinksTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingListInventoryLinksTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> shoppingListId = const Value.absent(),
            Value<String> inventoryId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShoppingListInventoryLinksCompanion(
            id: id,
            shoppingListId: shoppingListId,
            inventoryId: inventoryId,
            createdAt: createdAt,
            deletedAt: deletedAt,
            syncStatus: syncStatus,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String shoppingListId,
            required String inventoryId,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShoppingListInventoryLinksCompanion.insert(
            id: id,
            shoppingListId: shoppingListId,
            inventoryId: inventoryId,
            createdAt: createdAt,
            deletedAt: deletedAt,
            syncStatus: syncStatus,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ShoppingListInventoryLinksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {shoppingListId = false, inventoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (shoppingListId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.shoppingListId,
                    referencedTable: $$ShoppingListInventoryLinksTableReferences
                        ._shoppingListIdTable(db),
                    referencedColumn:
                        $$ShoppingListInventoryLinksTableReferences
                            ._shoppingListIdTable(db)
                            .id,
                  ) as T;
                }
                if (inventoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.inventoryId,
                    referencedTable: $$ShoppingListInventoryLinksTableReferences
                        ._inventoryIdTable(db),
                    referencedColumn:
                        $$ShoppingListInventoryLinksTableReferences
                            ._inventoryIdTable(db)
                            .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ShoppingListInventoryLinksTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ShoppingListInventoryLinksTable,
        ShoppingListInventoryLink,
        $$ShoppingListInventoryLinksTableFilterComposer,
        $$ShoppingListInventoryLinksTableOrderingComposer,
        $$ShoppingListInventoryLinksTableAnnotationComposer,
        $$ShoppingListInventoryLinksTableCreateCompanionBuilder,
        $$ShoppingListInventoryLinksTableUpdateCompanionBuilder,
        (
          ShoppingListInventoryLink,
          $$ShoppingListInventoryLinksTableReferences
        ),
        ShoppingListInventoryLink,
        PrefetchHooks Function({bool shoppingListId, bool inventoryId})>;
typedef $$ShoppingListCategoriesTableCreateCompanionBuilder
    = ShoppingListCategoriesCompanion Function({
  required String id,
  required String shoppingListId,
  required String categoryId,
  Value<String?> targetInventoryId,
  Value<String?> targetInventoryCategoryId,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$ShoppingListCategoriesTableUpdateCompanionBuilder
    = ShoppingListCategoriesCompanion Function({
  Value<String> id,
  Value<String> shoppingListId,
  Value<String> categoryId,
  Value<String?> targetInventoryId,
  Value<String?> targetInventoryCategoryId,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$ShoppingListCategoriesTableReferences extends BaseReferences<
    _$AppDatabase, $ShoppingListCategoriesTable, ShoppingListCategory> {
  $$ShoppingListCategoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ShoppingListsTable _shoppingListIdTable(_$AppDatabase db) =>
      db.shoppingLists.createAlias($_aliasNameGenerator(
          db.shoppingListCategories.shoppingListId, db.shoppingLists.id));

  $$ShoppingListsTableProcessedTableManager get shoppingListId {
    final $_column = $_itemColumn<String>('shopping_list_id')!;

    final manager = $$ShoppingListsTableTableManager($_db, $_db.shoppingLists)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shoppingListIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias($_aliasNameGenerator(
          db.shoppingListCategories.categoryId, db.categories.id));

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $InventoriesTable _targetInventoryIdTable(_$AppDatabase db) =>
      db.inventories.createAlias($_aliasNameGenerator(
          db.shoppingListCategories.targetInventoryId, db.inventories.id));

  $$InventoriesTableProcessedTableManager? get targetInventoryId {
    final $_column = $_itemColumn<String>('target_inventory_id');
    if ($_column == null) return null;
    final manager = $$InventoriesTableTableManager($_db, $_db.inventories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetInventoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $InventoryCategoriesTable _targetInventoryCategoryIdTable(
          _$AppDatabase db) =>
      db.inventoryCategories.createAlias($_aliasNameGenerator(
          db.shoppingListCategories.targetInventoryCategoryId,
          db.inventoryCategories.id));

  $$InventoryCategoriesTableProcessedTableManager?
      get targetInventoryCategoryId {
    final $_column = $_itemColumn<String>('target_inventory_category_id');
    if ($_column == null) return null;
    final manager =
        $$InventoryCategoriesTableTableManager($_db, $_db.inventoryCategories)
            .filter((f) => f.id.sqlEquals($_column));
    final item =
        $_typedResult.readTableOrNull(_targetInventoryCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ShoppingListCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingListCategoriesTable> {
  $$ShoppingListCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  $$ShoppingListsTableFilterComposer get shoppingListId {
    final $$ShoppingListsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shoppingListId,
        referencedTable: $db.shoppingLists,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListsTableFilterComposer(
              $db: $db,
              $table: $db.shoppingLists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoriesTableFilterComposer get targetInventoryId {
    final $$InventoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetInventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableFilterComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoryCategoriesTableFilterComposer get targetInventoryCategoryId {
    final $$InventoryCategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetInventoryCategoryId,
        referencedTable: $db.inventoryCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryCategoriesTableFilterComposer(
              $db: $db,
              $table: $db.inventoryCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ShoppingListCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingListCategoriesTable> {
  $$ShoppingListCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  $$ShoppingListsTableOrderingComposer get shoppingListId {
    final $$ShoppingListsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shoppingListId,
        referencedTable: $db.shoppingLists,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListsTableOrderingComposer(
              $db: $db,
              $table: $db.shoppingLists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoriesTableOrderingComposer get targetInventoryId {
    final $$InventoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetInventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableOrderingComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoryCategoriesTableOrderingComposer get targetInventoryCategoryId {
    final $$InventoryCategoriesTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.targetInventoryCategoryId,
            referencedTable: $db.inventoryCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$InventoryCategoriesTableOrderingComposer(
                  $db: $db,
                  $table: $db.inventoryCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ShoppingListCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingListCategoriesTable> {
  $$ShoppingListCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$ShoppingListsTableAnnotationComposer get shoppingListId {
    final $$ShoppingListsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shoppingListId,
        referencedTable: $db.shoppingLists,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListsTableAnnotationComposer(
              $db: $db,
              $table: $db.shoppingLists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoriesTableAnnotationComposer get targetInventoryId {
    final $$InventoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetInventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoryCategoriesTableAnnotationComposer get targetInventoryCategoryId {
    final $$InventoryCategoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.targetInventoryCategoryId,
            referencedTable: $db.inventoryCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$InventoryCategoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.inventoryCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ShoppingListCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShoppingListCategoriesTable,
    ShoppingListCategory,
    $$ShoppingListCategoriesTableFilterComposer,
    $$ShoppingListCategoriesTableOrderingComposer,
    $$ShoppingListCategoriesTableAnnotationComposer,
    $$ShoppingListCategoriesTableCreateCompanionBuilder,
    $$ShoppingListCategoriesTableUpdateCompanionBuilder,
    (ShoppingListCategory, $$ShoppingListCategoriesTableReferences),
    ShoppingListCategory,
    PrefetchHooks Function(
        {bool shoppingListId,
        bool categoryId,
        bool targetInventoryId,
        bool targetInventoryCategoryId})> {
  $$ShoppingListCategoriesTableTableManager(
      _$AppDatabase db, $ShoppingListCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingListCategoriesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingListCategoriesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingListCategoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> shoppingListId = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<String?> targetInventoryId = const Value.absent(),
            Value<String?> targetInventoryCategoryId = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShoppingListCategoriesCompanion(
            id: id,
            shoppingListId: shoppingListId,
            categoryId: categoryId,
            targetInventoryId: targetInventoryId,
            targetInventoryCategoryId: targetInventoryCategoryId,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String shoppingListId,
            required String categoryId,
            Value<String?> targetInventoryId = const Value.absent(),
            Value<String?> targetInventoryCategoryId = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShoppingListCategoriesCompanion.insert(
            id: id,
            shoppingListId: shoppingListId,
            categoryId: categoryId,
            targetInventoryId: targetInventoryId,
            targetInventoryCategoryId: targetInventoryCategoryId,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ShoppingListCategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {shoppingListId = false,
              categoryId = false,
              targetInventoryId = false,
              targetInventoryCategoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (shoppingListId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.shoppingListId,
                    referencedTable: $$ShoppingListCategoriesTableReferences
                        ._shoppingListIdTable(db),
                    referencedColumn: $$ShoppingListCategoriesTableReferences
                        ._shoppingListIdTable(db)
                        .id,
                  ) as T;
                }
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable: $$ShoppingListCategoriesTableReferences
                        ._categoryIdTable(db),
                    referencedColumn: $$ShoppingListCategoriesTableReferences
                        ._categoryIdTable(db)
                        .id,
                  ) as T;
                }
                if (targetInventoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.targetInventoryId,
                    referencedTable: $$ShoppingListCategoriesTableReferences
                        ._targetInventoryIdTable(db),
                    referencedColumn: $$ShoppingListCategoriesTableReferences
                        ._targetInventoryIdTable(db)
                        .id,
                  ) as T;
                }
                if (targetInventoryCategoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.targetInventoryCategoryId,
                    referencedTable: $$ShoppingListCategoriesTableReferences
                        ._targetInventoryCategoryIdTable(db),
                    referencedColumn: $$ShoppingListCategoriesTableReferences
                        ._targetInventoryCategoryIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ShoppingListCategoriesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ShoppingListCategoriesTable,
        ShoppingListCategory,
        $$ShoppingListCategoriesTableFilterComposer,
        $$ShoppingListCategoriesTableOrderingComposer,
        $$ShoppingListCategoriesTableAnnotationComposer,
        $$ShoppingListCategoriesTableCreateCompanionBuilder,
        $$ShoppingListCategoriesTableUpdateCompanionBuilder,
        (ShoppingListCategory, $$ShoppingListCategoriesTableReferences),
        ShoppingListCategory,
        PrefetchHooks Function(
            {bool shoppingListId,
            bool categoryId,
            bool targetInventoryId,
            bool targetInventoryCategoryId})>;
typedef $$ShoppingListItemsTableCreateCompanionBuilder
    = ShoppingListItemsCompanion Function({
  required String id,
  required String shoppingListId,
  Value<String?> productId,
  Value<String?> categoryId,
  Value<String?> targetInventoryId,
  Value<String?> targetInventoryCategoryId,
  required String rawText,
  Value<double?> quantity,
  Value<String?> unit,
  Value<String> status,
  Value<String> source,
  Value<double> priorityScore,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> purchasedAt,
  Value<DateTime?> deletedAt,
  Value<String> syncStatus,
  Value<int> version,
  Value<int> rowid,
});
typedef $$ShoppingListItemsTableUpdateCompanionBuilder
    = ShoppingListItemsCompanion Function({
  Value<String> id,
  Value<String> shoppingListId,
  Value<String?> productId,
  Value<String?> categoryId,
  Value<String?> targetInventoryId,
  Value<String?> targetInventoryCategoryId,
  Value<String> rawText,
  Value<double?> quantity,
  Value<String?> unit,
  Value<String> status,
  Value<String> source,
  Value<double> priorityScore,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> purchasedAt,
  Value<DateTime?> deletedAt,
  Value<String> syncStatus,
  Value<int> version,
  Value<int> rowid,
});

final class $$ShoppingListItemsTableReferences extends BaseReferences<
    _$AppDatabase, $ShoppingListItemsTable, ShoppingListItem> {
  $$ShoppingListItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ShoppingListsTable _shoppingListIdTable(_$AppDatabase db) =>
      db.shoppingLists.createAlias($_aliasNameGenerator(
          db.shoppingListItems.shoppingListId, db.shoppingLists.id));

  $$ShoppingListsTableProcessedTableManager get shoppingListId {
    final $_column = $_itemColumn<String>('shopping_list_id')!;

    final manager = $$ShoppingListsTableTableManager($_db, $_db.shoppingLists)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shoppingListIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
          $_aliasNameGenerator(db.shoppingListItems.productId, db.products.id));

  $$ProductsTableProcessedTableManager? get productId {
    final $_column = $_itemColumn<String>('product_id');
    if ($_column == null) return null;
    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias($_aliasNameGenerator(
          db.shoppingListItems.categoryId, db.categories.id));

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $InventoriesTable _targetInventoryIdTable(_$AppDatabase db) =>
      db.inventories.createAlias($_aliasNameGenerator(
          db.shoppingListItems.targetInventoryId, db.inventories.id));

  $$InventoriesTableProcessedTableManager? get targetInventoryId {
    final $_column = $_itemColumn<String>('target_inventory_id');
    if ($_column == null) return null;
    final manager = $$InventoriesTableTableManager($_db, $_db.inventories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetInventoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $InventoryCategoriesTable _targetInventoryCategoryIdTable(
          _$AppDatabase db) =>
      db.inventoryCategories.createAlias($_aliasNameGenerator(
          db.shoppingListItems.targetInventoryCategoryId,
          db.inventoryCategories.id));

  $$InventoryCategoriesTableProcessedTableManager?
      get targetInventoryCategoryId {
    final $_column = $_itemColumn<String>('target_inventory_category_id');
    if ($_column == null) return null;
    final manager =
        $$InventoryCategoriesTableTableManager($_db, $_db.inventoryCategories)
            .filter((f) => f.id.sqlEquals($_column));
    final item =
        $_typedResult.readTableOrNull(_targetInventoryCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ShoppingListItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rawText => $composableBuilder(
      column: $table.rawText, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get priorityScore => $composableBuilder(
      column: $table.priorityScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get purchasedAt => $composableBuilder(
      column: $table.purchasedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  $$ShoppingListsTableFilterComposer get shoppingListId {
    final $$ShoppingListsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shoppingListId,
        referencedTable: $db.shoppingLists,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListsTableFilterComposer(
              $db: $db,
              $table: $db.shoppingLists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoriesTableFilterComposer get targetInventoryId {
    final $$InventoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetInventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableFilterComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoryCategoriesTableFilterComposer get targetInventoryCategoryId {
    final $$InventoryCategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetInventoryCategoryId,
        referencedTable: $db.inventoryCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryCategoriesTableFilterComposer(
              $db: $db,
              $table: $db.inventoryCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ShoppingListItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rawText => $composableBuilder(
      column: $table.rawText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get priorityScore => $composableBuilder(
      column: $table.priorityScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get purchasedAt => $composableBuilder(
      column: $table.purchasedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  $$ShoppingListsTableOrderingComposer get shoppingListId {
    final $$ShoppingListsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shoppingListId,
        referencedTable: $db.shoppingLists,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListsTableOrderingComposer(
              $db: $db,
              $table: $db.shoppingLists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoriesTableOrderingComposer get targetInventoryId {
    final $$InventoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetInventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableOrderingComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoryCategoriesTableOrderingComposer get targetInventoryCategoryId {
    final $$InventoryCategoriesTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.targetInventoryCategoryId,
            referencedTable: $db.inventoryCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$InventoryCategoriesTableOrderingComposer(
                  $db: $db,
                  $table: $db.inventoryCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ShoppingListItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rawText =>
      $composableBuilder(column: $table.rawText, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<double> get priorityScore => $composableBuilder(
      column: $table.priorityScore, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get purchasedAt => $composableBuilder(
      column: $table.purchasedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  $$ShoppingListsTableAnnotationComposer get shoppingListId {
    final $$ShoppingListsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shoppingListId,
        referencedTable: $db.shoppingLists,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListsTableAnnotationComposer(
              $db: $db,
              $table: $db.shoppingLists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoriesTableAnnotationComposer get targetInventoryId {
    final $$InventoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetInventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoryCategoriesTableAnnotationComposer get targetInventoryCategoryId {
    final $$InventoryCategoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.targetInventoryCategoryId,
            referencedTable: $db.inventoryCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$InventoryCategoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.inventoryCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ShoppingListItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShoppingListItemsTable,
    ShoppingListItem,
    $$ShoppingListItemsTableFilterComposer,
    $$ShoppingListItemsTableOrderingComposer,
    $$ShoppingListItemsTableAnnotationComposer,
    $$ShoppingListItemsTableCreateCompanionBuilder,
    $$ShoppingListItemsTableUpdateCompanionBuilder,
    (ShoppingListItem, $$ShoppingListItemsTableReferences),
    ShoppingListItem,
    PrefetchHooks Function(
        {bool shoppingListId,
        bool productId,
        bool categoryId,
        bool targetInventoryId,
        bool targetInventoryCategoryId})> {
  $$ShoppingListItemsTableTableManager(
      _$AppDatabase db, $ShoppingListItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingListItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingListItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingListItemsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> shoppingListId = const Value.absent(),
            Value<String?> productId = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String?> targetInventoryId = const Value.absent(),
            Value<String?> targetInventoryCategoryId = const Value.absent(),
            Value<String> rawText = const Value.absent(),
            Value<double?> quantity = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<double> priorityScore = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> purchasedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShoppingListItemsCompanion(
            id: id,
            shoppingListId: shoppingListId,
            productId: productId,
            categoryId: categoryId,
            targetInventoryId: targetInventoryId,
            targetInventoryCategoryId: targetInventoryCategoryId,
            rawText: rawText,
            quantity: quantity,
            unit: unit,
            status: status,
            source: source,
            priorityScore: priorityScore,
            createdAt: createdAt,
            updatedAt: updatedAt,
            purchasedAt: purchasedAt,
            deletedAt: deletedAt,
            syncStatus: syncStatus,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String shoppingListId,
            Value<String?> productId = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String?> targetInventoryId = const Value.absent(),
            Value<String?> targetInventoryCategoryId = const Value.absent(),
            required String rawText,
            Value<double?> quantity = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<double> priorityScore = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> purchasedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShoppingListItemsCompanion.insert(
            id: id,
            shoppingListId: shoppingListId,
            productId: productId,
            categoryId: categoryId,
            targetInventoryId: targetInventoryId,
            targetInventoryCategoryId: targetInventoryCategoryId,
            rawText: rawText,
            quantity: quantity,
            unit: unit,
            status: status,
            source: source,
            priorityScore: priorityScore,
            createdAt: createdAt,
            updatedAt: updatedAt,
            purchasedAt: purchasedAt,
            deletedAt: deletedAt,
            syncStatus: syncStatus,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ShoppingListItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {shoppingListId = false,
              productId = false,
              categoryId = false,
              targetInventoryId = false,
              targetInventoryCategoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (shoppingListId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.shoppingListId,
                    referencedTable: $$ShoppingListItemsTableReferences
                        ._shoppingListIdTable(db),
                    referencedColumn: $$ShoppingListItemsTableReferences
                        ._shoppingListIdTable(db)
                        .id,
                  ) as T;
                }
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$ShoppingListItemsTableReferences._productIdTable(db),
                    referencedColumn: $$ShoppingListItemsTableReferences
                        ._productIdTable(db)
                        .id,
                  ) as T;
                }
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$ShoppingListItemsTableReferences._categoryIdTable(db),
                    referencedColumn: $$ShoppingListItemsTableReferences
                        ._categoryIdTable(db)
                        .id,
                  ) as T;
                }
                if (targetInventoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.targetInventoryId,
                    referencedTable: $$ShoppingListItemsTableReferences
                        ._targetInventoryIdTable(db),
                    referencedColumn: $$ShoppingListItemsTableReferences
                        ._targetInventoryIdTable(db)
                        .id,
                  ) as T;
                }
                if (targetInventoryCategoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.targetInventoryCategoryId,
                    referencedTable: $$ShoppingListItemsTableReferences
                        ._targetInventoryCategoryIdTable(db),
                    referencedColumn: $$ShoppingListItemsTableReferences
                        ._targetInventoryCategoryIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ShoppingListItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ShoppingListItemsTable,
    ShoppingListItem,
    $$ShoppingListItemsTableFilterComposer,
    $$ShoppingListItemsTableOrderingComposer,
    $$ShoppingListItemsTableAnnotationComposer,
    $$ShoppingListItemsTableCreateCompanionBuilder,
    $$ShoppingListItemsTableUpdateCompanionBuilder,
    (ShoppingListItem, $$ShoppingListItemsTableReferences),
    ShoppingListItem,
    PrefetchHooks Function(
        {bool shoppingListId,
        bool productId,
        bool categoryId,
        bool targetInventoryId,
        bool targetInventoryCategoryId})>;
typedef $$InventoryEventsTableCreateCompanionBuilder = InventoryEventsCompanion
    Function({
  required String id,
  Value<String?> inventoryId,
  Value<String?> productId,
  Value<String?> inventoryItemId,
  Value<String> eventType,
  Value<double?> quantity,
  Value<String?> unit,
  Value<String> source,
  required DateTime occurredAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$InventoryEventsTableUpdateCompanionBuilder = InventoryEventsCompanion
    Function({
  Value<String> id,
  Value<String?> inventoryId,
  Value<String?> productId,
  Value<String?> inventoryItemId,
  Value<String> eventType,
  Value<double?> quantity,
  Value<String?> unit,
  Value<String> source,
  Value<DateTime> occurredAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$InventoryEventsTableReferences extends BaseReferences<
    _$AppDatabase, $InventoryEventsTable, InventoryEvent> {
  $$InventoryEventsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $InventoriesTable _inventoryIdTable(_$AppDatabase db) =>
      db.inventories.createAlias($_aliasNameGenerator(
          db.inventoryEvents.inventoryId, db.inventories.id));

  $$InventoriesTableProcessedTableManager? get inventoryId {
    final $_column = $_itemColumn<String>('inventory_id');
    if ($_column == null) return null;
    final manager = $$InventoriesTableTableManager($_db, $_db.inventories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inventoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
          $_aliasNameGenerator(db.inventoryEvents.productId, db.products.id));

  $$ProductsTableProcessedTableManager? get productId {
    final $_column = $_itemColumn<String>('product_id');
    if ($_column == null) return null;
    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $InventoryItemsTable _inventoryItemIdTable(_$AppDatabase db) =>
      db.inventoryItems.createAlias($_aliasNameGenerator(
          db.inventoryEvents.inventoryItemId, db.inventoryItems.id));

  $$InventoryItemsTableProcessedTableManager? get inventoryItemId {
    final $_column = $_itemColumn<String>('inventory_item_id');
    if ($_column == null) return null;
    final manager = $$InventoryItemsTableTableManager($_db, $_db.inventoryItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inventoryItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$InventoryEventsTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryEventsTable> {
  $$InventoryEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$InventoriesTableFilterComposer get inventoryId {
    final $$InventoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableFilterComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoryItemsTableFilterComposer get inventoryItemId {
    final $$InventoryItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryItemId,
        referencedTable: $db.inventoryItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryItemsTableFilterComposer(
              $db: $db,
              $table: $db.inventoryItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InventoryEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryEventsTable> {
  $$InventoryEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$InventoriesTableOrderingComposer get inventoryId {
    final $$InventoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableOrderingComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoryItemsTableOrderingComposer get inventoryItemId {
    final $$InventoryItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryItemId,
        referencedTable: $db.inventoryItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryItemsTableOrderingComposer(
              $db: $db,
              $table: $db.inventoryItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InventoryEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryEventsTable> {
  $$InventoryEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$InventoriesTableAnnotationComposer get inventoryId {
    final $$InventoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryId,
        referencedTable: $db.inventories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.inventories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InventoryItemsTableAnnotationComposer get inventoryItemId {
    final $$InventoryItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.inventoryItemId,
        referencedTable: $db.inventoryItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.inventoryItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InventoryEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InventoryEventsTable,
    InventoryEvent,
    $$InventoryEventsTableFilterComposer,
    $$InventoryEventsTableOrderingComposer,
    $$InventoryEventsTableAnnotationComposer,
    $$InventoryEventsTableCreateCompanionBuilder,
    $$InventoryEventsTableUpdateCompanionBuilder,
    (InventoryEvent, $$InventoryEventsTableReferences),
    InventoryEvent,
    PrefetchHooks Function(
        {bool inventoryId, bool productId, bool inventoryItemId})> {
  $$InventoryEventsTableTableManager(
      _$AppDatabase db, $InventoryEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> inventoryId = const Value.absent(),
            Value<String?> productId = const Value.absent(),
            Value<String?> inventoryItemId = const Value.absent(),
            Value<String> eventType = const Value.absent(),
            Value<double?> quantity = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<DateTime> occurredAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryEventsCompanion(
            id: id,
            inventoryId: inventoryId,
            productId: productId,
            inventoryItemId: inventoryItemId,
            eventType: eventType,
            quantity: quantity,
            unit: unit,
            source: source,
            occurredAt: occurredAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> inventoryId = const Value.absent(),
            Value<String?> productId = const Value.absent(),
            Value<String?> inventoryItemId = const Value.absent(),
            Value<String> eventType = const Value.absent(),
            Value<double?> quantity = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String> source = const Value.absent(),
            required DateTime occurredAt,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryEventsCompanion.insert(
            id: id,
            inventoryId: inventoryId,
            productId: productId,
            inventoryItemId: inventoryItemId,
            eventType: eventType,
            quantity: quantity,
            unit: unit,
            source: source,
            occurredAt: occurredAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$InventoryEventsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {inventoryId = false,
              productId = false,
              inventoryItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (inventoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.inventoryId,
                    referencedTable:
                        $$InventoryEventsTableReferences._inventoryIdTable(db),
                    referencedColumn: $$InventoryEventsTableReferences
                        ._inventoryIdTable(db)
                        .id,
                  ) as T;
                }
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$InventoryEventsTableReferences._productIdTable(db),
                    referencedColumn:
                        $$InventoryEventsTableReferences._productIdTable(db).id,
                  ) as T;
                }
                if (inventoryItemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.inventoryItemId,
                    referencedTable: $$InventoryEventsTableReferences
                        ._inventoryItemIdTable(db),
                    referencedColumn: $$InventoryEventsTableReferences
                        ._inventoryItemIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$InventoryEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InventoryEventsTable,
    InventoryEvent,
    $$InventoryEventsTableFilterComposer,
    $$InventoryEventsTableOrderingComposer,
    $$InventoryEventsTableAnnotationComposer,
    $$InventoryEventsTableCreateCompanionBuilder,
    $$InventoryEventsTableUpdateCompanionBuilder,
    (InventoryEvent, $$InventoryEventsTableReferences),
    InventoryEvent,
    PrefetchHooks Function(
        {bool inventoryId, bool productId, bool inventoryItemId})>;
typedef $$PriceObservationsTableCreateCompanionBuilder
    = PriceObservationsCompanion Function({
  required String id,
  Value<String?> productId,
  Value<String?> storeName,
  required double packageQuantity,
  Value<String> packageUnit,
  required double price,
  required double unitPrice,
  required DateTime observedAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$PriceObservationsTableUpdateCompanionBuilder
    = PriceObservationsCompanion Function({
  Value<String> id,
  Value<String?> productId,
  Value<String?> storeName,
  Value<double> packageQuantity,
  Value<String> packageUnit,
  Value<double> price,
  Value<double> unitPrice,
  Value<DateTime> observedAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$PriceObservationsTableReferences extends BaseReferences<
    _$AppDatabase, $PriceObservationsTable, PriceObservation> {
  $$PriceObservationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
          $_aliasNameGenerator(db.priceObservations.productId, db.products.id));

  $$ProductsTableProcessedTableManager? get productId {
    final $_column = $_itemColumn<String>('product_id');
    if ($_column == null) return null;
    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PriceObservationsTableFilterComposer
    extends Composer<_$AppDatabase, $PriceObservationsTable> {
  $$PriceObservationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get storeName => $composableBuilder(
      column: $table.storeName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get packageQuantity => $composableBuilder(
      column: $table.packageQuantity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get packageUnit => $composableBuilder(
      column: $table.packageUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get observedAt => $composableBuilder(
      column: $table.observedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PriceObservationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PriceObservationsTable> {
  $$PriceObservationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get storeName => $composableBuilder(
      column: $table.storeName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get packageQuantity => $composableBuilder(
      column: $table.packageQuantity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get packageUnit => $composableBuilder(
      column: $table.packageUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get observedAt => $composableBuilder(
      column: $table.observedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PriceObservationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PriceObservationsTable> {
  $$PriceObservationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeName =>
      $composableBuilder(column: $table.storeName, builder: (column) => column);

  GeneratedColumn<double> get packageQuantity => $composableBuilder(
      column: $table.packageQuantity, builder: (column) => column);

  GeneratedColumn<String> get packageUnit => $composableBuilder(
      column: $table.packageUnit, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<DateTime> get observedAt => $composableBuilder(
      column: $table.observedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PriceObservationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PriceObservationsTable,
    PriceObservation,
    $$PriceObservationsTableFilterComposer,
    $$PriceObservationsTableOrderingComposer,
    $$PriceObservationsTableAnnotationComposer,
    $$PriceObservationsTableCreateCompanionBuilder,
    $$PriceObservationsTableUpdateCompanionBuilder,
    (PriceObservation, $$PriceObservationsTableReferences),
    PriceObservation,
    PrefetchHooks Function({bool productId})> {
  $$PriceObservationsTableTableManager(
      _$AppDatabase db, $PriceObservationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PriceObservationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PriceObservationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PriceObservationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> productId = const Value.absent(),
            Value<String?> storeName = const Value.absent(),
            Value<double> packageQuantity = const Value.absent(),
            Value<String> packageUnit = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double> unitPrice = const Value.absent(),
            Value<DateTime> observedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PriceObservationsCompanion(
            id: id,
            productId: productId,
            storeName: storeName,
            packageQuantity: packageQuantity,
            packageUnit: packageUnit,
            price: price,
            unitPrice: unitPrice,
            observedAt: observedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> productId = const Value.absent(),
            Value<String?> storeName = const Value.absent(),
            required double packageQuantity,
            Value<String> packageUnit = const Value.absent(),
            required double price,
            required double unitPrice,
            required DateTime observedAt,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PriceObservationsCompanion.insert(
            id: id,
            productId: productId,
            storeName: storeName,
            packageQuantity: packageQuantity,
            packageUnit: packageUnit,
            price: price,
            unitPrice: unitPrice,
            observedAt: observedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PriceObservationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$PriceObservationsTableReferences._productIdTable(db),
                    referencedColumn: $$PriceObservationsTableReferences
                        ._productIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PriceObservationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PriceObservationsTable,
    PriceObservation,
    $$PriceObservationsTableFilterComposer,
    $$PriceObservationsTableOrderingComposer,
    $$PriceObservationsTableAnnotationComposer,
    $$PriceObservationsTableCreateCompanionBuilder,
    $$PriceObservationsTableUpdateCompanionBuilder,
    (PriceObservation, $$PriceObservationsTableReferences),
    PriceObservation,
    PrefetchHooks Function({bool productId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$ProductAliasesTableTableManager get productAliases =>
      $$ProductAliasesTableTableManager(_db, _db.productAliases);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$InventoriesTableTableManager get inventories =>
      $$InventoriesTableTableManager(_db, _db.inventories);
  $$InventoryCategoriesTableTableManager get inventoryCategories =>
      $$InventoryCategoriesTableTableManager(_db, _db.inventoryCategories);
  $$InventoryItemsTableTableManager get inventoryItems =>
      $$InventoryItemsTableTableManager(_db, _db.inventoryItems);
  $$ShoppingListsTableTableManager get shoppingLists =>
      $$ShoppingListsTableTableManager(_db, _db.shoppingLists);
  $$ShoppingListInventoryLinksTableTableManager
      get shoppingListInventoryLinks =>
          $$ShoppingListInventoryLinksTableTableManager(
              _db, _db.shoppingListInventoryLinks);
  $$ShoppingListCategoriesTableTableManager get shoppingListCategories =>
      $$ShoppingListCategoriesTableTableManager(
          _db, _db.shoppingListCategories);
  $$ShoppingListItemsTableTableManager get shoppingListItems =>
      $$ShoppingListItemsTableTableManager(_db, _db.shoppingListItems);
  $$InventoryEventsTableTableManager get inventoryEvents =>
      $$InventoryEventsTableTableManager(_db, _db.inventoryEvents);
  $$PriceObservationsTableTableManager get priceObservations =>
      $$PriceObservationsTableTableManager(_db, _db.priceObservations);
}

mixin _$ProductsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProductsTable get products => attachedDatabase.products;
  $ProductAliasesTable get productAliases => attachedDatabase.productAliases;
}
mixin _$ShoppingListsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $InventoriesTable get inventories => attachedDatabase.inventories;
  $ShoppingListsTable get shoppingLists => attachedDatabase.shoppingLists;
  $InventoryCategoriesTable get inventoryCategories =>
      attachedDatabase.inventoryCategories;
  $ShoppingListCategoriesTable get shoppingListCategories =>
      attachedDatabase.shoppingListCategories;
  $ProductsTable get products => attachedDatabase.products;
  $ShoppingListItemsTable get shoppingListItems =>
      attachedDatabase.shoppingListItems;
  $ShoppingListInventoryLinksTable get shoppingListInventoryLinks =>
      attachedDatabase.shoppingListInventoryLinks;
}
mixin _$PantryDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $InventoriesTable get inventories => attachedDatabase.inventories;
  $InventoryCategoriesTable get inventoryCategories =>
      attachedDatabase.inventoryCategories;
  $ProductsTable get products => attachedDatabase.products;
  $InventoryItemsTable get inventoryItems => attachedDatabase.inventoryItems;
  $InventoryEventsTable get inventoryEvents => attachedDatabase.inventoryEvents;
}
mixin _$PriceObservationsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProductsTable get products => attachedDatabase.products;
  $PriceObservationsTable get priceObservations =>
      attachedDatabase.priceObservations;
}
