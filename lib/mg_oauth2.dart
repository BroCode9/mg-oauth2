import 'dart:async';

import 'package:flutter/services.dart';

class MgOauth2 {
  static const MethodChannel _channel =
      const MethodChannel('mg_oauth2');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
