import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';
import '../../core/util/string_util.dart';

enum Flavor { DEV, PROD }

extension FlavorExtension on Flavor {
  String get env {
    switch (this) {
      case Flavor.DEV:
        return ".env.dev";
      case Flavor.PROD:
        return ".env.prod";
      default:
        return ".env.dev";
    }
  }
}

class FlavorValues {
  FlavorValues({
    @required this.baseApiUrl,
    @required this.publicApiToken,
    @required this.googlePlacesApiKey,
  });

  final String baseApiUrl;
  final String publicApiToken;
  final String googlePlacesApiKey;
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final FlavorValues values;
  static FlavorConfig _instance;

  factory FlavorConfig({
    @required Flavor flavor,
    @required FlavorValues values,
  }) {
    _instance ??= FlavorConfig._internal(
      flavor,
      flavor.toString().enumName(),
      values,
    );

    return _instance;
  }

  FlavorConfig._internal(
    this.flavor,
    this.name,
    this.values,
  );

  static FlavorConfig get instance {
    return _instance;
  }

  static init(Flavor flavor) async {
    await DotEnv().load(flavor.env);

    FlavorConfig(
      flavor: flavor,
      values: FlavorValues(
        baseApiUrl: DotEnv().env['BASE_API_URL'],
        publicApiToken: DotEnv().env['PUBLIC_API_TOKEN'],
        googlePlacesApiKey: DotEnv().env['GOOGLE_PLACES_API_KEY'],
      ),
    );
  }

  static bool isProduction() => _instance.flavor == Flavor.PROD;

  static bool isDevelopment() => _instance.flavor == Flavor.DEV;
}
