

import 'base_config.dart';

class DevConfig implements BaseConfig {
  @override
  String get apiHost => "example.com";

  @override
  bool get reportErrors => false;

  @override
  bool get trackEvents => false;

  @override
  bool get useHttps => false;
}
