import 'dart:async';

import 'package:flutter/services.dart';

class MgOatuh2 {
  static const MethodChannel _channel =
      const MethodChannel('mg_oatuh2');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
