// ignore_for_file: avoid_print
import 'dart:io';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  print('Emulator started in standalone mode');
  await startEmulator();
}

startEmulator({
  String login = 'admin',
  String password = 'admin',
  String prefix = 'emu',
}) async {
  final serverSocket = await ServerSocket.bind('0.0.0.0', 24); // TODO use 23
  serverSocket.forEach((socket) async {
    print('New connection from ${socket.remoteAddress.address}:${socket.remotePort}');

    try {
      final stream = socket.map((event) => String.fromCharCodes(event).trim()).asBroadcastStream();
      stream.forEach((event) => print('Incoming: $event'));

      // Send greeting message
      socket.writeln('Copyright (c) 1994 - 1337 Digibori Communications Corp.');

      // Login ask procedure
      socket.writeln('Login:');
      String unitLogin = await stream.first;
      if (unitLogin != login) {
        socket.writeln('Login incorrect');
        socket.destroy();
        return;
      }

      // Password ask procedure
      socket.writeln('Password:');
      String unitPassword = await stream.first;
      if (unitPassword != password) {
        socket.writeln('Bad Password!!!');
        socket.destroy();
        return;
      }

      // Login successful - ready to receive commands
      socket.writeln('$prefix>');

      // Answer to bcm63xx commands
      stream.where((event) => event == 'sh').forEach((element) => socket.writeln('$prefix#'));
      stream.where((event) => event == 'adsl info --show').forEach((_) async {
        var filePath = p.join(Directory.current.path, 'test', 'telnet_emulator', 'bcmstats.txt');
        File bcmStats = File(filePath);
        String stats = await bcmStats.readAsString();
        socket.writeln(stats);
      });
    } catch (e) {
      print('Error: $e');
      socket.destroy();
    }
  });
}
