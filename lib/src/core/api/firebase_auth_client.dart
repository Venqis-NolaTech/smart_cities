import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/api/base_dio_client.dart';


  class FirebaseAuthHttpClient extends BaseDioClient {
  FirebaseAuthHttpClient({
    @required this.firebaseAuth,
    @required DataConnectionChecker dataConnectionChecker,
  }) : super(
          dataConnectionChecker,
        );

  final FirebaseAuth firebaseAuth;

  @override
  Future<String> getToken() async {
    final currentUser = firebaseAuth.currentUser;
    return 'Bearer ${(await currentUser?.getIdToken()) ?? ""}';
  }
}
