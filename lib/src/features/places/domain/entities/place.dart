import 'package:equatable/equatable.dart';
import 'package:smart_cities/src/features/reports/domain/entities/report.dart';


import '../../../../core/entities/catalog_item.dart';


class PlaceListing extends Equatable {
  final int totalCount;
  final List<Place> places;

  PlaceListing({this.totalCount, this.places});

  @override
  List<Object> get props => [totalCount, places];
}

class PlaceCommentListing extends Equatable {
  final int totalCount;
  final List<LastComment> comments;

  PlaceCommentListing({this.totalCount, this.comments});

  @override
  List<Object> get props => [totalCount, comments];
}



class Place extends Equatable{
  Place({
    this.municipality,
    this.category,
    this.images,
    this.id,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.province,
    this.services,
    this.location,
    this.phoneNumber,
    this.videoUrl,
    this.rating,
    this.votes,
    this.votes1,
    this.votes2,
    this.votes3,
    this.votes4,
    this.votes5,
    this.isActive,
    this.isVisible,
    this.aboutTitle,
    this.aboutDescription,
    this.schedule,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lastComment,
  });

  CatalogItem municipality;
  CatalogItem category;
  List<String> images;
  String id;
  String name;
  String address;
  double latitude;
  double longitude;

  CatalogItem province;
  Services services;
  LocationR location;
  String phoneNumber;
  String videoUrl;
  int rating;
  int votes;
  int votes1;
  int votes2;
  int votes3;
  int votes4;
  int votes5;
  bool isActive;
  bool isVisible;
  String aboutTitle;
  String aboutDescription;
  List<Schedule> schedule;
  String createdAt;
  String updatedAt;
  int v;
  LastComment lastComment;

  @override
  List<Object> get props => [
    id, name, address, latitude, longitude
  ];

}



class Services extends Equatable{
  Services({
    this.bicycleZone,
    this.exerciseZone,
    this.childrensZone,
    this.family,
    this.security,
    this.toilets,
    this.cleaning,
    this.restaurant,
  });

  bool bicycleZone;
  bool exerciseZone;
  bool childrensZone;
  bool family;
  bool security;
  bool toilets;
  bool cleaning;
  bool restaurant;

  @override
  List<Object> get props => [];
}


class Schedule extends Equatable {
  Schedule({
    this.day,
    this.dayEs,
    this.from,
    this.to,
  });

  String day;
  String dayEs;
  String from;
  String to;

  @override
  List<Object> get props => [day, dayEs, from, to];
}


class LastComment extends Equatable {
  LastComment({
    this.rating,
    this.isActive,
    this.id,
    this.comment,
    this.user,
    this.place,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  int rating;
  bool isActive;
  String id;
  String comment;
  ReportUser user;
  String place;
  String createdAt;
  String updatedAt;
  int v;

  @override
  List<Object> get props => [id];
}



