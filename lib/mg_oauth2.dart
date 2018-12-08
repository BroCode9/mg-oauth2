import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class MgOauth2 {
  static const MethodChannel _channel = const MethodChannel('plugin.screen');

  static Future<String> openLoginScreen(MgOuath2AuthorizeModel model) async {
    final String result = await _channel.invokeMethod("openLoginScreen", model.toJSON());

    final String url = "https://login.microsoftonline.com/common/oauth2/v2.0/token";

    final String body = 
      "client_id=eeffec03-c281-4980-b6c0-8c5cbb564dc4"+
      "&scope=offline_access%20user.read%20mail.read"+
      "&code=$result" +
      "&redirect_uri=https://login.microsoftonline.com/common/oauth2/nativeclient"+
      "&grant_type=authorization_code"+
      r"&client_secret=vxgoR79;rqnSKAVPT128^$|";

    final Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
    };

    var result2 = await http.post(url, headers: headers, body: body, encoding: Encoding.getByName("utf-8"));
    if(result2.statusCode == 200) {
      result2.body;
    }
    
    return result;
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
