import 'package:equatable/equatable.dart';

class CatalogItem extends Equatable {
  final String key;
  final String value;

  CatalogItem({this.key, this.value});

  @override
  List<Object> get props => [key, value];

  @override
  String toString() {
    return value ?? "";
  }
}
