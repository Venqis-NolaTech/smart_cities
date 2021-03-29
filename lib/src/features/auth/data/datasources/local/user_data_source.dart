import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/error/exception.dart';
import '../../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<bool> setUser(UserModel user);
  UserModel getUser();

  Future<bool> setToken(String token);
  String getToken();

  Future<bool> setRefreshToken(String refreshToken);
  String getRefreshToken();

  Future<bool> setUserRequestAcepted(bool value);
  bool getUserRequestAcepted();

  Future<bool> setTimeSentEmailConfirmation(DateTime time);
  DateTime getTimeSentEmailConfirmation();
  
  Future<PositionModel> getCurrentLocation();

  Future<bool> clear();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  static const CURRENT_USER = 'current_user';
  static const TOKEN = 'token';
  static const REFRESH_TOKEN = 'refresh_token';
  static const USER_REQUEST_ACEPTED = 'user_request_acepted';
  static const SENT_EMAIL_CONFIRMATION_TIME = "sent_email_confirmation_time";

  UserLocalDataSourceImpl({
    @required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  @override
  Future<bool> setUser(UserModel user) {
    return sharedPreferences.setString(
        CURRENT_USER, json.encode(user.toJson()));
  }

  @override
  UserModel getUser() {
    final jsonStr = sharedPreferences.getString(CURRENT_USER);

    if (jsonStr != null) {
      return UserModel.fromJson(json.decode(jsonStr));
    } else {
      throw UserNotFoundException();
    }
  }

  @override
  Future<bool> setToken(String token) {
    return sharedPreferences.setString(TOKEN, token);
  }

  @override
  String getToken() {
    return sharedPreferences.getString(TOKEN);
  }

  @override
  Future<bool> setRefreshToken(String refreshToken) {
    return sharedPreferences.setString(REFRESH_TOKEN, refreshToken);
  }

  @override
  String getRefreshToken() {
    return sharedPreferences.getString(REFRESH_TOKEN);
  }

  @override
  Future<PositionModel> getCurrentLocation() async {
    bool isLocationServiceEnabled = await geolocator.isLocationServiceEnabled();

    if (isLocationServiceEnabled) {
      final locationData = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      return PositionModel(
        latitude: locationData.latitude,
        longitude: locationData.longitude,
      );
    } else {
      throw LocationServiceException(
          'Error getCurrentPosition, location service not enabled');
    }
  }

  @override
  Future<bool> clear() {
    return sharedPreferences.clear();
  }

  @override
  DateTime getTimeSentEmailConfirmation() {
    final time = sharedPreferences.getInt(SENT_EMAIL_CONFIRMATION_TIME) ?? 1;

    if (time > 0) return DateTime.fromMillisecondsSinceEpoch(time);

    return null;
  }

  @override
  bool getUserRequestAcepted() {
    return sharedPreferences.getBool(USER_REQUEST_ACEPTED);
  }

  @override
  Future<bool> setTimeSentEmailConfirmation(DateTime time) {
    return sharedPreferences.setInt(
        SENT_EMAIL_CONFIRMATION_TIME, time.millisecondsSinceEpoch);
  }

  @override
  Future<bool> setUserRequestAcepted(bool value) {
    return sharedPreferences.setBool(USER_REQUEST_ACEPTED, value);
  }

}
