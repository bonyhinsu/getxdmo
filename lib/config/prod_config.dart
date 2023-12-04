
import 'base_config.dart';

class ProdConfig implements BaseConfig {
  @override
  String get apiHost => "example.com";

  @override
  bool get reportErrors => true;

  @override
  bool get trackEvents => true;

  @override
  bool get useHttps => true;
}
