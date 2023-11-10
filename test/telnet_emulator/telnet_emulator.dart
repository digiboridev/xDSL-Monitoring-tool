// ignore_for_file: avoid_print
import 'dart:io';

Future<void> main(List<String> args) async {
  print('Emulator started in standalone mode');

  final file = File('test/telnet_emulator/stats_examples/bcmstats_adsl.txt');
  const cmd = 'adsl info --show';

  // final file = File('test/telnet_emulator/stats_examples/trendchip_diag.txt');
  // final cmd = 'wan adsl diag';

  await startEmulator(command2Stats: (cmd: cmd, file: file));
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
    print('EMU New connection from ${socket.remoteAddress.address}:${socket.remotePort}');

    try {
      final stream = socket.map((event) => String.fromCharCodes(event).trim()).asBroadcastStream();
      stream.forEach((event) => print('EMU Incoming: $event'));

      // Send greeting message
      socket.writeln('Copyright (c) 1994 - 1337 Digibori Communications Corp.');

      // Login ask procedure
      if (loginSkip == false) {
        print('login ask');
        socket.writeln('Login:');
        String data = await stream.first;
        if (data != login) {
          print('login incorrect, got:$data expect: $login');
          socket.writeln('Login incorrect');
          socket.destroy();
          return;
        }
      }

      // Password ask procedure
      if (passwordSkip == false) {
        print('password ask');
        socket.writeln('Password:');
        String data = await stream.first;
        if (data != password) {
          print('password incorrect, got:$data expect: $password');
          socket.writeln('Bad Password!!!');
          socket.destroy();
          return;
        }
      }

      // Login successful - ready to receive commands
      print('auth successful');
      socket.writeln('$prefix>');

      // Answer to bcm63xx shell command
      if (shellSkip == false) {
        print('shell cmd wait');
        String data = await stream.first;
        if (data == 'sh') socket.writeln('$prefix#');
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
