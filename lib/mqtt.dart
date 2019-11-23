import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;

class MqttRoutine {
  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;
  StreamSubscription subscription;
  Function(String topic, String mqttMsg) mqttOnMessage;
  String subTopic;

  MqttRoutine({@required this.mqttOnMessage, @required this.subTopic}){
    connect();
  }


  connect() async {
    client = mqtt.MqttClient('95.213.252.43', '');
//    client = mqtt.MqttClient('31.184.255.40', '');
//    client = mqtt.MqttClient('95.213.235.188', '');
    client.port = 1883;
    client.logging(on: true);
    client.keepAlivePeriod = 30;

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier('esp32')
        // Must agree with the keep alive set above or not set
        .startClean() // Non persistent session for testing
        .keepAliveFor(30)
        // If you set this you must set a will message
        .withWillTopic('test/test')
        .withWillMessage('abacus message test')
        .withWillQos(mqtt.MqttQos.atMostOnce);
    print('MQTT client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect('abacus', '123qwe');
    } catch (e) {
      print(e);
    }

    // Check if we are connected
    if (client.connectionStatus.state == mqtt.MqttConnectionState.connected) {
      print('MQTT client подсоединился');
      connectionState = client.connectionStatus.state;
      subscribeToTopic(subTopic);
    } else {
      print('ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client.connectionStatus.state}');
      _disconnect();
    }

    if (true) subscription = client.updates.listen(_onMessage);
  }

  void _disconnect() {
    client.disconnect();
    subscription.cancel();
  }

  void subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
    }
  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    final mqtt.MqttPublishMessage recMess =
        event[0].payload as mqtt.MqttPublishMessage;
    String topic = event[0].topic;
    final String message =
        mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
     mqttOnMessage(message, topic);
    //mqttMessages.mqttSetMsg(topic+' / '+message);

  }

  void publish(String topic, String msg) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      final mqtt.MqttClientPayloadBuilder builder =
          mqtt.MqttClientPayloadBuilder();
      builder.addString(msg);
      client.publishMessage(topic, mqtt.MqttQos.values[0], builder.payload);
    }
  }
}
