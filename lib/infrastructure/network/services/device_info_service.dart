import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../model/device_info_model.dart';

class DeviceInfoService extends GetxService {
  late DeviceInfoPlugin _deviceInfo;
  late PackageInfo _packageInfo;

  Future<DeviceInfoModel> initService() async {
    if (GetPlatform.isAndroid) {
      return await getAndroidDeviceInfo();
    } else if (GetPlatform.isIOS) {
      return await getIOSDeviceInfo();
    } else if (GetPlatform.isWeb) {
      return await getWebBrowserInfo();
    } else {
      return DeviceInfoModel(
          deviceName: "",
          modelName: "",
          osVersion: "",
          uuid: "",
          buildVersion: "", deviceType: '', ip: '');
    }
  }

  ///Returns Android device info
  Future<DeviceInfoModel> getAndroidDeviceInfo() async {
    _deviceInfo = DeviceInfoPlugin();
    _packageInfo = await PackageInfo.fromPlatform();
    AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;

    return DeviceInfoModel(
        deviceName: androidInfo.device ?? "",
        modelName: androidInfo.model ?? "",
        osVersion: androidInfo.version.release ?? "",
        uuid: androidInfo.id ?? "",
        buildVersion: _packageInfo.buildNumber, deviceType: 'android', ip: '');
  }

  ///Returns IOS device info
  Future<DeviceInfoModel> getIOSDeviceInfo() async {
    _deviceInfo = DeviceInfoPlugin();
    _packageInfo = await PackageInfo.fromPlatform();
    IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
    return DeviceInfoModel(
        deviceName: iosInfo.name ?? "",
        modelName: iosInfo.model ?? "",
        osVersion: iosInfo.systemVersion ?? "",
        uuid: iosInfo.identifierForVendor ?? "",
        buildVersion: _packageInfo.buildNumber, deviceType: 'iOS', ip: '');
  }

  ///Returns Web browser info
  Future<DeviceInfoModel> getWebBrowserInfo() async {
    _deviceInfo = DeviceInfoPlugin();
    _packageInfo = await PackageInfo.fromPlatform();
    WebBrowserInfo webBrowserInfo = await _deviceInfo.webBrowserInfo;
    return DeviceInfoModel(
        deviceName: webBrowserInfo.browserName.toString(),
        modelName: webBrowserInfo.platform ?? "",
        osVersion: webBrowserInfo.appVersion ?? "",
        uuid: webBrowserInfo.vendorSub ?? "",
        buildVersion: _packageInfo.buildNumber, deviceType: 'web', ip: '');
  }
}
