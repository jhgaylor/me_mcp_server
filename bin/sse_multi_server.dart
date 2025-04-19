import 'dart:io';

import 'package:me_mcp_server/me_mcp_server.dart';
import 'package:me_mcp_server/src/statelessSseServerManager.dart';

Future<void> main() async {
  final config = Config();
  await config.loadConfig();

  final sseServerManager = StatelessSseServerManager(
    () async => await createMcpServer(),
  );
  try {
    final server = await HttpServer.bind(
      config.host == '0.0.0.0'
          ? InternetAddress.anyIPv4
          : InternetAddress(config.host),
      config.port,
    );
    print('Server listening on http://${config.host}:${config.port}');

    await for (final request in server) {
      sseServerManager.handleRequest(request);
    }
  } catch (e) {
    print('Error starting server: $e');
    exitCode = 1;
  }
}
