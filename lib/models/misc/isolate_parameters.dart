import 'dart:isolate';
import 'package:xdsl_mt/models/modemClients/client.dart';

class IsolateParameters {
  Client client;
  SendPort sendPort;
  int samplingInterval;

  IsolateParameters(this.client, this.sendPort, this.samplingInterval);
}