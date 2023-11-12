// ignore_for_file: avoid_print
import 'dart:io';

Future<void> main(List<String> args) async {
  print('Emulator started in standalone mode');

  final file = File('test/telnet_emulator/stats_examples/bcmstats_adsl.txt');
  const cmd = 'adsl info --show';

  // final file = File('test/telnet_emulator/stats_examples/trendchip_diag.txt');
  // const cmd = 'wan adsl diag';

  await startEmulator(cmdResponses: [(cmd: cmd, response: file.readAsStringSync())]);
}

typedef C2R = ({String cmd, String response});

Future<Future Function()> startEmulator({
  String login = 'admin',
  String password = 'admin',
  String prefix = 'emu',
  bool loginSkip = false,
  bool passwordSkip = false,
  bool shellSkip = false,
  List<C2R> cmdResponses = const [],
  int chunkSize = 20,
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
        socket.writeln('Login:');
        print('EMU login wait');
        String data = await stream.first;
        print('EMU login received');
        if (data != login) {
          print('EMU login incorrect, got:$data expect: $login');
          socket.writeln('Login incorrect');
          socket.destroy();
          return;
        }
      }

      // Password ask procedure
      if (passwordSkip == false) {
        socket.writeln('Password:');
        print('EMU password wait');
        String data = await stream.first;
        print('EMU password received');
        if (data != password) {
          print('EMU password incorrect, got:$data expect: $password');
          socket.writeln('Bad Password!!!');
          socket.destroy();
          return;
        }
      }

      // Login successful - ready to receive commands
      print('EMU auth successful');
      socket.writeln('$prefix>');

      // Wait for shell permission command
      // (also known as "second stage login")
      if (shellSkip == false) {
        print('EMU shell cmd wait');
        await stream.firstWhere((data) => data == 'sh');
        print('EMU shell cmd received');
        socket.writeln('$prefix#');
      }

      // Bind command responses
      stream.forEach((event) async {
        for (final cmdResponse in cmdResponses) {
          print('EMU catched cmd: ${cmdResponse.cmd}');
          if (event.contains(cmdResponse.cmd)) {
            /// Split stats into chunks (aka packet size) and send them with delay
            /// to simulate real terminal network behavior
            final lines = cmdResponse.response.split('\n');
            for (var i = 0; i < lines.length; i += chunkSize) {
              print('EMU send chunk ${i + chunkSize}');
              if (i + chunkSize > lines.length) {
                socket.writeln(lines.sublist(i).join('\n'));
              } else {
                socket.writeln(lines.sublist(i, i + chunkSize).join('\n'));
              }
              await Future.delayed(const Duration(milliseconds: 10));
            }
          }
        }
      });
    } catch (e) {
      print('EMU Error: $e');
      socket.destroy();
    }
  });

  // Returns function that closes emulator
  return serverSocket.close;
}
