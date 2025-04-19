import 'dart:io';

import 'package:mcp_dart/mcp_dart.dart';
import 'package:me_mcp_server/me_mcp_server.dart';

Future<void> main() async {
  final config = Config();
  await config.loadConfig();

  final mcpServer = await createMcpServer();

  try {
    final server = await HttpServer.bind(
      config.host == '0.0.0.0'
          ? InternetAddress.anyIPv4
          : InternetAddress(config.host),
      config.port,
    );
    print('Server listening on http://${config.host}:${config.port}');

    // Create a StreamableHTTPServerTransport with configuration options
    final streamableTransport = StreamableHTTPServerTransport(
      options: StreamableHTTPServerTransportOptions(
        // Generate a unique session ID for each client connection
        sessionIdGenerator: () => generateUUID(),
        // Enable JSON responses for simple request/response scenarios
        enableJsonResponse: true,
      ),
    );

    // Register the transport with the MCP server
    mcpServer.connect(streamableTransport);

    // Handle incoming HTTP requests
    await for (final HttpRequest request in server) {
      // Pass the request to the streamable transport
      streamableTransport.handleRequest(request);
    }
  } catch (e) {
    print('Error starting server: $e');
    exitCode = 1;
  }
}

String generateUUID() {
  final random = DateTime.now().millisecondsSinceEpoch.toString();
  return '$random-${random.hashCode.abs()}';
}
