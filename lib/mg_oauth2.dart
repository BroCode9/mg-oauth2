import 'dart:async';

import 'package:flutter/services.dart';

class MgOauth2 {
  static const MethodChannel _channel =
      const MethodChannel('plugin.screen');

  // static Future<String> get platformVersion async {
  //   final String version = await _channel.invokeMethod('getPlatformVersion');
  //   return version;
  // }

  // static Future<String> get time async {
  //   final String time = await _channel.invokeMethod("startNewActivity");
  //   return time;
  // }

  static Future<String> get openLoginScreen async {
    final String result = await _channel.invokeMethod("openLoginScreen");
    return result;
  }
}
