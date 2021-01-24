import '../../../../core/util/list_util.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/post_training.dart';

class PostTrainingListingsModel extends PostTrainingListings {
  PostTrainingListingsModel({
    int total,
    List<PostTrainingModel> posts,
  }) : super(
          total: total,
          posts: posts,
        );

  // Json
  factory PostTrainingListingsModel.fromJson(Map<String, dynamic> json) {
    return PostTrainingListingsModel(
      total: json['totalCount'],
      posts: (json['data'] as List).isNotNullOrNotEmpty
          ? List<PostTrainingModel>.from(
              json['data'].map((ad) => PostTrainingModel.fromJson(ad)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': total,
      'data': posts.isNotNullOrNotEmpty
          ? posts
              .map((post) => PostTrainingModel.fromEntity(post).toJson())
              .toList()
          : null,
    };
  }

  //Entity
  factory PostTrainingListingsModel.fromEntity(
      PostTrainingListingsModel listings) {
    return PostTrainingListingsModel(
      total: listings.total,
      posts: listings.posts,
    );
  }
}

class PostTrainingModel extends PostTraining {
  PostTrainingModel({
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
    String inscription,
    String inscriptionFormat,
    String youLearn,
    String youLearnFormat,
    String facilitator,
    String startDate,
    String duration,
    String schedule,
    String cost,
    String area,
    String course,
    String address,
    double latitude,
    double longitude,
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
          inscription: inscription,
          inscriptionFormat: inscriptionFormat,
          youLearn: youLearn,
          youLearnFormat: youLearnFormat,
          facilitator: facilitator,
          startDate: startDate,
          duration: duration,
          schedule: schedule,
          cost: cost,
          area: area,
          course: course,
          address: address,
          latitude: latitude,
          longitude: longitude,
        );

  // Json
  factory PostTrainingModel.fromJson(Map<String, dynamic> json) {
    return PostTrainingModel(
      id: json['_id'],
      kind: PostKindExtension.find(json['kind']),
      isFeatured: json['isFeatured'] ?? false,
      isActive: json['isActive'] ?? false,
      liked: json['liked'] ?? false,
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      title: json['title'],
      content: json['content'],
      contentFormat: json['contentFormat'],
      pictureURL: json['pictureURL'],
      shareLink: json['shareLink'],
      createdBy: json['createdBy'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      inscription: json['inscription'],
      inscriptionFormat: json['inscriptionFormat'],
      youLearn: json['youLearn'],
      youLearnFormat: json['youLearnFormat'],
      facilitator: json['facilitator'],
      startDate: json['startdate'],
      duration: json['duration'],
      schedule: json['schedule'],
      cost: json['cost'],
      area: json['area'],
      course: json['course'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'kind': kind.value,
      'isFeatured': isFeatured,
      'isActive': isActive,
      'liked': liked,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'title': title,
      'content': content,
      'contentFormat': contentFormat,
      'pictureURL': pictureURL,
      'shareLink': shareLink,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'inscription': inscription,
      'inscriptionFormat': inscriptionFormat,
      'youLearn': youLearn,
      'youLearnFormat': youLearnFormat,
      'facilitator': facilitator,
      'startdate': startDate,
      'duration': duration,
      'schedule': schedule,
      'cost': cost,
      'area': area,
      'course': course,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  //Entity
  factory PostTrainingModel.fromEntity(PostTraining post) {
    return PostTrainingModel(
      id: post.id,
      kind: post.kind,
      isFeatured: post.isFeatured,
      isActive: post.isActive,
      liked: post.liked,
      likeCount: post.likeCount,
      commentCount: post.commentCount,
      title: post.title,
      content: post.content,
      contentFormat: post.contentFormat,
      pictureURL: post.pictureURL,
      shareLink: post.shareLink,
      createdBy: post.createdBy,
      createdAt: post.createdAt,
      updatedAt: post.updatedAt,
      inscription: post.inscription,
      inscriptionFormat: post.inscriptionFormat,
      youLearn: post.youLearn,
      youLearnFormat: post.youLearnFormat,
      facilitator: post.facilitator,
      startDate: post.startDate,
      duration: post.duration,
      schedule: post.schedule,
      cost: post.cost,
      area: post.area,
      course: post.course,
      address: post.address,
      latitude: post.latitude,
      longitude: post.longitude,
    );
  }
}
