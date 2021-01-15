import 'package:equatable/equatable.dart';

import 'post.dart';

class PostTrainingListings extends Equatable {
  final int total;
  final List<PostTraining> posts;

  PostTrainingListings({
    this.total,
    this.posts,
  });

  @override
  List<Object> get props => [
        total,
        posts,
      ];
}

class PostTraining extends Post {
  final String inscription;
  final String inscriptionFormat;
  final String youLearn;
  final String youLearnFormat;
  final String facilitator;
  final String startDate;
  final String duration;
  final String schedule;
  final String cost;
  final String area;
  final String course;
  final String address;
  final double latitude;
  final double longitude;

  PostTraining({
    String id,
    PostKind kind,
    bool isFeatured,
    bool isActive,
    bool liked,
    int likeCount,
    int commentCount,
    String title,
    String content,
    String contentFormat,
    String pictureURL,
    String shareLink,
    String createdBy,
    String createdAt,
    String updatedAt,
    this.inscription,
    this.inscriptionFormat,
    this.youLearn,
    this.youLearnFormat,
    this.facilitator,
    this.startDate,
    this.duration,
    this.schedule,
    this.cost,
    this.area,
    this.course,
    this.address,
    this.latitude,
    this.longitude,
  }) : super(
          id: id,
          kind: kind,
          isFeatured: isFeatured,
          isActive: isActive,
          liked: liked,
          likeCount: likeCount,
          commentCount: commentCount,
          title: title,
          content: content,
          contentFormat: contentFormat,
          pictureURL: pictureURL,
          shareLink: shareLink,
          createdBy: createdBy,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  @override
  List<Object> get props => [
        ...super.props,
        this.inscription,
        this.inscriptionFormat,
        this.youLearn,
        this.youLearnFormat,
        this.facilitator,
        this.startDate,
        this.duration,
        this.schedule,
        this.cost,
        this.area,
        this.course,
        this.address,
        this.latitude,
        this.longitude,
      ];
}
