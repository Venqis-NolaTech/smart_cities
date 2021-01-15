import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/util/flavor_config.dart';

DataConnectionChecker _initDataConnectionChecker() {
// ignore: non_constant_identifier_names
  final List<AddressCheckOptions> DEFAULT_ADDRESSES = List.unmodifiable([
    AddressCheckOptions(
      InternetAddress('1.0.0.1'),
      port: DataConnectionChecker.DEFAULT_PORT,
      timeout: DataConnectionChecker.DEFAULT_TIMEOUT,
    ),
    AddressCheckOptions(
      InternetAddress('8.8.4.4'),
      port: DataConnectionChecker.DEFAULT_PORT,
      timeout: DataConnectionChecker.DEFAULT_TIMEOUT,
    ),
    AddressCheckOptions(
      InternetAddress('208.69.38.205'),
      port: 80,
      timeout: DataConnectionChecker.DEFAULT_TIMEOUT,
    ),
  ]);

  final dataConnectionChecker = DataConnectionChecker();
  dataConnectionChecker.addresses = DEFAULT_ADDRESSES;

  return dataConnectionChecker;
}

initExternal(GetIt sl) async {
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => _initDataConnectionChecker());
  sl.registerLazySingleton(() => Connectivity());

  sl.registerLazySingleton(() => ImagePicker());
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton(() => GoogleMapsPlaces(
      apiKey: FlavorConfig?.instance?.values?.googlePlacesApiKey ?? ""));

  //TODO: only test.
  // sl.registerLazySingleton<http.Client>(() =>
  //     HttpClientWithInterceptor.build(interceptors: [HttpLogginInterceptor()]));
}
