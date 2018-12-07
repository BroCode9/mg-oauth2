import 'package:flutter/material.dart';
import 'dart:async';

import 'package:mg_oauth2/mg_oauth2.dart';

import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  openLoginScreen() {
    var mgOuath = new MgOuath2AuthorizeModel(
      "eeffec03-c281-4980-b6c0-8c5cbb564dc4",
      ResponseType.code(),
      "/nativeclient",
      ResponseMode.query(),
      ScopeBuilder().offlineAccess().userRead().mailRead().build(),
      "123"
    );
    MgOauth2.openLoginScreen(mgOuath).then((value) {
      setState(() {
        Fluttertoast.showToast(
          msg: value
        );
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
        body: new Center(
          child: new RaisedButton(
            onPressed: openLoginScreen,
            child: new Text("Open Login"),
          )
        )
      ),
    );
  }
}
