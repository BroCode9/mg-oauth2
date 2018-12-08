import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MgOauth2 {
  static const MethodChannel _channel = const MethodChannel('plugin.screen');

  static Future<String> openLoginScreen(MgOuath2AuthorizeModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString("access_token");

    if (accessToken == null) {
      accessToken = await _channel.invokeMethod("openLoginScreen", model.toJSON());
      await fetchAccessToken(accessToken);
    }

    var fMe = await fetchMe(accessToken);

    return accessToken;
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

  static Future<Object> fetchMe(accessToken) async {
    var url = 'https://graph.microsoft.com/v1.0/me';

    final Map<String, String> headers = {
      "Authorization": accessToken,
      "Content-Type": "application/x-www-form-urlencoded",
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    return "-";
  }
}

class MgOuath2AuthorizeModel {
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
