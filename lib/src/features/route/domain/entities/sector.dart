import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';

class Sector {
  Sector({
    this.id,
    this.isActive,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.municipality,
    this.province,
    this.schedule,
    this.isVisible,
    this.rating,
    this.votes,
    this.votes1,
    this.votes2,
    this.votes3,
    this.votes4,
    this.votes5,
  });

  String id;
  bool isActive;
  String name;
  String createdAt;
  String updatedAt;
  int v;
  CatalogItem municipality;
  CatalogItem province;
  List<Schedule> schedule;
  bool isVisible;
  int rating;
  int votes;
  int votes1;
  int votes2;
  int votes3;
  int votes4;
  int votes5;

}