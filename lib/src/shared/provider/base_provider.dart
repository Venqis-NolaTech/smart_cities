import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart' show BehaviorSubject;

import '../../di/injection_container.dart' as di;
import 'view_state.dart';

abstract class BaseProvider extends ChangeNotifier {
  final bool inTest;

  StreamSubscription<ViewState> _subscription;
  StreamSubscription<ConnectivityResult> _connectionSubscription;
  BehaviorSubject<ViewState> _stateController;

  ViewState get initialState => Idle();
  ViewState get currentState => _stateController.value;

  StreamSubscription<Map<String, dynamic>> _notificationSubscription;

  bool _notifyStatusChanges = true;
  bool _firstConnectionListen = true;

  bool _dispose = false;
  bool get isDispose => _dispose;

  get state => _stateController.stream;

  set state(ViewState newState) {
    if (_stateController?.isClosed ?? true) return;

    _stateController?.add(newState);
  }

  BaseProvider({this.inTest = false}) {
    _handleStatusChange();
    _handleInternetConnection();
    //_handleNotificationListener();

    init();
  }

  void enableStatusChanges() => _notifyStatusChanges = true;

  void disableStatusChanges() => _notifyStatusChanges = false;

  @protected
  void init() {
    // TODO: children implement.
  }

  @protected
  void notificationListen(NotificationData notification) {
    //TODO: children implement.
  }

  void refreshData() async {
    //TODO: children implement.
  }

  void _handleStatusChange() {
    _stateController = BehaviorSubject();

    state = initialState;

    _subscription = _stateController.stream.listen(
      (viewState) {
        if (_notifyStatusChanges) notifyListeners();
      },
    );
  }

  void _handleInternetConnection() {
    if (inTest != true) {
      final _connectivity = di.sl<Connectivity>();

      _connectionSubscription = _connectivity.onConnectivityChanged.listen(
        (ConnectivityResult result) {
          if (result != ConnectivityResult.none && !_firstConnectionListen) {
            refreshData();
          }

          _firstConnectionListen = false;
        },
      );
    }
  }

  // Future _handlePostCommentNotification(NotificationData notification) async {
  //   final setNewPostCommentUseCase = di.sl<SetNewPostCommentUseCase>();

  //   if (notification.type == NotificationType.postComment)
  //     await setNewPostCommentUseCase(notification.data);
  // }

  // void _handleNotificationListener() {
  //   _notificationSubscription = notificationStream?.listen((message) async {
  //     final data = Map<String, dynamic>.from(
  //         message.containsKey('data') ? message['data'] : message);
  //     final type = NotificationTypeEXtension.find(data['type']);

  //     final notification = NotificationData(data: data, type: type);

  //     await _handlePostCommentNotification(notification);

  //     notificationListen(notification);
  //   });
  // }

  @override
  void dispose() {
    _dispose = true;

    _subscription?.cancel();
    _connectionSubscription?.cancel();
    _notificationSubscription?.cancel();

    _stateController?.close();

    super.dispose();
  }
}

// Notifications
enum NotificationType {
  channelRequestPending,
  changeRole,
  chat,
  postComment,
}

extension NotificationTypeEXtension on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.channelRequestPending:
        return "CONTAINER_PENDING_REQUEST";
      case NotificationType.changeRole:
        return "CHANGED_ROLE";
      case NotificationType.chat:
        return "CHAT";
      case NotificationType.postComment:
        return "POST_COMMENT";
    }

    return null;
  }

  static find(String value) => NotificationType.values.firstWhere(
        (e) => e.value == value,
        orElse: null,
      );
}

class NotificationData extends Equatable {
  final NotificationType type;
  final Map<String, dynamic> data;

  NotificationData({this.type, this.data});

  @override
  List<Object> get props => [
        type,
        data,
      ];
}
