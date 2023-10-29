// ignore_for_file: avoid_print
import 'dart:io';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  print('Emulator started in standalone mode');
  await startEmulator();
}

startEmulator() async {
  final serverSocket = await ServerSocket.bind('0.0.0.0', 23);
  serverSocket.forEach((socket) async {
    print('New connection from ${socket.remoteAddress.address}:${socket.remotePort}');
    final stream = socket.map((event) => String.fromCharCodes(event).trim()).asBroadcastStream();
    stream.forEach((event) => print('Incoming: $event'));

    socket.writeln('Login:');
    await stream.firstWhere((event) => event == 'loginau');
    socket.writeln('Password:');
    await stream.firstWhere((event) => event == 'passwordook');
    socket.writeln('emu>');
    await stream.firstWhere((event) => event == 'sh');
    socket.write('emu#');

    stream.where((event) => event == 'adsl info --show').forEach((_) async {
      var filePath = p.join(Directory.current.path, 'test', 'telnet_emulator', 'bcmstats.txt');
      File bcmStats = File(filePath);
      String stats = await bcmStats.readAsString();
      socket.writeln(stats);
    });
  });
}
