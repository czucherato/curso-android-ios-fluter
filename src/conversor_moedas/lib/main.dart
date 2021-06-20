import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

void main() async {

  runApp(MaterialApp(
    home: Home(),
      theme: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            hintStyle: TextStyle(color: Colors.amber),
          ))
  ));
}

Map<String, dynamic> queryString = {
  "format": "json",
  "key": "e35ed101",
};

var url =
Uri.https('api.hgbrasil.com', '/finance', queryString);

Future<Map> getData() async {
  var response = await http.get(url);
  return json.decode(response.body);
}