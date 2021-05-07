import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../core/error/failure.dart';
import '../../features/auth/domain/usecases/logged_user_use_case.dart';
import 'current_user_provider.dart';
import 'view_state.dart';

abstract class PaginatedProvider<T> extends CurrentUserProvider {
  @protected
  var items = <T>[];

  @protected
  final controller = StreamController<List<T>>();

  PaginatedProvider({LoggedUserUseCase loggedUserUseCase})
      : super(loggedUserUseCase: loggedUserUseCase);

  Stream<List<T>> get stream => controller.stream;

  bool _disposeStart = false;

  int _totalPage = 0;

  int _page = 0;

  int get page => _page;

  int get count => 4;

  int _totalCount = 0;

  int get totalCount => _totalCount;

  @protected
  set totalCount(int value) => _totalCount;

  bool _isFirstTime = true;

  bool get isFirstTime => _isFirstTime;

  bool _isLoading = false;

  set isLoading(bool newValue) {
    _isLoading = newValue;

    if (!_disposeStart) notifyListeners();
  }

  bool get isLoading => _isLoading;

  Function onDataFecthed;

  @override
  void dispose() {
    _disposeStart = true;

    super.dispose();

    controller.close();
    items.clear();
  }

  @protected
  void clear() {
    _totalPage = 0;
    _page = 0;

    _isFirstTime = true;
    _isLoading = false;

    items.clear();
  }

  @override
  Future<void> refreshData() async {
    super.refreshData();

    clear();

    fetchData();
  }

  @protected
  Future<Either<Failure, PageData<T>>> processRequest();

  void fetchData() async {
    if (_isLoading || (_totalPage > 0 && _page + 1 > _totalPage)) return;

    if (_isFirstTime) {
      state = Loading();
    } else {
      isLoading = true;
    }

    _page++;

    final failureOrListings = await processRequest();

    failureOrListings.fold(
      (failure) {
        if (!_disposeStart) controller.sink.addError(failure);
      },
      (data) {
        _totalCount = data.totalCount;

        _totalPage = (_totalCount / count).ceil();

        items.addAll(data?.items ?? []);

        // make sure remove possible duplicates.
        items = items.toSet().toList();

        if (!_disposeStart) controller.sink.add(items);
      },
    );

    if (onDataFecthed != null && !_isFirstTime) {
      onDataFecthed();
    }

    if (_isFirstTime) {
      state = Loaded();
      _isFirstTime = false;
    } else {
      isLoading = false;
    }
  }
}

class PageData<T> extends Equatable {
  final int totalCount;
  final List<T> items;

  PageData({this.totalCount, this.items});

  @override
  List<Object> get props => [totalCount, items];
}
