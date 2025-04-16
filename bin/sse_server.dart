import 'dart:io';

import 'package:mcp_dart/mcp_dart.dart';
import 'package:me_mcp_server/me_mcp_server.dart';

Future<void> main() async {
  final config = Config.instance;
  final mcpServer = createMcpServer();

  final sseServerManager = SseServerManager(mcpServer);
  try {
    final server = await HttpServer.bind(
      config.host == '0.0.0.0'
          ? InternetAddress.anyIPv4
          : InternetAddress(config.host),
      config.port,
    );
    print('Server listening on http://${config.host}:${config.port}');

    await for (final request in server) {
      // Handle each request asynchronously without awaiting
      unawaited(sseServerManager.handleRequest(request));
    }
  } catch (e) {
    print('Error starting server: $e');
    exitCode = 1;
  }
}

/// Marks a future as intentionally not being awaited.
void unawaited(Future<void> future) {
  // Catch any errors to prevent unhandled exceptions
  future.catchError((error, stackTrace) {
    print('Unhandled error in request: $error');
    print(stackTrace);
  });
}
