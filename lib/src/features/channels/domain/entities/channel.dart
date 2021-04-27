import 'package:equatable/equatable.dart';

import 'user_display.dart';

enum ChannelRole { open, close }

extension ChannelRoleExtension on ChannelRole {
  String get value => this.toString().split('.').last?.toUpperCase();

  static ChannelRole find(String value) => ChannelRole.values
      .firstWhere((v) => v.value == value?.toUpperCase(), orElse: () => null);
}

enum ChannelType { prd, other }

extension ChannelTypeExtension on ChannelType {
  String get value => this.toString().split('.').last?.toUpperCase();

  static ChannelType find(String value) => ChannelType.values
      .firstWhere((v) => v.value == value?.toUpperCase(), orElse: () => null);
}

enum ChannelStatus { none, pending, accepted }

extension ChannelStatusExtension on ChannelStatus {
  String get value => this.toString().split('.').last?.toUpperCase();

  static ChannelStatus find(String value) => ChannelStatus.values.firstWhere(
        (v) => v.value == value?.toUpperCase(),
        orElse: () => ChannelStatus.none,
      );
}

class ChannelListings extends Equatable {
  final int totalCount;
  final List<Channel> channels;

  ChannelListings({this.totalCount, this.channels});

  @override
  List<Object> get props => [totalCount, channels];
}

class Channel extends Equatable {
  final String id;
  final String name;
  final String description;
  final int membersCount;
  final String pictureUrl;
  final ChannelCategory category;
  final UserDisplay director;
  final ChannelRole role;
  final ChannelType type;
  final ChannelStatus status;
  final bool isPublic;
  final ChannelPermission permissions;
  final String userRole;

  Channel({
    this.id,
    this.name,
    this.description,
    this.membersCount,
    this.pictureUrl,
    this.category,
    this.director,
    this.role,
    this.type,
    this.status,
    this.isPublic,
    this.permissions,
    this.userRole,
  });

  bool get isOtherType => this.type == ChannelType.other;

  bool get isPRDType => this.type == ChannelType.prd;

  bool get isDirector =>
      this.userRole == "DIRECTOR" || this.userRole == "ADMIN";

  @override
  List<Object> get props => [
        id,
        name,
        description,
        membersCount,
        pictureUrl,
        category,
        director,
        role,
        type,
        status,
        isPublic,
        permissions,
        userRole,
      ];
}

class ChannelCategory extends Equatable {
  final String id;
  final String name;

  ChannelCategory({this.id, this.name});

  @override
  List<Object> get props => [id, name];
}

class ChannelPermission extends Equatable {
  final bool inviteUser;
  final bool addUser;
  final bool acceptUser;
  final bool removeUser;
  final bool readPost;
  final bool createPost;
  final bool disablePost;
  final bool silencePost;
  final bool addPicturePost;
  final bool addVideoPost;
  final bool addLivePost;
  final bool readComment;
  final bool createComment;
  final bool likePost;
  final bool sharePost;
  final bool seeOrganizationChart;
  final bool uploadFile;
  final bool deleteFile;
  final bool saveFolder;
  final bool deleteFolder;
  final bool createPoll;
  final bool createCalendar;

  ChannelPermission({
    this.inviteUser,
    this.addUser,
    this.acceptUser,
    this.removeUser,
    this.readPost,
    this.disablePost,
    this.silencePost,
    this.createPost,
    this.addPicturePost,
    this.addVideoPost,
    this.addLivePost,
    this.readComment,
    this.createComment,
    this.likePost,
    this.sharePost,
    this.seeOrganizationChart,
    this.uploadFile,
    this.deleteFile,
    this.saveFolder,
    this.deleteFolder,
    this.createPoll,
    this.createCalendar,
  });

  bool get noHavePermissionOnMyChannel =>
      !inviteUser && !addUser && !removeUser && !seeOrganizationChart;

  bool get noHavePermissionOnChannelDetail =>
      !createPost && !inviteUser && !addUser && !removeUser;

  bool get noHavePermissionOnPost =>
      !silencePost &&
      !createPost &&
      !inviteUser &&
      !addUser &&
      !removeUser &&
      !disablePost &&
      !seeOrganizationChart;

  bool get noHavePermissionOnFile => !uploadFile && !deleteFile;

  bool get noHavePermissionOnFolder => !saveFolder && !deleteFolder;

  bool get noHavePermissionOnAddFile =>
      noHavePermissionOnFile && noHavePermissionOnFolder;

  @override
  List<Object> get props => [
        inviteUser,
        addUser,
        removeUser,
        readPost,
        createPost,
        disablePost,
        silencePost,
        addPicturePost,
        addVideoPost,
        addLivePost,
        readComment,
        createComment,
        likePost,
        sharePost,
        seeOrganizationChart,
        uploadFile,
        deleteFile,
        saveFolder,
        deleteFolder,
        createPoll,
      ];
}

class AddUserChannelRequest extends Equatable {
  final String name;
  final String phoneNumber;
  final String role;
  final String dni;
  final bool force;
  final List<String> container;

  AddUserChannelRequest({
    this.name,
    this.phoneNumber,
    this.role,
    this.dni,
    this.force,
    this.container,
  });

  @override
  List<Object> get props => [
        name,
        phoneNumber,
        role,
        dni,
        force,
        container,
      ];
}

class AddUserChannelResponse extends Equatable {
  final ChannelStatus status;
  final bool userInContainer;

  AddUserChannelResponse({this.status, this.userInContainer});

  @override
  List<Object> get props => [status, userInContainer];
}

class ChannelStructure extends Equatable {
  final String id;
  final String name;
  final int level;
  final String pictureUrl;
  final String parentId;
  final UserDisplay director;
  final List<ChannelStructure> children;

  ChannelStructure({
    this.id,
    this.name,
    this.level,
    this.pictureUrl,
    this.parentId,
    this.director,
    this.children,
  });

  @override
  List<Object> get props => [
        id,
        name,
        level,
        pictureUrl,
        parentId,
        director,
        children,
      ];
}

class ChannelRequestsListings extends Equatable {
  final int totalCount;
  final List<ChannelRequest> requests;

  ChannelRequestsListings({this.totalCount, this.requests});

  @override
  List<Object> get props => [totalCount, requests];
}

class ChannelRequest extends Equatable {
  final String id;
  final Channel channel;
  final UserDisplay user;

  ChannelRequest({this.id, this.channel, this.user});

  @override
  List<Object> get props => [id, channel, user];
}
