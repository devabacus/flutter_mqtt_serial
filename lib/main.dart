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
  String rxData = '';
  String _topic = 'ESP32/serialdata/rx';
  bool relayState = false;
  TextEditingController txContr = TextEditingController();

  parseMqttMsg(String msg){
    if(double.tryParse(msg) != null) setState(() => temp = msg);
    else if(msg.contains('ON')) setState(() => relayState = true);
    else if(msg.contains('OFF')) setState(() => relayState = false);
    else {
      setState(() {
        rxData = msg;
        Future.delayed(Duration(seconds: 5),(){rxData='';});
      });

    }
  }

  @override
  void initState() {
    _mqtt = MqttRoutine(mqttOnMessage: onMqtt, subTopic: "ESP32/serialdata/tx");
  }
  onMqtt(String msg,String topic){
    parseMqttMsg(msg);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              Text(
                temp,
                style: TextStyle(fontSize: 30),
              ),

              Expanded(
                child: SwitchListTile(
                  value: relayState,
                  onChanged: (val) {
                    _mqtt.publish(_topic, val?'1':'0');
                    setState(() {
                      relayState = val;
                    });
                  }
                ),
              )
            ],
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
            _mqtt.publish(_topic, txContr.text);
            print('отправляем ${txContr.text}');

          },
        )
      ],
    );
  }
}
