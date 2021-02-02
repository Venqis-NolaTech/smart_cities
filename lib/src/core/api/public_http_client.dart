import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:meta/meta.dart';

import '../util/flavor_config.dart';
import 'base_dio_client.dart';

class PublicHttpClient extends BaseDioClient {
  PublicHttpClient({
    @required DataConnectionChecker dataConnectionChecker,
  }) : super(
          dataConnectionChecker
        );

  @override
  Future<String> getToken() async {
    return FlavorConfig.instance.values.publicApiToken;
  }
}
