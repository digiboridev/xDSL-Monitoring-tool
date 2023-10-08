import 'dart:isolate';
import 'package:xdslmt/models/modemClients/client.dart';

class IsolateParameters {
  Client client;
  SendPort sendPort;
  int samplingInterval;

  IsolateParameters(this.client, this.sendPort, this.samplingInterval);
}
