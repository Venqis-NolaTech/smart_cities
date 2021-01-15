import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';

enum PostKind {
  news,
  announcement,
  training,
}

extension PostKindExtension on PostKind {
  String get value => this.toString().split('.').last.toUpperCase();

  String getLabel(BuildContext context) {
    switch (this) {
      case PostKind.training:
        return S.of(context).training;
      case PostKind.announcement:
        return S.of(context).announcement;
      case PostKind.news:
      default:
        return S.of(context).news;
    }
  }

  static PostKind find(String value) => PostKind.values.firstWhere(
        (e) => e?.value == value?.toUpperCase(),
        orElse: () => PostKind.news,
      );
}

class PostListings extends Equatable {
  final int total;
  final List<Post> posts;

  PostListings({
    this.total,
    this.posts,
  });

  @override
  List<Object> get props => [
        total,
        posts,
      ];
}

class Post extends Equatable {
  final String id;
  final PostKind kind;
  final bool isFeatured;
  final bool isActive;
  final int likeCount;
  final bool liked;
  final int commentCount;
  final String title;
  final String content;
  final String contentFormat;
  final String pictureURL;
  final String shareLink;
  final String createdBy;
  final String createdAt;
  final String updatedAt;

  Post({
    this.id,
    this.kind,
    this.isFeatured,
    this.isActive,
    this.liked,
    this.likeCount,
    this.commentCount,
    this.title,
    this.content,
    this.contentFormat,
    this.pictureURL,
    this.shareLink,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object> get props => [
        this.id,
        this.kind,
        this.isFeatured,
        this.isActive,
        this.liked,
        this.likeCount,
        this.commentCount,
        this.title,
        this.content,
        this.contentFormat,
        this.pictureURL,
        this.shareLink,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
      ];

  factory Post.from(
    Post post, {
    String id,
    PostKind kind,
    bool isFeatured,
    bool isActive,
    int likeCount,
    bool liked,
    int commentCount,
    String title,
    String content,
    String contentFormat,
    String pictureURL,
    String shareLink,
    String createdBy,
    String createdAt,
    String updatedAt,
  }) {
    return Post(
      id: id ?? post.id,
      kind: kind ?? post.kind,
      isFeatured: isFeatured ?? post.isFeatured,
      isActive: isActive ?? post.isActive,
      liked: liked ?? post.liked,
      likeCount: likeCount ?? post.likeCount,
      commentCount: commentCount ?? post.commentCount,
      title: title ?? post.title,
      content: content ?? post.content,
      contentFormat: contentFormat ?? post.contentFormat,
      pictureURL: pictureURL ?? post.pictureURL,
      shareLink: shareLink ?? post.shareLink,
      createdBy: createdBy ?? post.createdBy,
      createdAt: createdAt ?? post.createdAt,
      updatedAt: updatedAt ?? post.updatedAt,
    );
  }
}
