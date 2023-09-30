import 'dart:isolate';

import '../modemClients/client.dart';

class IsolateParameters {
  Client client;
  SendPort sendPort;
  int samplingInterval;

  IsolateParameters(this.client, this.sendPort, this.samplingInterval);
}
