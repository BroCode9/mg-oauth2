import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mg_models.dart';

class MgOauth2 {
  static const String ACCESS_TOKEN = "access_token";
  static const MethodChannel _channel = const MethodChannel('plugin.screen');

  static Future<LoginScreenResponse> openLoginScreen(
      MgOuath2AuthorizeModel model) async {
    var accessCodeResult =
        await _channel.invokeMethod("openLoginScreen", model.toJSON());
    if (accessCodeResult != "result.canceled") {
      await fetchAccessToken(accessCodeResult);
      return LoginScreenResponse.ok;
    } else {
      return LoginScreenResponse.canceled;
    }
  }

  static Future<void> fetchAccessToken(code) async {
    final String url =
        "https://login.microsoftonline.com/common/oauth2/v2.0/token";

    final String body = "client_id=eeffec03-c281-4980-b6c0-8c5cbb564dc4" +
        "&scope=user.read" +
        "&code=$code" +
        "&redirect_uri=https://login.microsoftonline.com/common/oauth2/nativeclient" +
        "&grant_type=authorization_code";

    final Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result2 = await http.post(url, headers: headers, body: body);
    if (result2.statusCode == 200) {
      var bodyMap = json.decode(result2.body);

      await prefs.setString(ACCESS_TOKEN, bodyMap[ACCESS_TOKEN]);
      await prefs.setString('refresh_token', bodyMap["refresh_token"]);
    } else {
      await prefs.clear();
    }
  }

  static Future<MgUser> fetchMe() async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString(ACCESS_TOKEN);

    var url = 'https://graph.microsoft.com/v1.0/me';

    final Map<String, String> headers = {
      "Authorization": accessToken,
      "Content-Type": "application/x-www-form-urlencoded",
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return MgUser.fromJson(jsonDecode(response.body));
    }

    return MgUser();
  }

  static Future<String> fetchMyPhoto() async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString(ACCESS_TOKEN);
    var url = "https://graph.microsoft.com/v1.0/me/photo/\$value";

    final Map<String, String> headers = {
      "Authorization": accessToken,
      "Content-Type": "application/x-www-form-urlencoded",
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return response.body.toString();
    }

    return "-";
  }

  static Future<MgUser> fetchMyProfile() async {
    var user = await fetchMe();
    // var photoBase64 = await fetchMyPhoto();
    // user.photoBase64 = photoBase64;
    return user;
  }

  static Future<void> logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(ACCESS_TOKEN) != null;
  }

  static Future<void> startArActivity(user, photoBase64) async {
    user.photoBase64 = photoBase64;
    await _channel.invokeMethod("openArScreen", json.encode(user));
  }
}

enum LoginScreenResponse { ok, error, canceled }
