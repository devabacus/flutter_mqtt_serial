import 'package:flutter/material.dart';
import 'package:mqtt_serial/mqtt.dart';

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
  MqttRoutine _mqtt;
  String temp = 'Температура';
  String rxData = 'Получено';
  TextEditingController txContr = TextEditingController();


  @override
  void initState() {
    _mqtt = MqttRoutine(mqttOnMessage: onMqtt, subTopic: "ESP32/serialdata/tx");
  }
  onMqtt(String msg,String topic){
    setState(() {
      rxData = msg;
    });
    print('---------------topic = $topic---------msg = $msg');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            temp,
            style: TextStyle(fontSize: 30),
          ),
        ),
        SizedBox(height: 30),
        Text(rxData, style: TextStyle(fontSize: 20),),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: TextField(
            controller: txContr,
          ),
        ),
        SizedBox(height: 30),

        RaisedButton(
          child: Text('Отправить'),
          onPressed: () {
            _mqtt.publish('ESP32/serialdata/rx', txContr.text);
            print('отправляем ${txContr.text}');
          },
        )
      ],
    );
  }
}
