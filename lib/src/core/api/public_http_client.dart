import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' show Client;
import 'package:meta/meta.dart';

import '../util/flavor_config.dart';
import 'base_http_client.dart';

class PublicHttpClient extends BaseHttpClient {
  PublicHttpClient({
    @required Client client,
    @required DataConnectionChecker dataConnectionChecker,
  }) : super(
          client,
          dataConnectionChecker,
        );

  @override
  Future<String> getToken() async {
    return FlavorConfig.instance.values.publicApiToken;
  }
}
