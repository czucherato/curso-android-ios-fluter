import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(title: "Contador de Pessoas", home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _people = 0;
  void changePeople(int delta) {
    setState(() {
      _people += delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset("images/restaurant.jpg", fit: BoxFit.cover, height: 1000),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Pessoas: $_people",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: FlatButton(
                  child: Text("+1",
                      style: TextStyle(fontSize: 40, color: Colors.white)),
                  onPressed: () {
                    changePeople(1);
                  })),
          Padding(
              padding: EdgeInsets.all(10),
              child: FlatButton(
                  child: Text("-1",
                      style: TextStyle(fontSize: 40, color: Colors.white)),
                  onPressed: () {
                    changePeople(-1);
                  }))
        ]),
        Text(
            _people < 0
                ? "Mundo Invertido?"
                : _people >= 10
                    ? "Está Lotado!"
                    : "Pode Entrar!",
            style: TextStyle(
                color: Colors.white, fontStyle: FontStyle.italic, fontSize: 30))
      ])
    ]);
  }
}
