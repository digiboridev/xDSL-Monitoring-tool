// ignore_for_file: avoid_print
import 'dart:io';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  print('Emulator started in standalone mode');

  await startEmulator(
    command2Stats: (
      cmd: 'adsl info --show',
      file: File(
        p.join(Directory.current.path, 'test', 'telnet_emulator', 'stats_examples', 'bcmstats.txt'),
      ),
    ),
  );

  // await startEmulator(
  //   command2Stats: (
  //     cmd: 'wan adsl diag',
  //     file: File(
  //       p.join(Directory.current.path, 'test', 'telnet_emulator', 'stats_examples', 'trendchip_diag.txt'),
  //     ),
  //   ),
  // );
}

Future<Future Function()> startEmulator({
  String login = 'admin',
  String password = 'admin',
  String prefix = 'emu',
  bool loginSkip = false,
  bool passwordSkip = false,
  bool shellSkip = false,
  required ({String cmd, File file}) command2Stats,
}) async {
  final serverSocket = await ServerSocket.bind('0.0.0.0', 23, shared: true);

  serverSocket.forEach((socket) async {
    print('New connection from ${socket.remoteAddress.address}:${socket.remotePort}');

    try {
      final stream = socket.map((event) => String.fromCharCodes(event).trim()).asBroadcastStream();
      stream.forEach((event) => print('Incoming: $event'));

      // Send greeting message
      socket.writeln('Copyright (c) 1994 - 1337 Digibori Communications Corp.');

      // Login ask procedure
      if (loginSkip == false) {
        socket.writeln('Login:');
        String unitLogin = await stream.first;
        if (unitLogin != login) {
          socket.writeln('Login incorrect');
          socket.destroy();
          return;
        }
      }

      // Password ask procedure
      if (passwordSkip == false) {
        socket.writeln('Password:');
        String unitPassword = await stream.first;
        if (unitPassword != password) {
          socket.writeln('Bad Password!!!');
          socket.destroy();
          return;
        }
      }

      // Login successful - ready to receive commands
      socket.writeln('$prefix>');

      // Answer to bcm63xx shell command
      if (shellSkip == false) {
        stream.where((event) => event == 'sh').forEach((element) => socket.writeln('$prefix#'));
      }

      // Answer to stats fetch command
      stream.where((event) => event == command2Stats.cmd).forEach((_) async {
        String stats = await command2Stats.file.readAsString();
        socket.writeln(stats);
      });
    } catch (e) {
      print('Error: $e');
      socket.destroy();
    }
  });

  // Returns function that closes emulator
  return serverSocket.close;
}
