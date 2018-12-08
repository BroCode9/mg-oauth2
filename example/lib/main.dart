import 'package:flutter/material.dart';

import 'package:mg_oauth2/mg_oauth2.dart';
import 'package:mg_oauth2/mg_models.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:typed_data' show Uint8List, ByteBuffer;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _mgOauth;

  var _isLoggedIn;

  MgUser _user = MgUser();

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
        ScopeBuilder()
        .userRead()
        .mailRead()
        .calendarsRead()
        .contactsRead()
        .peopleRead()
        .userReadBasicAll()
        .build(),
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
    MgOauth2.fetchMyProfile().then((value) {
      setState(() {
        _user = value;
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

  fetchMyPhoto() {
    MgOauth2.fetchMyPhoto().then((value) {
      setState(() {
              _user.photoBase64 = value;
            });
    });
  }

  startArActivity() {
    MgOauth2.startArActivity(_user);
  }

  ImageProvider getImageProvider() {
    // return Image.memory(Uint8List.view(_user.photoBase64 as ByteBuffer)).image;
    // return Image.memory(Uint8List.fromList(Utf8.encode(_user.photoBase64)).buffer).image;
    var list = new Utf8Encoder().convert(_user.photoBase64);
    var data = new Uint8List.fromList(list);
    
    // String header = "data:image/png;base64,";
    // String base64 = new Base64Encoder().convert(data);
    // String image = header + base64;

    return Image.memory(data).image;
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
                    onPressed: _isLoggedIn ? logout : null,
                    child: new Text("Logout"),
                  ),
                ],
              ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton(
                      onPressed: _isLoggedIn ? fetchMyProfile : null,
                      child: new Text("My profile"),
                    ),
                    new RaisedButton(
                      onPressed: _isLoggedIn ? fetchMyPhoto : null,
                      child: new Text("My Photo"),
                    )
                  ]),
              _user != null ? new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                    onPressed: startArActivity,
                    child: new Text("Secret Button"),
                  )
                ],
              ) : new Container(),
              _user.displayName != null
                  ? new Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Column(
                            children: <Widget>[
                              _user.photoBase64 != ""
                                  ? new Image(
                                      image: getImageProvider(),
                                    )
                                  : new Container(),
                              new Text(_user.displayName),
                              new Text(_user.mail),
                              new Text(_user.jobTitle),
                              new Text(_user.officeLocation)
                            ],
                          )
                        ],
                      ),
                    )
                  : new Container()
            ],
          )),
    );
  }
}
