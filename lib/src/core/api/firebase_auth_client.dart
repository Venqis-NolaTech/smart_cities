import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' show Client;
import 'package:meta/meta.dart';

import 'base_http_client.dart';

class FirebaseAuthHttpClient extends BaseHttpClient {
  FirebaseAuthHttpClient({
    @required this.firebaseAuth,
    @required Client client,
    @required DataConnectionChecker dataConnectionChecker,
  }) : super(
          client,
          dataConnectionChecker,
        );

  final FirebaseAuth firebaseAuth;

  @override
  Future<String> getToken() async {
    final currentUser = firebaseAuth.currentUser;
    return 'Bearer ${(await currentUser?.getIdToken()) ?? ""}';
  }
}
