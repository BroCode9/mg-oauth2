import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'mg_models.g.dart';

@JsonSerializable()
class MgUser {
  var id;
  var displayName;
  var givenName;
  var jobTitle;
  var mail;
  var mobilePhone;
  var officeLocation;
  var photoBase64;

  MgUser(
      {this.displayName,
      this.givenName,
      this.jobTitle,
      this.mail,
      this.mobilePhone,
      this.officeLocation,
      this.photoBase64});

  factory MgUser.fromJson(Map<String, dynamic> json) => _$MgUserFromJson(json);

  Map<String, dynamic> toJson() => _$MgUserToJson(this);
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

  ScopeBuilder calendarsRead() {
    _result += " calendars.read";
    return this;
  }

ScopeBuilder contactsRead() {
    _result += " contacts.read";
    return this;
  }

ScopeBuilder peopleRead() {
    _result += " people.read";
    return this;
  }

  ScopeBuilder userReadBasicAll() {
    _result += " user.readbasic.all";
    return this;
  }

  String build() {
    return _result.trim();
  }
}
