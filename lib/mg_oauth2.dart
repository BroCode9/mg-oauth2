import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MgOauth2 {
  static const MethodChannel _channel = const MethodChannel('plugin.screen');

  static Future<String> openLoginScreen(MgOuath2AuthorizeModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var access_token = prefs.getString("access_token");

    if (access_token == null) {
      access_token =
          await _channel.invokeMethod("openLoginScreen", model.toJSON());
      await fetchAccessToken(access_token);
    }

    var fMe = await fetchMe(access_token);
    var fMePhoto = await fetchMyPhoto(access_token);

    return access_token;
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

    var result2 = await http.post(url, headers: headers, body: body);
    if (result2.statusCode == 200) {
      var bodyMap = json.decode(result2.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('access_token', bodyMap["access_token"]);
      await prefs.setString('refresh_token', bodyMap["refresh_token"]);
    }
  }

  static Future<Object> fetchMe(access_token) async {
    var url = 'https://graph.microsoft.com/v1.0/me';

    final Map<String, String> headers = {
      "Authorization": access_token,
      "Content-Type": "application/x-www-form-urlencoded",
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    return "-";
  }

  static Future<void> fetchMyPhoto(accessToken) async {
    var url = "https://graph.microsoft.com/v1.0/me/photo/\$value";

    final Map<String, String> headers = {
      "Authorization": accessToken,
      "Content-Type": "application/x-www-form-urlencoded",
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    }

    return "-";
  }
}

class MgOuath2AuthorizeModel {
// https://login.microsoftonline.com/common/oauth2/v2.0/authorize?";
// loginURL = loginURL + "client_id=fff403f0-5ed9-4b13-b8b0-1ded3932302c";
// loginURL = loginURL + "&response_type=code";
// loginURL = loginURL + "&redirect_uri=http%3A%2F%2Flocalhost%3A8080%2F";
// loginURL = loginURL + "&response_mode=query";
// loginURL = loginURL + "&scope=user.readbasic.all";
// loginURL = loginURL + "&state=12345";
// loginURL = loginURL + "domain_hint=levi9.com";

  String _baseURL = "https://login.microsoftonline.com/common/oauth2";
  String _authorizeURL = "/v2.0/authorize?";
  String _clientID;
  String _responseType;
  String _redirectURI;
  String _responseMode;
  String _scope;
  String _state;

  MgOuath2AuthorizeModel(this._clientID, this._responseType, this._redirectURI,
      this._responseMode, this._scope, this._state);

  String toJSON() {
    return json.encode({
      "url": _baseURL + _authorizeURL,
      "clientID": _clientID,
      "response": _responseType,
      "redirectURI": _baseURL + _redirectURI,
      "responseMode": _responseMode,
      "scope": _scope,
      "state": _state
    });
  }
}

class ResponseType {
  static String code() {
    return "code";
  }
}

class ResponseMode {
  static String query() {
    return "query";
  }
}

class ScopeBuilder {
  String _result = "";

  ScopeBuilder offlineAccess() {
    _result += " offline_access";
    return this;
  }

  ScopeBuilder userRead() {
    _result += " user.read";
    return this;
  }

  ScopeBuilder mailRead() {
    _result += " mail.read";
    return this;
  }

  String build() {
    return _result.trim();
  }
}
