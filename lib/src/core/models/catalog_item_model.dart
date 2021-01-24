import '../entities/catalog_item.dart';

class CatalogItemModel extends CatalogItem {
  CatalogItemModel({
    String key,
    String value,
  }) : super(
          key: key,
          value: value,
        );

  factory CatalogItemModel.fromEntity(CatalogItem item) {
    return CatalogItemModel(
      key: item.key,
      value: item.value,
    );
  }

  factory CatalogItemModel.fromJson(Map<String, dynamic> json) {
    return CatalogItemModel(
      key: json.containsKey('_id') ? json['_id'] : json['key'],
      value: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': value,
    };
  }
}
