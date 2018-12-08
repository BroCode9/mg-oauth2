import 'package:flutter/material.dart';
import 'dart:async';

import 'package:mg_oauth2/mg_oauth2.dart';
import 'package:mg_oauth2/mg_models.dart';

import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _mgOauth;

  var _isLoggedIn;

  var _name = "";

  @override
  void initState() {
    super.initState();

    MgOauth2.isLoggedIn().then((value) {
      setState(() {
        _isLoggedIn = value;
      });
    });
    _mgOauth = new MgOuath2AuthorizeModel(
        "eeffec03-c281-4980-b6c0-8c5cbb564dc4",
        ResponseType.code(),
        "/nativeclient",
        ResponseMode.query(),
        ScopeBuilder().offlineAccess().userRead().mailRead().build(),
        "123");
  }

  openLoginScreen() {
    MgOauth2.openLoginScreen(_mgOauth).then((value) {
      setState(() {
        switch (value) {
          case LoginScreenResponse.ok:
            _isLoggedIn = true;
            Fluttertoast.showToast(msg: "Logged IN!");
            break;
          case LoginScreenResponse.canceled:
            Fluttertoast.showToast(msg: "User canceled");
            break;
          case LoginScreenResponse.error:
            _isLoggedIn = false;
            Fluttertoast.showToast(msg: "Failed to login...");
            break;
        }
      });
    });
  }

  fetchMyProfile() {
    MgOauth2.fetchMe().then((value) {
      setState(() {
        _name = value.displayName;
      });
    });
  }

  logout() {
    MgOauth2.logout().then((value) {
        setState(() {
          _isLoggedIn = false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('BroCode9 The Flutter Plugin'),
          ),
          body: new Flex(
            direction: Axis.vertical,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                    onPressed: _isLoggedIn ? null : openLoginScreen,
                    child: new Text("Login"),
                  ),
                  new RaisedButton(
                    onPressed: openLoginScreen,
                    child: new Text("Logout"),
                  ),
                ],
              ),
              new Center(
                child: new RaisedButton(
                  onPressed: fetchMyProfile,
                  child: new Text("Fetch my profile"),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 20),
                child: new Text(_name),
              )
            ],
          )),
    );
  }
}
