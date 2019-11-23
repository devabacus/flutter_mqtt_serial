import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mqtt serial',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mqtt-serial'),
        ),
        body: BodyWidgets(),
      ),
    );
  }
}

class BodyWidgets extends StatefulWidget {
  @override
  _BodyWidgetsState createState() => _BodyWidgetsState();
}

class _BodyWidgetsState extends State<BodyWidgets> {
  String temp;

  String rxData;

  TextEditingController txContr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          temp,
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(height: 30),
        Text(rxData),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: txContr,
          ),
        ),
        RaisedButton(
          child: Text('Отправить'),
          onPressed: () {
            print('отправляем ${txContr.text}');
          },
        )
      ],
    );
  }
}
