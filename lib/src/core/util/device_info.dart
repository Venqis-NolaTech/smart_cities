import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

enum BuildMode { DEBUG, PROFILE, RELEASE }

class DeviceInfo {
  Future<bool> get isPhysicalDevice async {
    if (Platform.isIOS) {
      return (await DeviceInfoPlugin().iosInfo).isPhysicalDevice;
    } else {
      return (await DeviceInfoPlugin().androidInfo).isPhysicalDevice;
    }
  }

  BuildMode currentBuildMode() {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return BuildMode.RELEASE;
    }
    var result = BuildMode.PROFILE;

    //Little trick, since assert only runs on DEBUG mode
    assert(() {
      result = BuildMode.DEBUG;
      return true;
    }());
    return result;
  }

  Future<String> appVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return 'v${packageInfo.version} (${packageInfo.buildNumber})';
  }

  Future<int> androidVersion() async {
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt;
  }

  Future<int> buildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return int.parse(packageInfo.buildNumber);
  }
}
