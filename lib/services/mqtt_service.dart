import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

class MqttService {
  // Використовуємо саме BrowserClient для вебу
  MqttBrowserClient client = MqttBrowserClient('ws://broker.hivemq.com', 'valery_unique_id');

  Future<void> connect(Function(String) onMessageReceived) async {
    client.port = 8000; // Порт для веб-сокетів
    
    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier('valery_unique_id')
        .startClean();

    try {
      await client.connect();
      
      // ЯКЩО ПІДКЛЮЧЕНО - ОБОВ'ЯЗКОВО ПІДПИСУЄМОСЯ
      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        //цей рядок каже додатку, які саме дані чекати
        client.subscribe('smart_home/valery/temp', MqttQos.atMostOnce);

        // Цей блок ловить повідомлення і міняє цифру на екрані
        client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
          final recMess = messages[0].payload as MqttPublishMessage;
          final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          
          // Відправляємо цифру в HomeScreen
          onMessageReceived(payload);
        });
      }
    } catch (e) {
      print('Помилка: $e');
      client.disconnect();
    }
  }
}
