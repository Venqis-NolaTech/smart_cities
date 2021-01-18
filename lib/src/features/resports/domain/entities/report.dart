import 'package:equatable/equatable.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import '../../../../core/entities/catalog_item.dart';

enum ReportStatus {
  Open, // abierto
  OnProcess, // en progreso
  Closed, // cerrado
}


extension ReportStatusExtension on ReportStatus {
  String get id {
    switch (this) {
      case ReportStatus.Open:
        return "Abierto";
      case ReportStatus.OnProcess:
        return "En Proceso";
      case ReportStatus.Closed:
        return "Cerrado";
    }
    return "Abierto";
  }

  String get iconPath {
    switch (this) {
      case ReportStatus.Open:
        return AppImagePaths.openStatus;
      case ReportStatus.OnProcess:
        return AppImagePaths.inProgressStatus;
      case ReportStatus.Closed:
        return AppImagePaths.closeStatus;
    }
    return AppImagePaths.openStatus;
  }

  static ReportStatus findByValue(String value) {
    if(value=="OPEN")
      return ReportStatus.Open;
    if(value=="CLOSED")
      return ReportStatus.Closed;
    if(value=="ON PROCESS")
      return ReportStatus.OnProcess;

    return  ReportStatus.Open;
  }

}


class ReportListing extends Equatable {
  final int totalCount;
  final List<Report> reports;

  ReportListing({this.totalCount, this.reports});

  @override
  List<Object> get props => [totalCount, reports];
}

class Report extends Equatable {
  Report({
    this.province,
    this.municipality,
    this.sector,
    this.location,
    this.category,
    this.status,
    this.muted,
    this.images,
    this.isAnonymous,
    this.priority,
    this.isActive,
    this.isVisible,
    this.id,
    this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.street,
    this.createdBy,
    this.number,
    this.createdAt,
    this.updatedAt,
    this.follow,
  });

  CatalogItem province;
  CatalogItem municipality;
  CatalogItem sector;
  LocationReport location;
  CatalogItem category;
  String status;
  bool muted;
  List<String> images;
  bool isAnonymous;
  String priority;
  bool isActive;
  bool isVisible;
  String id;
  String title;
  String description;
  double latitude;
  double longitude;
  String street;
  CreatedBy createdBy;
  int number;
  String createdAt;
  String updatedAt;
  bool follow;


  @override
  List<Object> get props => [
        id,
        title,
        latitude,
        longitude,
        number,
        follow,
        municipality,
        category,
        status,
        images
      ];

  ReportStatus get reportStatus =>
      ReportStatusExtension.findByValue(this.status);

  String get iconPath => reportStatus.iconPath;

}

class ReportInformer extends Equatable {
  final String firstName;
  final String lastName;
  final String dni;
  final String gender;
  final String areaCode;
  final String phoneNumber;
  final int age;
  final String nationality;

  ReportInformer({
    this.firstName,
    this.lastName,
    this.dni,
    this.gender,
    this.areaCode,
    this.phoneNumber,
    this.age,
    this.nationality,
  });

  @override
  List<Object> get props => [
        firstName,
        lastName,
        dni,
        gender,
        areaCode,
        phoneNumber,
        age,
        nationality,
      ];
}

class ReportCommentListing extends Equatable {
  final int totalCount;
  final List<ReportComment> comments;

  ReportCommentListing({this.totalCount, this.comments});

  @override
  List<Object> get props => [totalCount, comments];
}

class ReportComment extends Equatable {
  final String type;
  final bool isAnonymous;
  final List<String> pictureUrl;
  final bool isActive;
  final bool isVisible;
  final String id;
  final String report;
  final String comment;
  final ReportUser user;
  //List<dynamic> comments;
  final String createdAt;
  final String updatedAt;
  final int v;

  ReportComment({
    this.type,
    this.isAnonymous,
    this.pictureUrl,
    this.isActive,
    this.isVisible,
    this.id,
    this.report,
    this.comment,
    this.user,
    //this.comments,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  @override
  List<Object> get props => [
        id,
        report,
        user,
        createdAt,
      ];
}

class ReportUser extends Equatable {
  final String id;
  final String displayName;
  final String pictureUrl;

  ReportUser({
    this.id,
    this.displayName,
    this.pictureUrl,
  });

  @override
  List<Object> get props => [
        id,
        displayName,
        pictureUrl,
      ];
}


class LocationReport extends Equatable {
  LocationReport({
    this.type,
    this.coordinates,
  });

  String type;
  List<double> coordinates;

  @override
  List<Object> get props => [
    type,
    coordinates
  ];

}


class CreatedBy {
  CreatedBy({
    this.photoUrl,
    this.id,
    this.displayName,
  });

  String photoUrl;
  String id;
  String displayName;

}

class FilterReportItem{
  String key;
  bool value;
  String title;

  FilterReportItem({this.key, this.value, this.title});
}

