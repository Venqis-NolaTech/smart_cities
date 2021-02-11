import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/core/models/catalog_item_model.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/features/reports/data/models/report_model.dart';
import 'package:smart_cities/src/features/reports/domain/entities/report.dart';


class PlaceListingModel extends PlaceListing {
  PlaceListingModel({
    int totalCount,
    List<PlaceModel> places,
  }) : super(
    totalCount: totalCount,
    places: places,
  );

  // Json
  factory PlaceListingModel.fromJson(Map<String, dynamic> json) {
    return PlaceListingModel(
      totalCount: json['totalCount'],
      places: json['places'] != null
          ? List<PlaceModel>.from(
          json['places'].map((v) => PlaceModel.fromJson(v)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'places': places!= null
          ? places.map((r) => PlaceModel.fromEntity(r).toJson()).toList()
          : null,
    };
  }
}

class PlaceCommentListingModel extends PlaceCommentListing {
  PlaceCommentListingModel({
    int totalCount,
    List<LastComment> comments,
  }) : super(
    totalCount: totalCount,
    comments: comments,
  );

  // Json
  factory PlaceCommentListingModel.fromJson(Map<String, dynamic> json) {
    return PlaceCommentListingModel(
      totalCount: json['totalCount'],
      comments: json['ratings']  != null
          ? List<LastComment>.from(
          json['ratings'].map((c) => LastCommentModel.fromJson(c)))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'comments': comments != null
          ? comments
          .map((c) => LastCommentModel.fromEntity(c).toJson())
          .toList()
          : null,
    };
  }
}


class PlaceModel extends Place{

  PlaceModel({
    CatalogItem municipality,
    CatalogItem category,
    List<String> images,
    String id,
    String name,
    String address,
    double latitude,
    double longitude,
    CatalogItem province,
    Services services,
    LocationR location,
    String phoneNumber,
    String videoUrl,
    double rating,
    double votes,
    double votes1,
    double votes2,
    double votes3,
    double votes4,
    double votes5,
    bool isActive,
    bool isVisible,
    String aboutTitle,
    String aboutDescription,
    List<Schedule> schedule,
    String createdAt,
    String updatedAt,
    int v,
    LastComment lastComment
  }): super(
    municipality: municipality,
    category: category,
    images: images,
    id: id,
    name: name,
    address: address,
    latitude: latitude,
    longitude: longitude,
    province: province,
    services: services,
    location: location,
    phoneNumber: phoneNumber,
    videoUrl: videoUrl,
    rating: rating,
    votes: votes,
    votes1: votes1,
    votes2: votes2,
    votes3: votes3,
    votes4: votes4,
    votes5: votes5,
    isActive: isActive,
    isVisible: isVisible,
    aboutTitle: aboutTitle,
    aboutDescription: aboutDescription,
    schedule: schedule,
    createdAt: createdAt,
    updatedAt: updatedAt,
    v: v,
    lastComment: lastComment
  );

  factory PlaceModel.fromEntity(Place place){
    return PlaceModel(
      municipality: place.municipality,
      category: place.category,
      images: place.images,
      id: place.id,
      name: place.name,
      address: place.address,
      latitude: place.latitude,
      longitude: place.longitude,
      province: place.province,
      services: place.services,
      location: place.location,
      phoneNumber: place.phoneNumber,
      videoUrl: place.videoUrl,
      rating: place.rating,
      votes: place.votes,
      votes1: place.votes1,
      votes2: place.votes2,
      votes3: place.votes3,
      votes4: place.votes4,
      votes5: place.votes5,
      isActive: place.isActive,
      isVisible: place.isVisible,
      aboutTitle: place.aboutTitle,
      aboutDescription: place.aboutDescription,
      schedule: place.schedule,
      createdAt: place.createdAt,
      updatedAt: place.updatedAt,
      v: place.v,
      lastComment: place.lastComment
    );
  }

  factory PlaceModel.fromJson(Map<String, dynamic> json) => PlaceModel(
    municipality: json["municipality"] != null ? CatalogItemModel.fromJson(json["municipality"]) : null,
    category: json["category"] != null ? CatalogItemModel.fromJson(json["category"]) : null,
    images: json['images'] !=null ? List<String>.from(json["images"].map((x) => x)) : null,
    id: json["_id"],
    name: json["name"],
    address: json["address"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),

    province: json["province"] == null ? null : CatalogItemModel.fromJson(json["province"]),
    services: json["services"] == null ? null : ServiceModel.fromJson(json["services"]),
    location: json["location"] == null ? null : LocationModel.fromJson(json["location"]),
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    videoUrl: json["videoURL"] == null ? null : json["videoURL"],
    rating: json["rating"] == null ? 0.0 : json["rating"],
    votes: json["votes"] == null ? 0.0 : json["votes"],
    votes1: json["votes_1"] == null ? 0.0 : json["votes_1"],
    votes2: json["votes_2"] == null ? 0.0 : json["votes_2"],
    votes3: json["votes_3"] == null ? 0.0 : json["votes_3"],
    votes4: json["votes_4"] == null ? 0.0 : json["votes_4"],
    votes5: json["votes_5"] == null ? 0.0 : json["votes_5"],
    isActive: json["isActive"] == null ? null : json["isActive"],
    isVisible: json["isVisible"] == null ? null : json["isVisible"],
    aboutTitle: json["aboutTitle"] == null ? null : json["aboutTitle"],
    aboutDescription: json["aboutDescription"] == null ? null : json["aboutDescription"],
    schedule: json["schedule"] == null ? null : List<ScheduleModel>.from(json["schedule"].map((x) => ScheduleModel.fromJson(x))),
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
    v: json["__v"] == null ? null : json["__v"],
    lastComment: json["lastComment"] == null ? null : LastCommentModel.fromJson(json["lastComment"]),
  );

  Map<String, dynamic> toJson() => {
    "municipality": municipality != null ? CatalogItemModel.fromEntity(municipality).toJson() : null,
    "category": category != null ? CatalogItemModel.fromEntity(category).toJson() : null,
    "images": images!= null ?  List<dynamic>.from(images.map((x) => x)) : null,
    "_id": id,
    "name": name,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,

  };

}


class ServiceModel extends Services{
  ServiceModel({
    bool bicycleZone,
    bool exerciseZone,
    bool childrensZone,
    bool family,
    bool security,
    bool toilets,
    bool cleaning,
    bool restaurant
}): super(
    bicycleZone: bicycleZone,
    exerciseZone: exerciseZone,
    childrensZone: childrensZone,
    family: family,
    security: security,
    toilets: toilets,
    cleaning: cleaning,
    restaurant: restaurant
  );

  factory ServiceModel.fromEntity(Services services){
    return ServiceModel(
      bicycleZone: services.bicycleZone,
      exerciseZone: services.exerciseZone,
      childrensZone: services.childrensZone,
      family: services.family,
      security: services.security,
      toilets: services.toilets,
      cleaning: services.cleaning,
      restaurant: services.restaurant
    );
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    bicycleZone: json["bicycleZone"] ?? false,
    exerciseZone: json["exerciseZone"] ?? false,
    childrensZone: json["childrensZone"] ?? false,
    family: json["family"] ?? false,
    security: json["security"] ?? false,
    toilets: json["toilets"] ?? false,
    cleaning: json["cleaning"] ?? false,
    restaurant: json["restaurant"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "bicycleZone": bicycleZone,
    "exerciseZone": exerciseZone,
    "childrensZone": childrensZone,
    "family": family,
    "security": security,
    "toilets": toilets,
    "cleaning": cleaning,
    "restaurant": restaurant,
  };

}

class ScheduleModel extends Schedule{
  ScheduleModel({
    String day,
    String dayEs,
    String from,
    String to
  }): super (
    day: day,
    dayEs: dayEs,
    from: from,
    to: to
  );
  factory ScheduleModel.fromEntity(Schedule schedule){
    return ScheduleModel(
      day: schedule.day,
      dayEs: schedule.dayEs,
      from: schedule.from,
      to: schedule.to
    );
  }


  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
    day: json["day"],
    dayEs: json["day_es"],
    from: json["from"],
    to: json["to"],
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "day_es": dayEs,
    "from": from,
    "to": to,
  };

}

class LastCommentModel extends LastComment{
  LastCommentModel({
    int rating,
    bool isActive,
    String id,
    String comment,
    ReportUser user,
    String place,
    String createdAt,
    String updatedAt,
    int v
  }): super(
    rating: rating,
    isActive: isActive,
    id: id,
    comment: comment,
    user: user,
    place: place,
    createdAt: createdAt,
    updatedAt: updatedAt,
    v: v
  );


  factory LastCommentModel.fromEntity(LastComment comment){
    return LastCommentModel(
      rating: comment.rating,
      isActive: comment.isActive,
      id: comment.id,
      comment: comment.comment,
      user: comment.user,
      place: comment.place,
      createdAt: comment.createdAt,
      updatedAt: comment.updatedAt,
      v: comment.v
    );
  }
  factory LastCommentModel.fromJson(Map<String, dynamic> json) => LastCommentModel(
    rating: json["rating"],
    isActive: json["isActive"],
    id: json["_id"],
    comment: json["comment"],
    user: json["user"]!= null ? ReportUserModel.fromJson(json["user"]) : null,
    place: json["place"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "rating": rating,
    "isActive": isActive,
    "_id": id,
    "comment": comment,
    "user": user!= null ? ReportUserModel.fromEntity(user) : null,
    "place": place,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
  };

}
