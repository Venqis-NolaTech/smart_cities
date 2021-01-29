import 'package:smart_cities/src/core/entities/catalog_item.dart';

import '../../../../core/models/catalog_item_model.dart';
import '../../../../core/util/list_util.dart';
import '../../domain/entities/report.dart';

class ReportListingModel extends ReportListing {
  ReportListingModel({
    int totalCount,
    List<ReportModel> reports,
  }) : super(
          totalCount: totalCount,
          reports: reports,
        );

  // Json
  factory ReportListingModel.fromJson(Map<String, dynamic> json) {
    return ReportListingModel(
      totalCount: json['totalCount'],
      reports: (json['reports'] as List).isNotNullOrNotEmpty
          ? List<ReportModel>.from(
              json['reports'].map((v) => ReportModel.fromJson(v)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'reports': reports.isNotNullOrNotEmpty
          ? reports.map((r) => ReportModel.fromEntity(r).toJson()).toList()
          : null,
    };
  }
}

class ReportModel extends Report {
  ReportModel({
    CatalogItem province,
    CatalogItem municipality,
    CatalogItem sector,
    LocationR location,
    CatalogItem category,
    String status,
    bool muted,
    List<String> images,
    List<String> imagesClosed,
    bool isAnonymous,
    String priority,
    bool isActive,
    bool isVisible,
    String id,
    String title,
    String description,
    double latitude,
    double longitude,
    String street,
    CreatedBy createdBy,
    int number,
    String createdAt,
    String updatedAt,
    bool follow})
      : super(
      province: province,
      municipality: municipality,
      sector: sector,
      location: location,
      category: category,
      status: status,
      muted: muted,
      images: images,
      imagesClosed: imagesClosed,
      isAnonymous: isAnonymous,
      priority: priority,
      isActive: isActive,
      isVisible: isVisible,
      id: id,
      title: title,
      description: description,
      latitude: latitude,
      longitude: longitude,
      street: street,
      createdBy: createdBy,
      number: number,
      createdAt: createdAt,
      updatedAt: updatedAt,
      follow: follow,
            );

  factory ReportModel.fromEntity(Report report) {
    return ReportModel(
        id: report.id,
        title: report.title,
        description: report.description,
        latitude: report.longitude,
        longitude: report.longitude,
        street: report.street,
        createdBy: report.createdBy,
        number: report.number,
        createdAt: report.createdAt,
        updatedAt: report.updatedAt,
        follow: report.follow,
        province: report.province,
        municipality: report.municipality,
        sector: report.sector,
        location: report.location,
        category: report.category,
        status: report.status,
        muted: report.muted,
        images: report.images,
        imagesClosed: report.imagesClosed,
        isAnonymous: report.isAnonymous,
        priority: report.priority,
        isActive: report.isActive,
        isVisible: report.isVisible
    );
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      province: json["province"] != null ? CatalogItemModel.fromJson(json["province"]) : null,
      municipality: json["municipality"] != null ? CatalogItemModel.fromJson(json["municipality"]) : null,
      sector: json["sector"] != null ? CatalogItemModel.fromJson(json["sector"]) : null,
      location: json["location"]!= null ? LocationModel.fromJson(json["location"]) : null,
      category: json["category"] != null ? CatalogItemModel.fromJson(json["category"]) : null,
      status: json["status"],
      muted: json["muted"],
      images: (json['images'] as List).isNotNullOrNotEmpty ? List<String>.from(json["images"].map((x) => x)) : null,
      imagesClosed: (json['imagesClosed'] as List).isNotNullOrNotEmpty ? List<String>.from(json["imagesClosed"].map((x) => x)) : null,
      isAnonymous: json["isAnonymous"],
      priority: json["priority"],
      isActive: json["isActive"],
      isVisible: json["isVisible"],
      id: json["_id"],
      title: json["title"],
      description: json["description"],
      latitude: json["latitude"]  ?? 0.0,
      longitude: json["longitude"]  ?? 0.0,
      street: json["street"],
      createdBy: json["createdBy"]!=null ? CreatedByModel.fromJson(json["createdBy"]): null,
      number: json["number"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      follow: json["follow"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "province": province != null ? CatalogItemModel.fromEntity(province).toJson() : null,
      "municipality": municipality != null ? CatalogItemModel.fromEntity(municipality).toJson() : null,
      "sector": sector != null ? CatalogItemModel.fromEntity(sector).toJson() : null,
      "location": location != null ? LocationModel.fromEntity(location).toJson() : null,
      "category": category != null ? CatalogItemModel.fromEntity(category).toJson() : null,
      "status": status,
      "muted": muted,
      "images": images.isNotNullOrNotEmpty ?  List<dynamic>.from(images.map((x) => x)) : null,
      "imagesClosed": imagesClosed.isNotNullOrNotEmpty ?  List<dynamic>.from(imagesClosed.map((x) => x)) : null,
      "isAnonymous": isAnonymous,
      "priority": priority,
      "isActive": isActive,
      "isVisible": isVisible,
      "_id": id,
      "title": title,
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      "street": street,
      "createdBy":  createdBy != null ? CreatedByModel.fromEntity(createdBy).toJson() : null,
      "number": number,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "follow": follow,
    };
  }
}

class ReportInformerModel extends ReportInformer {
  ReportInformerModel({
    String firstName,
    String lastName,
    String dni,
    String gender,
    String areaCode,
    String phoneNumber,
    int age,
    String nationality,
  }) : super(
          firstName: firstName,
          lastName: lastName,
          dni: dni,
          gender: gender,
          areaCode: areaCode,
          phoneNumber: phoneNumber,
          age: age,
          nationality: nationality,
        );

  factory ReportInformerModel.fromEntity(ReportInformer informer) {
    return ReportInformerModel(
      firstName: informer.firstName,
      lastName: informer.lastName,
      dni: informer.dni,
      gender: informer.gender,
      areaCode: informer.areaCode,
      phoneNumber: informer.phoneNumber,
      age: informer.age,
      nationality: informer.nationality,
    );
  }

  factory ReportInformerModel.fromJson(Map<String, dynamic> json) {
    return ReportInformerModel(
      firstName: json['first_name'],
      lastName: json['last_name'],
      dni: json['dni'],
      gender: json['gender'],
      areaCode: json['code_area'],
      phoneNumber: json['phone_number'],
      age: json['age'] ?? 0,
      nationality: json['nationality'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'dni': dni,
      'gender': gender,
      'code_area': areaCode,
      'phone_number': phoneNumber,
      'age': age,
      'nationality': nationality,
    };
  }
}

class ReportCommentListingModel extends ReportCommentListing {
  ReportCommentListingModel({
    int totalCount,
    List<ReportCommentModel> comments,
  }) : super(
          totalCount: totalCount,
          comments: comments,
        );

  // Json
  factory ReportCommentListingModel.fromJson(Map<String, dynamic> json) {
    return ReportCommentListingModel(
      totalCount: json['totalCount'],
      comments: (json['comments'] as List).isNotNullOrNotEmpty
          ? List<ReportCommentModel>.from(
                  json['comments'].map((c) => ReportCommentModel.fromJson(c)))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'comments': comments.isNotNullOrNotEmpty
          ? comments
              .map((c) => ReportCommentModel.fromEntity(c).toJson())
              .toList()
          : null,
    };
  }
}

class ReportCommentModel extends ReportComment {
  ReportCommentModel({
    String type,
    bool isAnonymous,
    List<String> pictureUrl,
    bool isActive,
    bool isVisible,
    String id,
    String report,
    String comment,
    ReportUser user,
    String status,
    //List<dynamic> comments;
    String createdAt,
    String updatedAt,
    int v
  }) : super(
          type: type,
          isAnonymous: isAnonymous,
          pictureUrl: pictureUrl,
          isActive: isActive,
          isVisible: isVisible,
          id: id,
          report: report,
          comment: comment,
          user: user,
          status: status,
          createdAt: createdAt,
          updatedAt: updatedAt
        );

  factory ReportCommentModel.fromEntity(ReportComment comment) {
    return ReportCommentModel(
      id: comment.id,
      type: comment.type,
      isAnonymous: comment.isAnonymous,
      pictureUrl: comment.pictureUrl,
      isActive: comment.isActive,
      isVisible: comment.isVisible,
      report: comment.report,
      comment: comment.comment,
      user: comment.user,
      status: comment.status,
      createdAt: comment.createdAt,
      updatedAt: comment.updatedAt
    );
  }

  factory ReportCommentModel.fromJson(Map<String, dynamic> json) {
    return ReportCommentModel(
      type: json["type"],
      isAnonymous: json["isAnonymous"],
      pictureUrl: List<String>.from(json["pictureURL"].map((x) => x)),
      isActive: json["isActive"],
      isVisible: json["isVisible"],
      id: json["_id"],
      report: json["report"],
      comment: json["comment"],
      user: json['user'] != null ? ReportUserModel.fromJson(json['user']) : null,
      status: json["status"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "isAnonymous": isAnonymous,
      "pictureURL": List<dynamic>.from(pictureUrl.map((x) => x)),
      "isActive": isActive,
      "isVisible": isVisible,
      "_id": id,
      "report": report,
      "comment": comment,
      "user": user!= null ? ReportUserModel.fromEntity(user) : null,
      //"comments": comments!= null ? List<dynamic>.from(comments.map((x) => x)) :,
      "status": status,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
    };
  }
}

class ReportUserModel extends ReportUser {
  ReportUserModel({
    String id,
    String displayName,
    String pictureUrl,
    bool isAdmin
  }) : super(
          id: id,
          displayName: displayName,
          pictureUrl: pictureUrl,
          isAdmin: isAdmin
        );

  factory ReportUserModel.fromEntity(ReportUser reportUser) {
    return ReportUserModel(
      id: reportUser.id,
      displayName: reportUser.displayName,
      pictureUrl: reportUser.pictureUrl,
      isAdmin: reportUser.isAdmin
    );
  }

  factory ReportUserModel.fromJson(Map<String, dynamic> json) {
    return ReportUserModel(
      id: json['id'],
      displayName: json['displayName'],
      pictureUrl: json['photoURL'],
      isAdmin: json['isAdmin'] ?? false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'photoURL': pictureUrl,
      'isAdmin' : isAdmin
    };
  }
}


class LocationModel extends LocationR{
  LocationModel({String type,
        List<double> coordinates})
      : super(
          type: type,
          coordinates: coordinates,
        );

  factory LocationModel.fromEntity(LocationR locationReport) {
    return LocationModel(
      type: locationReport.type,
      coordinates: locationReport.coordinates
    );
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      type: json["type"],
      coordinates:  json["coordinates"] != null ? List<double>.from(json["coordinates"].map((x) => x.toDouble())) :  null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "coordinates": coordinates!=null ? List<double>.from(coordinates.map((x) => x)) : null,
    };
  }


}


class CreatedByModel extends CreatedBy {
  CreatedByModel({
    String photoUrl,
    String id,
    String displayName
  }): super(
      photoUrl: photoUrl,
      id: id,
      displayName: displayName
  );

  factory CreatedByModel.fromEntity(CreatedBy createdBy) {
    return CreatedByModel(
        photoUrl: createdBy.photoUrl,
        id: createdBy.id,
        displayName: createdBy.displayName
    );
  }

  factory CreatedByModel.fromJson(Map<String, dynamic> json) => CreatedByModel(
    photoUrl: json["photoURL"],
    id: json["_id"],
    displayName: json["displayName"],
  );

  Map<String, dynamic> toJson() => {
    "photoURL": photoUrl,
    "_id": id,
    "displayName": displayName,
  };

}

