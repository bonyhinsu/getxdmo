import 'base_config.dart';
import 'dev_config.dart';
import 'prod_config.dart';

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String development = 'DEV';

  static const String production = 'PROD';

  late BaseConfig config;

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.production:
        return ProdConfig();
      default:
        return DevConfig();
    }
  }
  dynamic get apiBaseUrl {
    return config.apiHost;
  }
}
