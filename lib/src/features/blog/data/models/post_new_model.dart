import '../../../../core/util/list_util.dart';
import '../../domain/entities/post.dart';

class PostListingsModel extends PostListings {
  PostListingsModel({
    int total,
    List<PostModel> posts,
  }) : super(
          total: total,
          posts: posts,
        );

  // Json
  factory PostListingsModel.fromJson(Map<String, dynamic> json) {
    return PostListingsModel(
      total: json['totalCount'],
      posts: (json['data'] as List).isNotNullOrNotEmpty
          ? List<PostModel>.from(
              json['data'].map((ad) => PostModel.fromJson(ad)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': total,
      'data': posts.isNotNullOrNotEmpty
          ? posts.map((post) => PostModel.fromEntity(post).toJson()).toList()
          : null,
    };
  }

  //Entity
  factory PostListingsModel.fromEntity(PostListingsModel listings) {
    return PostListingsModel(
      total: listings.total,
      posts: listings.posts,
    );
  }
}

class PostModel extends Post {
  PostModel({
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

  // Json
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
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
    };
  }

  //Entity
  factory PostModel.fromEntity(Post post) {
    return PostModel(
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
    );
  }
}
